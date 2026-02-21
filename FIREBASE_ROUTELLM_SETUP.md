# Firebase (soulchat-pro) ve RouteLLM API Kurulumu

## Firebase (soulchat-pro)

1. [Firebase Console](https://console.firebase.google.com) → **soulchat-pro** projesi
2. Proje ayarlarından Android / iOS / Web uygulaması ekleyin ve indirin:
   - **Android:** `google-services.json` → `android/app/`
   - **iOS:** `GoogleService-Info.plist` → `ios/Runner/`
   - **Web:** Firebase config değerlerini aşağıya girin
3. Gerçek değerleri `lib/core/config/firebase_config_io.dart` ve `lib/core/config/firebase_config_web.dart` içinde placeholder'ların yerine yazın:
   - `apiKey`, `appId`, `messagingSenderId`, `storageBucket`, `databaseURL`
   - iOS: `iosClientId`, `iosBundleId`
   - Web: `authDomain`, `measurementId`

## RouteLLM API

1. [RouteLLM](https://routellm.com) veya API sağlayıcınızdan API anahtarı alın.
2. **Çalıştırırken:**
   ```bash
   flutter run --dart-define=ROUTE_LLM_API_KEY=your_api_key_here
   ```
3. **Veya** `lib/core/config/app_config.dart` içinde `routeLlmApiKey` varsayılan değerini kendi anahtarınızla değiştirin (versiyon kontrolüne koymayın).

## Uygulamayı çalıştırma

```bash
cd M:\SoulChat_Final
flutter pub get
flutter run -d chrome   # Web
flutter run            # Bağlı cihaz/emülatör
flutter build apk --release   # APK (Android)
```

Ana sayfadaki **Tüm Özellikler (203 ekran)** kartına tıklayarak tüm ekranlara gidebilirsiniz.
