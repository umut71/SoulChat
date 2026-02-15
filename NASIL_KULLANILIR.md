# 🚀 SoulChat - Nasıl Kullanılır?

## 📋 İÇİNDEKİLER
1. [Hızlı Başlangıç](#hızlı-başlangıç)
2. [Gereksinimler](#gereksinimler)
3. [Kurulum Adımları](#kurulum-adımları)
4. [APK Oluşturma](#apk-oluşturma)
5. [Firebase Kurulumu](#firebase-kurulumu)
6. [API Entegrasyonları](#api-entegrasyonları)
7. [Çalıştırma](#çalıştırma)
8. [Dosya Yapısı](#dosya-yapısı)

---

## 🚀 HIZLI BAŞLANGIÇ

### 3 Basit Adım:

```bash
# 1. Repoyu clone et
git clone https://github.com/umut71/SoulChat.git
cd SoulChat

# 2. Paketleri kur
flutter pub get

# 3. Çalıştır (Test için)
flutter run
```

**Veya APK oluştur:**
```bash
flutter build apk --release
```

---

## 📱 GEREKSİNİMLER

### Yazılım Gereksinimleri:

1. **Flutter SDK** (3.0 veya üstü)
   - İndir: https://docs.flutter.dev/get-started/install
   
2. **Dart SDK** (3.0 veya üstü)
   - Flutter ile birlikte gelir

3. **Android Studio** veya **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

4. **Android SDK** (API Level 21+)
   - Android Studio ile kurulur

5. **Git**
   - İndir: https://git-scm.com/

### Opsiyonel (iOS için):
- macOS
- Xcode 14+
- CocoaPods

---

## 🔧 KURULUM ADIMLARI

### 1. Flutter SDK Kurulumu

#### Windows:
```bash
# Flutter SDK'yı indir ve çıkart
# PATH'e ekle: C:\flutter\bin

# Kontrol et
flutter doctor
```

#### macOS/Linux:
```bash
# Flutter SDK'yı indir
git clone https://github.com/flutter/flutter.git -b stable

# PATH'e ekle
export PATH="$PATH:`pwd`/flutter/bin"

# Kontrol et
flutter doctor
```

### 2. Android Studio Kurulumu

1. Android Studio'yu indir ve kur
2. Android SDK'yı kur
3. Android emülatör oluştur
4. Flutter ve Dart eklentilerini yükle

### 3. Proje Kurulumu

```bash
# 1. Repoyu clone et
git clone https://github.com/umut71/SoulChat.git

# 2. Proje klasörüne git
cd SoulChat

# 3. Paketleri kur
flutter pub get

# 4. Bağımlılıkları kontrol et
flutter doctor

# 5. Cihazları listele
flutter devices
```

---

## 📦 APK OLUŞTURMA

### Release APK (Üretim):

```bash
# Tek APK (Tüm mimariler)
flutter build apk --release

# APK konumu:
# build/app/outputs/flutter-apk/app-release.apk
```

### Split APK (Daha küçük boyut):

```bash
# Mimari başına ayrı APK
flutter build apk --split-per-abi --release

# APK'lar:
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### Debug APK (Test için):

```bash
flutter build apk --debug
```

### Bundle (Play Store için):

```bash
flutter build appbundle --release

# Bundle konumu:
# build/app/outputs/bundle/release/app-release.aab
```

---

## 🔥 FIREBASE KURULUMU

### 1. Firebase Projesi Oluştur

1. https://console.firebase.google.com/ adresine git
2. "Add project" tıkla
3. Proje adı: **soulchat**
4. Analytics'i aktif et
5. Projeyi oluştur

### 2. Android App Ekle

1. Firebase Console'da "Add app" > Android
2. **Package name:** `com.soulchat.app`
3. App nickname: SoulChat
4. Debug signing certificate: (Opsiyonel)
5. "Register app"

### 3. google-services.json İndir

1. `google-services.json` dosyasını indir
2. Dosyayı şuraya kopyala:
   ```
   android/app/google-services.json
   ```

### 4. Firebase Servislerini Aktif Et

Firebase Console'da:
- ✅ **Authentication** - Sign-in methods:
  - Email/Password
  - Google
  - Phone
  
- ✅ **Cloud Firestore** - Database oluştur (Production mode)

- ✅ **Storage** - Storage bucket oluştur

- ✅ **Cloud Messaging** - Bildirimler için

- ✅ **Analytics** - Kullanıcı istatistikleri

### 5. Firebase Config Güncelle

`lib/core/config/firebase_config.dart` dosyasını aç:

```dart
static Future<void> initialize() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_SENDER_ID',
      projectId: 'soulchat',
      storageBucket: 'soulchat.appspot.com',
    ),
  );
}
```

**Firebase Console'dan değerleri kopyala!**

---

## 🔌 API ENTEGRASYONLARI

### 1. RouteLLM API

`lib/core/constants/api_endpoints.dart`:

```dart
static const String routeLLMApiKey = 'YOUR_ROUTELLM_API_KEY';
```

### 2. Agora (Video/Voice)

1. https://www.agora.io/ adresine git
2. Hesap oluştur
3. Yeni proje oluştur
4. App ID'yi al

`lib/core/constants/api_endpoints.dart`:

```dart
static const String agoraAppId = 'YOUR_AGORA_APP_ID';
```

### 3. AI Service API Keys

Kullanmak istediğin AI servisleri için:

- **OpenAI** (ChatGPT, DALL-E)
- **Stable Diffusion** (Image generation)
- **ElevenLabs** (Voice cloning)
- **Google Cloud** (Translation, TTS)

```dart
static const String openAiApiKey = 'YOUR_OPENAI_KEY';
static const String elevenLabsApiKey = 'YOUR_ELEVENLABS_KEY';
```

---

## ▶️ ÇALIŞTIRMA

### Emülatörde Çalıştır:

```bash
# Emülatörü başlat
flutter emulators --launch <emulator_id>

# Uygulamayı çalıştır
flutter run
```

### Fiziksel Cihazda Çalıştır:

```bash
# 1. USB debugging'i aç (Android cihazda)
# 2. Cihazı bilgisayara bağla
# 3. Cihazı kontrol et
flutter devices

# 4. Çalıştır
flutter run
```

### Hot Reload:

Uygulama çalışırken:
- `r` tuşu - Hot reload
- `R` tuşu - Hot restart
- `q` tuşu - Çıkış

### Debug Mode:

```bash
flutter run --debug
```

### Release Mode (Test):

```bash
flutter run --release
```

---

## 📂 DOSYA YAPISI

```
SoulChat/
├── android/              # Android projesi
├── ios/                  # iOS projesi
├── lib/                  # Ana kaynak kod
│   ├── core/            # Çekirdek (config, models, services)
│   ├── features/        # 27 özellik modülü
│   ├── shared/          # Paylaşılan (widgets, providers)
│   └── main.dart        # Başlangıç noktası
├── test/                # Test dosyaları
├── web/                 # Web projesi
├── pubspec.yaml         # Paket yönetimi
└── README.md            # Dokümantasyon
```

---

## 🛠️ YAYGINN SORUNLAR VE ÇÖZÜMLER

### Sorun 1: "Flutter SDK not found"

**Çözüm:**
```bash
flutter doctor
# PATH'e flutter/bin ekle
```

### Sorun 2: "SDK version conflict"

**Çözüm:**
```bash
flutter clean
flutter pub get
```

### Sorun 3: "Google Services plugin error"

**Çözüm:**
1. `google-services.json` dosyasının doğru yerde olduğunu kontrol et
2. `android/app/build.gradle` dosyasını kontrol et

### Sorun 4: "Build failed"

**Çözüm:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
flutter run
```

### Sorun 5: "Firebase initialization error"

**Çözüm:**
1. Firebase config değerlerini kontrol et
2. `google-services.json` güncel mi?
3. Firebase Console'da servisler aktif mi?

---

## 📊 TEST ETME

### Unit Test:

```bash
flutter test
```

### Widget Test:

```bash
flutter test test/widget_test.dart
```

### Integration Test:

```bash
flutter test integration_test/
```

---

## 🔍 DEBUG ARAÇLARI

### Flutter Inspector:

```bash
flutter run
# Ardından:
# Android Studio > Flutter Inspector
# veya
# VS Code > Flutter: Open DevTools
```

### Logs:

```bash
# Tüm loglar
flutter logs

# Filtrelenmiş loglar
flutter logs | grep "ERROR"
```

### Performance:

```bash
flutter run --profile
# DevTools'da performance tab'ini aç
```

---

## 📱 YAYINLAMA

### Play Store:

1. **Signing Config:**
   ```bash
   keytool -genkey -v -keystore soulchat.jks -keyalg RSA -keysize 2048 -validity 10000 -alias soulchat
   ```

2. **key.properties oluştur:**
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=soulchat
   storeFile=soulchat.jks
   ```

3. **Bundle oluştur:**
   ```bash
   flutter build appbundle --release
   ```

4. Play Console'a yükle

### App Store (iOS):

1. Xcode'da proje aç
2. Bundle ID'yi ayarla
3. Signing'i yapılandır
4. Archive oluştur
5. App Store Connect'e yükle

---

## 🎯 SONRAKİ ADIMLAR

1. ✅ Firebase kurulumunu tamamla
2. ✅ API anahtarlarını ekle
3. ✅ Test et
4. ✅ APK oluştur
5. ✅ Yayınla!

---

## 📞 DESTEK

Sorun mu yaşıyorsun?

1. **Dokümantasyona bak:** README.md, SETUP_GUIDE.md
2. **Issues:** https://github.com/umut71/SoulChat/issues
3. **Flutter Docs:** https://docs.flutter.dev/

---

## 🎊 SONUÇ

**Artık hazırsın!**

1. Paketleri kur: `flutter pub get`
2. Firebase ayarla
3. API'ları ekle
4. Çalıştır: `flutter run`
5. APK oluştur: `flutter build apk --release`

**Başarılar! 🚀**
