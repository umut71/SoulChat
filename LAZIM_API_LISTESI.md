# SoulChat – Lazım Olan API Listesi

Projede kullanılan veya kullanılacak tüm dış API / servis anahtarları ve nerede kullanıldıkları.

---

## 1. Firebase (soulchat-pro) – Zorunlu

**Ne işe yarar:** Auth, Firestore, Storage, Messaging, Analytics  
**Nerede:** `lib/core/config/firebase_config_io.dart`, `firebase_config_web.dart`, `main.dart`

| Değer | Açıklama | Nereden alınır |
|-------|----------|-----------------|
| **apiKey** | Web/Android/iOS API anahtarı | Firebase Console → Proje ayarları → Genel |
| **appId** | Uygulama ID (Android / iOS / Web ayrı) | Aynı yer |
| **messagingSenderId** | FCM gönderen ID | Aynı yer |
| **projectId** | `soulchat-pro` (zaten ayarlı) | - |
| **storageBucket** | `soulchat-pro.appspot.com` | Aynı yer |
| **databaseURL** | Realtime Database URL | Aynı yer |
| **authDomain** | Sadece Web: `soulchat-pro.firebaseapp.com` | Aynı yer |
| **measurementId** | Sadece Web: Analytics | Aynı yer |
| **iosClientId** | Sadece iOS (Google Sign-In) | Aynı yer |
| **iosBundleId** | Sadece iOS: `com.soulchat.app` | - |

**Nasıl eklenir:** Firebase Console’da soulchat-pro projesinde Android/iOS/Web uygulaması ekleyin; çıkan config değerlerini yukarıdaki dosyalardaki placeholder’ların yerine yazın. Android için `google-services.json` dosyasını `android/app/` içine koyun.

---

## 2. RouteLLM API – AI (Chat / Öneri)

**Ne işe yarar:** AI sohbet, öneri (12 AI aracı için backend)  
**Nerede:** `lib/core/config/app_config.dart`, `lib/core/services/route_llm_service.dart`

| Değer | Açıklama |
|-------|----------|
| **ROUTE_LLM_API_KEY** | RouteLLM API anahtarı (Bearer token) |
| **Base URL** | `https://api.routellm.com/v1` (zaten ayarlı) |

**Nasıl eklenir:**
- Çalıştırırken: `flutter run --dart-define=ROUTE_LLM_API_KEY=your_key`
- Veya `app_config.dart` içinde `routeLlmApiKey` varsayılan değerini kendi anahtarınızla değiştirin.

---

## 3. SoulChat Backend API (Opsiyonel)

**Ne işe yarar:** Auth, kullanıcı, sohbet, oyun, marketplace, cüzdan (kendi backend’iniz)  
**Nerede:** `lib/core/constants/api_endpoints.dart`

| Değer | Açıklama |
|-------|----------|
| **baseUrl** | `https://api.soulchat.app` (şu an sabit) |

Backend’i kendiniz yazacaksanız bu URL’i kendi API adresinizle değiştirin. API key / token genelde istek header’ında (örn. `Authorization`) kullanılır; endpoint listesi `api_endpoints.dart` içinde.

---

## 4. Agora (Ses / Görüntü) – Opsiyonel

**Ne işe yarar:** Sesli/görüntülü arama, canlı yayın (Voice Chat, Video Call, Live Streaming)  
**Nerede:** `pubspec.yaml` → `agora_rtc_engine` (henüz kodda App ID kullanımı yok)

| Değer | Açıklama |
|-------|----------|
| **Agora App ID** | Agora Console’dan alınan uygulama ID |
| **Token** | Güvenli kullanım için (Agora veya kendi token sunucunuz) |

**Nasıl eklenir:** [Agora Console](https://console.agora.io) → proje oluştur → App ID al. İleride ses/görüntü ekranlarında (voice_chat, video_call, live_streaming) bu App ID ve gerekirse token kullanılacak.

---

## 5. Google Sign-In – Opsiyonel

**Ne işe yarar:** “Google ile giriş”  
**Nerede:** `pubspec.yaml` → `google_sign_in`, Firebase config’teki `iosClientId` (iOS)

| Değer | Açıklama |
|-------|----------|
| **iOS:** `iosClientId` | Firebase config’te (GoogleService-Info.plist veya firebase_config) |
| **Android:** | `google-services.json` ile otomatik |
| **Web:** | Firebase config’teki `apiKey` vb. |

Firebase (soulchat-pro) ayarlarında “Sign-in method” kısmında Google’ı açmanız gerekir.

---

## Özet tablo

| # | Servis | Zorunlu mu? | Anahtar / Değer | Nereye yazılır |
|---|--------|-------------|------------------|----------------|
| 1 | **Firebase** | Evet | apiKey, appId, messagingSenderId, storageBucket, databaseURL, (web: authDomain, measurementId; iOS: iosClientId) | `firebase_config_io.dart`, `firebase_config_web.dart`, `google-services.json`, `GoogleService-Info.plist` |
| 2 | **RouteLLM** | AI kullanacaksanız evet | ROUTE_LLM_API_KEY | `--dart-define` veya `app_config.dart` |
| 3 | **SoulChat Backend** | Kendi API’nizi kullanacaksanız | baseUrl (ve gerekirse API key) | `api_endpoints.dart` (+ isteklerde header) |
| 4 | **Agora** | Ses/görüntü özellikleri için | App ID, (opsiyonel) Token | Henüz kodda yok; ileride config dosyası veya env |
| 5 | **Google Sign-In** | “Google ile giriş” için | iosClientId (iOS), diğerleri Firebase üzerinden | Firebase config + Console’da Google açık |

---

**Not:** API anahtarlarını `.git`’e eklemeyin; `.env` veya `--dart-define` ile verin veya CI/CD ortam değişkenlerinde tutun.
