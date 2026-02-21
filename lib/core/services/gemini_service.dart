import 'package:flutter/foundation.dart' show debugPrint, kIsWeb, kDebugMode;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dio/dio.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/config/app_config.dart';

/// Google Cloud Gemini API.
/// Web'de CORS'u önlemek için Cloud Function proxy kullanılır.
/// Native platformlarda doğrudan REST API çağrısı yapılır.
class GeminiService {
  static String get _apiKey {
    final fromEnv = EnvConfig.googleApiKey;
    if (fromEnv.isNotEmpty) return fromEnv;
    return AppConfig.kGoogleApiKeyHardcodedTest.isNotEmpty
        ? AppConfig.kGoogleApiKeyHardcodedTest
        : AppConfig.googleCloudApiKey;
  }

  static String _classifyError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('api key') || s.contains('invalid') || s.contains('401') || s.contains('403') || s.contains('unauthorized') || s.contains('api_key')) return 'API Key Hatası';
    if (s.contains('quota') || s.contains('429') || s.contains('resource exhausted') || s.contains('rate limit')) return 'Kota Aşıldı';
    if (s.contains('disabled') || s.contains('not been used') || s.contains('enable')) return 'API Kapalı – Google Cloud Console\'dan Generative Language API\'yi etkinleştirin.';
    if (s.contains('timeout') || s.contains('timed out')) return 'Zaman Aşımı';
    if (s.contains('xmlhttprequest') || s.contains('cors') || s.contains('failed to fetch') || s.contains('cross-origin')) {
      return kIsWeb ? 'Web CORS Hatası – Proxy kullanılıyor, lütfen tekrar deneyin.' : 'CORS Hatası';
    }
    if (s.contains('socket') || s.contains('network') || s.contains('connection')) return 'İnternet Bağlantısı Yok';
    return 'Bağlantı Hatası';
  }

  /// Web'de Cloud Function proxy üzerinden Gemini'ye istek atar (CORS sorunu yaşanmaz).
  static Future<String> _sendViaProxy(String message) async {
    debugPrint('[GEMINI:PROXY] Web proxy üzerinden istek atılıyor...');
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (_) => true,
    ));
    final resp = await dio.post<Map<String, dynamic>>(
      AppConfig.geminiProxyUrl,
      data: {'prompt': message},
      options: Options(responseType: ResponseType.json),
    );
    if (resp.statusCode == 200 && resp.data != null) {
      final text = resp.data!['text'] as String? ?? '';
      if (text.isNotEmpty) {
        debugPrint('[GEMINI:PROXY] Proxy başarılı. (${text.length} karakter)');
        return text;
      }
      throw Exception('Proxy boş yanıt döndü.');
    }
    final errMsg = resp.data?['error']?.toString() ?? 'HTTP ${resp.statusCode}';
    debugPrint('[GEMINI:PROXY:ERR] $errMsg');
    throw Exception('Proxy Hatası: $errMsg');
  }

  /// Web'de proxy, native'de doğrudan Gemini REST API çağrısı.
  static Future<String> sendMessage(String message, {String? conversationId}) async {
    debugPrint('[GEMINI:1] sendMessage çağrıldı. platform=${kIsWeb ? "web(proxy)" : "native"}, mesaj uzunluğu=${message.length}');

    // Web'de CORS sorunu oluşmaması için Cloud Function proxy kullan
    if (kIsWeb) {
      try {
        return await _sendViaProxy(message);
      } catch (e) {
        debugPrint('[GEMINI:PROXY:FALLBACK] Proxy başarısız: $e');
        // Yalnızca geliştirme ortamında doğrudan API'ye fallback — production'da proxy deploy edilmeli
        if (!kDebugMode) {
          rethrow;
        }
        debugPrint('[GEMINI:PROXY:FALLBACK] DEBUG modda doğrudan API deneniyor...');
      }
    }

    final key = _apiKey;
    if (key.isEmpty) {
      debugPrint('[GEMINI:ERR] API anahtarı BOŞ!');
      throw Exception('API Key Hatası: Anahtar boş.');
    }

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'tr-TR,tr;q=0.9,en;q=0.8',
        },
        validateStatus: (_) => true,
      ));
      final url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$key';
      final body = {
        'contents': [
          {
            'parts': [
              {'text': message}
            ]
          }
        ],
        'generationConfig': {'maxOutputTokens': 1024, 'temperature': 0.7},
      };
      debugPrint('[GEMINI:2] Dio isteği atılıyor → generativelanguage.googleapis.com');
      final resp = await dio.post<Map<String, dynamic>>(
        url,
        data: body,
        options: Options(responseType: ResponseType.json),
      );

      debugPrint('[GEMINI:3] HTTP yanıtı: status=${resp.statusCode}');

      if (resp.statusCode == 200 && resp.data != null) {
        final data = resp.data!;
        final candidates = data['candidates'] as List?;
        String? text;
        if (candidates?.isNotEmpty == true) {
          final first = candidates!.first as Map<String, dynamic>?;
          final parts = first?['content']?['parts'] as List?;
          final firstPart = parts?.firstOrNull;
          text = firstPart is Map ? firstPart['text'] as String? : null;
        }
        if (text != null && text.isNotEmpty) {
          debugPrint('[GEMINI_SUCCESS] Cevap alındı! (${text.length} karakter)');
          return text.trim();
        }
        throw Exception('Gemini boş yanıt döndü.');
      }

      final errBody = resp.data?.toString() ?? '';
      debugPrint('[GEMINI:ERR] HTTP ${resp.statusCode}: $errBody');

      if (resp.statusCode == 403 ||
          errBody.contains('disabled') ||
          errBody.contains('not been used')) {
        throw Exception(
          'API Kapalı (${resp.statusCode}) – Google Cloud Console\'dan Generative Language API\'yi etkinleştirin:\n'
          'https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/overview',
        );
      }
      if (resp.statusCode == 400 && errBody.contains('API_KEY_INVALID')) {
        throw Exception(
            'API Anahtarı Geçersiz (400) – Google Cloud Console > Credentials\'dan kontrol edin.');
      }
      if (resp.statusCode == 429) {
        throw Exception('Kota Aşıldı (429) – Biraz bekleyip tekrar deneyin.');
      }
      throw Exception(
          'HTTP ${resp.statusCode}: ${errBody.length > 200 ? errBody.substring(0, 200) : errBody}');
    } catch (e) {
      if (e.toString().startsWith('API ') ||
          e.toString().startsWith('HTTP ') ||
          e.toString().startsWith('Kota') ||
          e.toString().startsWith('Gemini boş') ||
          e.toString().startsWith('Proxy')) {
        debugPrint('[GEMINI_DEBUG] Hata mesajı: $e');
        rethrow;
      }
      debugPrint('[GEMINI:ERR] İstisna: $e');
      final kind = _classifyError(e);
      debugPrint('[Gemini] *** $kind *** $e');
      throw Exception('$kind: $e');
    }
  }

  /// Basit bağlantı testi – terminale HTTP status kodu yazar.
  static Future<String> runSimpleMerhabaTest() async {
    debugPrint('[GEMINI:TEST] Merhaba testi başlıyor...');
    try {
      final result = await sendMessage('Merhaba, kısa bir cevap ver.');
      debugPrint('[GEMINI_SUCCESS] Merhaba testi başarılı: $result');
      return result;
    } catch (e) {
      debugPrint('[GEMINI:TEST:FAIL] $e');
      rethrow;
    }
  }

  /// Öneri listesi (quiz/sohbet); Gemini'den gerçek yanıt.
  static Future<List<String>> getSuggestions(String context) async {
    try {
      final prompt =
          'Aşağıdaki bağlama uygun 3 kısa sohbet önerisi ver. Sadece numaralı liste olarak yaz, başka açıklama yazma.\nBağlam: $context';
      final text = await sendMessage(prompt);
      final pattern = RegExp(r'^\d+[.)]\s*');
      final lines = text
          .split(RegExp(r'\n'))
          .map((e) => e.replaceFirst(pattern, '').trim())
          .where((e) => e.isNotEmpty)
          .take(3)
          .toList();
      return lines.isEmpty
          ? ['Merhaba!', 'Nasılsın?', 'Bugün ne yapalım?']
          : lines;
    } catch (e) {
      final kind = _classifyError(e);
      debugPrint('[Gemini] *** $kind *** getSuggestions: $e');
      return ['Merhaba!', 'Nasılsın?', 'Bugün ne yapalım?'];
    }
  }
}
