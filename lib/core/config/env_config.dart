import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:soulchat/core/config/app_config.dart';
import 'package:soulchat/core/services/remote_config_service.dart';

/// Production: Önce .env, sonra Remote Config, sonra AppConfig.
/// Tek Google Cloud API anahtarı: Gemini, Harita, Çeviri, TTS, STT hepsi bunu kullanır (Vertex/Map key).
class EnvConfig {
  /// Tek Google Cloud API anahtarı – Gemini, Maps, Translate, TTS, STT hepsi bu getter üzerinden alır.
  /// Sıra: kGoogleApiKeyHardcodedTest → .env GOOGLE_API_KEY → AppConfig.googleCloudApiKey (Vertex/Map key).
  static String get googleApiKey {
    if (AppConfig.kGoogleApiKeyHardcodedTest.isNotEmpty) return AppConfig.kGoogleApiKeyHardcodedTest;
    final v = dotenv.env['GOOGLE_API_KEY']?.trim();
    if (v != null && v.isNotEmpty) return v;
    return AppConfig.googleCloudApiKey;
  }

  /// Boş bırakılmaz: .env yoksa DEMO_APP_ID kullanılır (ücretsiz deneme için console.agora.io'dan gerçek ID alın).
  static String get agoraAppId {
    final v = dotenv.env['AGORA_APP_ID']?.trim();
    if (v != null && v.isNotEmpty) return v;
    final r = RemoteConfigService.agoraAppId;
    if (r.isNotEmpty) return r;
    if (AppConfig.agoraAppId.isNotEmpty) return AppConfig.agoraAppId;
    return AppConfig.agoraDemoAppId;
  }

  /// Agora demo ID kullanılıyorsa true (gerçek App ID ayarlıysa false – canlı yayın/sesli oda açık).
  static bool get isAgoraDemoAppId => agoraAppId == AppConfig.agoraDemoAppId;

  static String get coingeckoApiKey {
    final v = dotenv.env['COINGECKO_API_KEY']?.trim();
    if (v != null && v.isNotEmpty) return v;
    return AppConfig.coingeckoApiKey;
  }

  /// RevenueCat (abonelik/ödeme). .env REVENUECAT_API_KEY veya AppConfig.revenueCatApiKey.
  static String get revenueCatApiKey {
    final v = dotenv.env['REVENUECAT_API_KEY']?.trim();
    if (v != null && v.isNotEmpty) return v;
    return AppConfig.revenueCatApiKey;
  }
}
