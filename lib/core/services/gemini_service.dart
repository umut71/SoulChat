import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dio/dio.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/config/app_config.dart';

/// Google Cloud Gemini API.
/// Ham HTTP kullanarak hata kodunu net görür; SDK'nın gizlediği detayları yakalar.
/// Web'de .env okunmayabiliyor; boşsa doğrudan AppConfig fallback kullanılır (GEÇİCİ).
class GeminiService {
  static String get _apiKey {
    final fromEnv = EnvConfig.googleApiKey;
    if (fromEnv.isNotEmpty) return fromEnv;
    return AppConfig.kGoogleApiKeyHardcodedTest.isNotEmpty
        ? AppConfig.kGoogleApiKeyHardcodedTest
        : AppConfig.googleCloudApiKey;
  }

  static GenerativeModel get _model => GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 1024,
          temperature: 0.7,
        ),
      );

  static String _classifyError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('api key') || s.contains('invalid') || s.contains('401') || s.contains('403') || s.contains('unauthorized') || s.contains('api_key')) return 'API Key Hatası';
    if (s.contains('quota') || s.contains('429') || s.contains('resource exhausted') || s.contains('rate limit')) return 'Kota Aşıldı';
    if (s.contains('disabled') || s.contains('not been used') || s.contains('enable')) return 'API Kapalı – Google Cloud Console\'dan Generative Language API\'yi etkinleştirin.';
    if (s.contains('timeout') || s.contains('timed out')) return 'Zaman Aşımı';
    if (s.contains('xmlhttprequest') || s.contains('cors') || s.contains('failed to fetch') || s.contains('cross-origin')) {
      return kIsWeb
          ? 'Web CORS Hatası – API Kapalı veya yetkisiz. Google Cloud Console\'dan Generative Language API\'yi etkinleştirin: https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/overview'
          : 'CORS Hatası';
    }
    if (s.contains('socket') || s.contains('network') || s.contains('connection')) return 'İnternet Bağlantısı Yok';
    return 'Bağlantı Hatası';
  }

  /// Ham HTTP ile Gemini REST API'sine istek atar – SDK'yı atlar, hata kodunu net gösterir.
  static Future<String> sendMessage(String message, {String? conversationId}) async {
    final key = _apiKey;
    // #region agent log
    debugPrint('[GEMINI:1] sendMessage çağrıldı. Key uzunluğu=${key.length}, mesaj uzunluğu=${message.length}');
    // #endregion
    if (key.isEmpty) {
      debugPrint('[GEMINI:ERR] API anahtarı BOŞ!');
      throw Exception('API Key Hatası: Anahtar boş.');
    }

    // Gemini Web-Strike: Dio ile web-safe istek (CORS engeline takılmaması için).
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
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$key';
      final body = {
        'contents': [{'parts': [{'text': message}]}],
        'generationConfig': {'maxOutputTokens': 1024, 'temperature': 0.7},
      };
      // #region agent log
      debugPrint('[GEMINI:2] Dio isteği atılıyor → generativelanguage.googleapis.com');
      // #endregion
      final resp = await dio.post<Map<String, dynamic>>(
        url,
        data: body,
        options: Options(responseType: ResponseType.json),
      );

      // #region agent log
      debugPrint('[GEMINI:3] HTTP yanıtı: status=${resp.statusCode}');
      // #endregion

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

      // Hatalı durum – tam body'yi logla
      final errBody = resp.data?.toString() ?? '';
      debugPrint('[GEMINI:ERR] HTTP ${resp.statusCode}: $errBody');

      // HTTP 403 / disabled
      if (resp.statusCode == 403 || errBody.contains('disabled') || errBody.contains('not been used')) {
        throw Exception(
          'API Kapalı (${resp.statusCode}) – Google Cloud Console\'dan Generative Language API\'yi etkinleştirin:\n'
          'https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/overview',
        );
      }
      if (resp.statusCode == 400 && errBody.contains('API_KEY_INVALID')) {
        throw Exception('API Anahtarı Geçersiz (400) – Google Cloud Console > Credentials\'dan kontrol edin.');
      }
      if (resp.statusCode == 429) {
        throw Exception('Kota Aşıldı (429) – Biraz bekleyip tekrar deneyin.');
      }
      throw Exception('HTTP ${resp.statusCode}: ${errBody.length > 200 ? errBody.substring(0, 200) : errBody}');
    } catch (e) {
      // HTTP katmanı dışında bir hata ise SDK ile de dene
      if (e.toString().startsWith('API ') || e.toString().startsWith('HTTP ') || e.toString().startsWith('Kota') || e.toString().startsWith('Gemini boş')) {
        debugPrint('[GEMINI_DEBUG] Hata mesajı: $e');
        rethrow;
      }
      // Ağ/timeout hatası
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
      return lines.isEmpty ? ['Merhaba!', 'Nasılsın?', 'Bugün ne yapalım?'] : lines;
    } catch (e) {
      final kind = _classifyError(e);
      debugPrint('[Gemini] *** $kind *** getSuggestions: $e');
      return ['Merhaba!', 'Nasılsın?', 'Bugün ne yapalım?'];
    }
  }
}
