# SoulChat Kurulum ve APK Oluşturma Rehberi

## 📋 Gerekli Araçlar

### 1. Flutter SDK Kurulumu
```bash
# Linux için:
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor

# Windows için Flutter'ı indir:
# https://docs.flutter.dev/get-started/install/windows
```

### 2. Android Studio Kurulumu
- Android Studio'yu indirin: https://developer.android.com/studio
- Android SDK'yı yükleyin
- Android SDK Command-line Tools'u yükleyin

### 3. Java Development Kit (JDK)
```bash
# Linux için:
sudo apt-get install openjdk-17-jdk

# Windows için JDK 17 indirin
```

## 🔥 Firebase Kurulumu

### Adım 1: Firebase Projesi Oluşturma
1. https://console.firebase.google.com/ adresine gidin
2. "Add project" butonuna tıklayın
3. Proje adını "soulchat" olarak girin
4. Google Analytics'i etkinleştirin (isteğe bağlı)

### Adım 2: Android Uygulaması Ekleme
1. Firebase Console'da Android ikonuna tıklayın
2. Package name: `com.soulchat.app`
3. App nickname: `SoulChat`
4. Debug signing certificate SHA-1'i ekleyin (opsiyonel)
5. `google-services.json` dosyasını indirin
6. İndirilen dosyayı `android/app/` klasörüne yerleştirin

### Adım 3: iOS Uygulaması Ekleme
1. Firebase Console'da iOS ikonuna tıklayın
2. Bundle ID: `com.soulchat.app`
3. `GoogleService-Info.plist` dosyasını indirin
4. İndirilen dosyayı `ios/Runner/` klasörüne yerleştirin

### Adım 4: Firebase Servislerini Aktifleştirme
Firebase Console'da aşağıdaki servisleri aktifleştirin:
- ✅ Authentication (Email/Password, Google, Apple)
- ✅ Cloud Firestore
- ✅ Storage
- ✅ Cloud Messaging
- ✅ Analytics

### Adım 5: Firebase Config Güncelleme
`lib/core/config/firebase_config.dart` dosyasını Firebase Console'dan aldığınız bilgilerle güncelleyin.

## 📱 Proje Kurulumu

### 1. Bağımlılıkları Yükleme
```bash
cd SoulChat
flutter pub get
```

### 2. Projeyi Kontrol Etme
```bash
flutter doctor
flutter analyze
```

## 🔨 APK Oluşturma

### Debug APK (Test için)
```bash
flutter build apk --debug
# APK Yeri: build/app/outputs/flutter-apk/app-debug.apk
```

### Release APK (Yayın için)
```bash
# Tek dosya APK (tüm mimarliler için ~50MB)
flutter build apk --release

# Split APK (mimari başına ~20MB)
flutter build apk --release --split-per-abi
```

## 📲 APK Test Etme

### Fiziksel Cihazda Test
```bash
# USB debugging'i aç
# Cihazı bağla
adb devices

# APK'yı yükle
adb install build/app/outputs/flutter-apk/app-debug.apk

# Veya doğrudan çalıştır
flutter run
```

## 🛠️ Düzenleme ve Geliştirme

### Proje Dosya Yapısı
```
lib/
├── main.dart              # Ana giriş dosyası
├── core/                  # Temel yapılandırma
│   ├── config/           # Firebase, routing
│   ├── theme/            # Renkler, stil
│   ├── models/           # Veri yapıları
│   └── services/         # API, yerelleştirme
├── features/             # Özellik modülleri
│   ├── auth/            # Giriş/Kayıt
│   ├── home/            # Ana sayfa
│   ├── chat/            # Mesajlaşma
│   ├── profile/         # Profil
│   ├── wallet/          # Cüzdan
│   └── ...              # Diğer özellikler
└── shared/              # Paylaşılan bileşenler
    ├── widgets/         # UI bileşenleri
    └── providers/       # State management
```

## 🐛 Sık Karşılaşılan Sorunlar

### 1. "Execution failed for task ':app:processDebugResources'"
```bash
flutter clean
flutter pub get
flutter build apk
```

### 2. "Gradle sync failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### 3. "Firebase not initialized"
- `google-services.json` dosyasının doğru yerde olduğunu kontrol edin
- Firebase config dosyasındaki bilgileri kontrol edin

## 📊 Build Boyutları

| APK Tipi | Yaklaşık Boyut |
|----------|----------------|
| Debug | ~60-70 MB |
| Release (Fat APK) | ~45-55 MB |
| Release (arm64-v8a) | ~20-25 MB |
| Release (armeabi-v7a) | ~18-22 MB |

---

🎉 Başarılar! SoulChat'i geliştirmeye başlayabilirsiniz!
