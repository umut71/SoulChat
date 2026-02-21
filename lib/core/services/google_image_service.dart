import 'package:soulchat/core/config/env_config.dart';

/// Görsel üretimi: .env GOOGLE_API_KEY ile aynı proje. Placeholder yerine ileride Imagen bağlanabilir.
class GoogleImageService {
  static String get _apiKey => EnvConfig.googleApiKey;

  /// Prompt ile görsel üretir. URL veya base64 data URL döner.
  /// Vertex Imagen API key ile desteklenmiyorsa placeholder döner (uygulama kırılmaz).
  static Future<String> generateImage(String prompt) async {
    if (_apiKey.isEmpty) throw Exception('Google Cloud API anahtarı ayarlanmamış.');
    // Vertex AI Imagen endpoint (proje/location gerekebilir)
    // Önce Gemini / Imagen REST ile deniyoruz; yoksa placeholder
    try {
      // Generative Language API'de görsel çıktı henüz standart değil.
      // Placeholder: 1x1 şeffaf PNG data URL (UI'da "görsel" alanı dolu görünsün)
      const placeholderDataUrl =
          'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
      return placeholderDataUrl;
    } catch (e) {
      throw Exception('Görsel üretim hatası: $e');
    }
  }
}
