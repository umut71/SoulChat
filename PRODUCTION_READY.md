# SoulChat – Production Ready (Finalize)

Tüm API anahtarları yerleştirildi, servisler bağlandı. Firebase soulchat-pro kullanılıyor.

## 1. API anahtarları – tek merkez

**Dosya:** `lib/core/config/app_config.dart`

| Servis | Değişken | Kullanım |
|--------|----------|----------|
| Abacus / RouteLLM (AI + Görsel) | `routeLlmApiKey`, `routeLlmBaseUrl` | AI Tools (chat, image generator) |
| Agora (Ses/Görüntü) | `agoraAppId`, `agoraCertificate` | Sesli/görüntülü arama, canlı yayın |
| Google Cloud (Harita + Çeviri) | `googleCloudApiKey` | Çeviri ekranı + Harita (Maps) |
| CoinGecko (Kripto) | `coingeckoApiKey` | Crypto Trading modülü |
| RevenueCat (Ödeme) | `revenueCatApiKey` | Premium / in-app satın alma |
| Firebase | `firebaseProjectId` vb. | soulchat-pro (Auth, Firestore, Storage) |

## 2. .env

Tüm anahtarlar `.env` içinde de tanımlı (CI/script kullanımı için). Uygulama doğrudan `AppConfig` kullanıyor.

## 3. Bağlanan modüller

- **Görsel (Image Generator):** AI Tools → RouteLLM/Abacus `generateImage()` ile çalışıyor.
- **Çeviri:** Translator ekranı → `GoogleCloudService.translate()` (Google Cloud API key).
- **Harita:** Maps ekranı → `GoogleCloudService.mapsApiKey` (WebView/SDK’da kullanılacak).
- **Firebase:** `firebase_config_io.dart` / `firebase_config_web.dart` → projectId: soulchat-pro.

## 4. Build

```bash
cd M:\SoulChat_Final
flutter pub get
flutter build apk --release
# Çıktı: build/app/outputs/flutter-apk/app-release.apk
```

Firebase için gerçek `apiKey`/`appId` değerlerini Firebase Console (soulchat-pro) üzerinden alıp `firebase_config_io.dart` ve `firebase_config_web.dart` içindeki placeholder’larla değiştirin; ardından yukarıdaki build komutunu tekrar çalıştırın.
