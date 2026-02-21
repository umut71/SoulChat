import 'package:flutter/material.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/core/services/gemini_service.dart';

/// Sistem Denetleyici: Hata analizi ve DeepAgent – Google Cloud Gemini (gerçek kredi).
class SystemArchitectService {
  static String? _lastFixMessage;
  static String? get lastFixMessage => _lastFixMessage;

  /// Hatadan gerçek nedeni çıkarır; ikinci bir Gemini çağrısı yapmadan kullanıcıya net mesaj verir.
  static String _messageFromError(Object error) {
    final s = error.toString().toLowerCase();
    if (s.contains('api key') || s.contains('api_key') || s.contains('401') || s.contains('403') || s.contains('invalid') && s.contains('key') || s.contains('unauthorized')) {
      return 'API anahtarı eksik veya geçersiz. .env dosyasına GOOGLE_API_KEY yazın veya Google Cloud Console > Credentials\'dan kontrol edin.';
    }
    if (s.contains('quota') || s.contains('429') || s.contains('resource exhausted') || s.contains('rate limit')) {
      return 'Kota aşıldı. Biraz sonra tekrar deneyin veya Google Cloud kotanızı kontrol edin.';
    }
    if (s.contains('timeout') || s.contains('timed out')) {
      return 'Yanıt süresi aşıldı. İnternet bağlantınızı kontrol edip tekrar deneyin.';
    }
    if (s.contains('socket') || s.contains('connection') || s.contains('network') || s.contains('connection refused')) {
      return 'İnternet bağlantınızı kontrol edin.';
    }
    return 'Bağlantı kurulamadı. API anahtarını ve internet bağlantınızı kontrol edin.';
  }

  /// Hata yakalandığında gerçek nedeni gösterir; ikinci Gemini çağrısı yapılmaz (zaten başarısız olduğu için).
  static Future<String> reportErrorAndGetFix({
    required String module,
    required Object error,
    String? stackTrace,
  }) async {
    _lastFixMessage = null;
    if (EnvConfig.googleApiKey.isEmpty) {
      _lastFixMessage = 'API anahtarı yok. .env dosyasına GOOGLE_API_KEY yazın.';
      return _lastFixMessage!;
    }
    _lastFixMessage = _messageFromError(error);
    return _lastFixMessage!;
  }

  /// Ekranda "Hata" yerine gösterilecek mesaj; bilinen hata tipinde Gemini çağrılmaz.
  static Future<String> getFriendlyErrorMessage(String module, Object error) async {
    if (EnvConfig.googleApiKey.isEmpty) {
      return 'Bu özellik şu an kullanılamıyor. .env dosyasına GOOGLE_API_KEY yazın.';
    }
    final specific = _messageFromError(error);
    if (specific.contains('API anahtarı') || specific.contains('Kota aşıldı') || specific.contains('Yanıt süresi') || specific.contains('İnternet bağlantınızı') || specific.contains('Bağlantı kurulamadı')) {
      return specific;
    }
    try {
      final prompt = '''
Uygulama modülü hata verdi. Kullanıcıya tek cümleyle, samimi ve net bir şekilde (örnek: "Şu an Agora anahtarı eksik olduğu için yayını başlatamıyorum, lütfen ayarları kontrol et.") hatayı açıkla. Sadece bu tek cümleyi yaz, başka metin ekleme.

Modül: $module
Hata: $error
''';
      return await GeminiService.sendMessage(prompt);
    } catch (_) {
      return _messageFromError(error);
    }
  }

  static Future<bool> submitDevelopmentRequest(String userMessage) async {
    final lower = userMessage.toLowerCase();
    final isFeature = lower.contains('ekle') || lower.contains('özellik') || lower.contains('add') || lower.contains('feature');
    final isChange = lower.contains('değiştir') || lower.contains('change') || lower.contains('düzelt') || lower.contains('fix');
    if (!isFeature && !isChange) return false;
    try {
      await FirestoreService.addDevelopmentRequest(
        text: userMessage,
        type: isFeature ? 'feature' : 'change',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// DeepAgent: Gemini ile gerçek analiz – galaksiyi tarar, profesyonel rapor döner (Google Cloud kredisi).
  static Future<String> deepAgentAnalyze(String problemDescription) async {
    if (EnvConfig.googleApiKey.isEmpty) {
      return 'API Key Hatası: .env dosyasına GOOGLE_API_KEY (Google Cloud / Vertex AI) yazın.';
    }
    try {
      final prompt = '''
Uygulama genel durum analizi isteniyor. Teknik destek perspektifinden kısa ve profesyonel bir rapor ver (Türkçe, 2-4 cümle):
1) Tespit edilen olası sorunlar
2) Önerilen adımlar

Sorun/İstek: $problemDescription
''';
      return await GeminiService.sendMessage(prompt);
    } catch (e) {
      return _messageFromError(e);
    }
  }

  static void clearLastFixMessage() {
    _lastFixMessage = null;
  }

  static Future<void> handleErrorAndNotify(
    BuildContext? context, {
    required String module,
    required Object error,
    String? stackTrace,
  }) async {
    final fix = await reportErrorAndGetFix(module: module, error: error, stackTrace: stackTrace);
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(fix),
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
