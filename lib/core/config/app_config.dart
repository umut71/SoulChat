/// Production API keys – SoulChat (soulchat-pro).
/// Gerçek kullanıcı / piyasa sürümü: Google, Agora, RevenueCat, CoinGecko anahtarları ayarlı.
/// Override: .env veya Firebase Remote Config kullanılabilir.

class AppConfig {
  // --- Firebase (soulchat-pro) ---
  static const String firebaseProjectId = 'soulchat-pro';
  static const String firebaseStorageBucket = 'soulchat-pro.appspot.com';
  static const String firebaseAuthDomain = 'soulchat-pro.firebaseapp.com';
  static const String firebaseDatabaseUrl = 'https://soulchat-pro-default-rtdb.firebaseio.com';

  // --- Gemini Proxy (Cloud Function – Web CORS fix) ---
  /// Web'de Gemini API'sine doğrudan bağlantı CORS'a takılır.
  /// Bu Cloud Function URL'si üzerinden proxy yapılır.
  /// Deploy: firebase deploy --only functions
  static const String geminiProxyUrl =
      'https://us-central1-soulchat-pro.cloudfunctions.net/geminiProxy';

  // --- (Kullanılmıyor – AI artık sadece Gemini) RouteLLM fallback RemoteConfig için ---
  static const String routeLlmApiKey = '';
  static const String routeLlmBaseUrl = '';
  // --- Agora (canlı yayın / sesli sohbet) ---
  /// Agora App ID (Key). .env AGORA_APP_ID veya Remote Config ile override edilebilir.
  static const String agoraAppId = '854904e64ff44798b05cc5aaac4df078';
  /// Yedek (App ID boşken kullanılmaz; gerçek App ID ayarlı).
  static const String agoraDemoAppId = '0123456789abcdef0123456789abcdef';
  /// App Certificate (Secret) – sadece sunucuda token üretmek için kullanın; client'ta göstermeyin.
  static const String agoraCertificate = '6c6bd9f3016a4831af9bbbfe8cb9a45a';

  // --- Google Cloud (tek anahtar: Vertex/Map key – Gemini, Harita, Çeviri, TTS, STT hepsi bunu kullanır) ---
  /// Hardcoded – .env ve Remote Config'i atlayarak DOĞRUDAN bu key kullanılır.
  static const String kGoogleApiKeyHardcodedTest = 'AIzaSyB69cg48Z_t6gWeLVNr1MMplCceellFu2o';
  /// Fallback (kGoogleApiKeyHardcodedTest doluysa bu kullanılmaz).
  static const String googleCloudApiKey = 'AIzaSyB69cg48Z_t6gWeLVNr1MMplCceellFu2o';

  // --- CoinGecko (Kripto) ---
  static const String coingeckoApiKey = 'CG-wSepkYzwXVTnrkxucrTkfgg6';

  // --- RevenueCat (abonelik/ödeme). .env REVENUECAT_API_KEY veya bu değer kullanılır. ---
  static const String revenueCatApiKey = 'test_ugZEAPfOckaUCzLdJyOUNCpoZHN';
}
