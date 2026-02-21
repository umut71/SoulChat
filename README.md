# SoulChat - World-Class Social, Gaming & Crypto Mobile Application

![SoulChat Logo](https://img.shields.io/badge/SoulChat%3A%20AI%20Universe-1.0.0-7C4DFF)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)

## 🌟 Özellikler / Features

SoulChat, dünya standardında 137+ özelliğe sahip kapsamlı bir sosyal, oyun ve kripto mobil uygulamasıdır.

### 📱 Temel Özellikler / Core Features
- ✅ Gerçek zamanlı mesajlaşma (Real-time messaging)
- ✅ Sesli ve görüntülü arama (Voice & video calls)
- ✅ Canlı yayın (Live streaming)
- ✅ Sesli sohbet odaları (Voice chat rooms)
- ✅ Ses efektleri ve değiştiriciler (Voice effects & changers)
- ✅ Oyun merkezi (Gaming hub)
- ✅ SoulCoin cüzdan sistemi (SoulCoin wallet system)
- ✅ Kripto entegrasyonu (Crypto integration)
- ✅ Market ve paket satışları (Marketplace & package sales)
- ✅ Ödül sistemi (Reward system)
- ✅ Çoklu dil desteği (Multi-language support: TR, EN, ES, AR, DE, FR, IT, PT, RU, ZH, JA, KR)

### 🎨 UI/UX Özellikleri
- Modern ve kullanıcı dostu arayüz
- Koyu/Açık tema desteği (Dark/Light mode)
- Animasyonlu geçişler
- Özelleştirilebilir profiller
- Responsive tasarım

### 🔐 Güvenlik & Gizlilik
- Firebase Authentication
- Şifreli mesajlaşma
- Gizlilik ayarları
- İki faktörlü kimlik doğrulama hazır

### 🎮 Oyun Özellikleri
- Mini oyunlar
- Liderlik tabloları
- Turnuvalar
- Oyun içi ödüller

### 💰 Ekonomi Sistemi
- SoulCoin dijital para birimi
- Coin alım/satım
- Günlük giriş ödülleri
- Başarım sistemi
- Paket satışları

## 🚀 Kurulum / Installation

### Gereksinimler / Requirements
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / Xcode
- Firebase projesi

### Adımlar / Steps

1. **Projeyi klonlayın / Clone the project:**
```bash
git clone https://github.com/umut71/SoulChat.git
cd SoulChat
```

2. **Bağımlılıkları yükleyin / Install dependencies:**
```bash
flutter pub get
```

3. **Firebase Yapılandırması / Firebase Configuration:**
   - `lib/core/config/firebase_config.dart` dosyasındaki Firebase bilgilerini kendi projenizle güncelleyin
   - `android/app/google-services.json` dosyasını Firebase Console'dan indirin
   - `ios/Runner/GoogleService-Info.plist` dosyasını Firebase Console'dan indirin

4. **Uygulamayı çalıştırın / Run the app:**
```bash
flutter run
```

## 📦 APK Oluşturma / Building APK

### Debug APK
```bash
flutter build apk --debug
```
APK dosyası: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK
```bash
flutter build apk --release
```
APK dosyası: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs (Daha küçük boyut / Smaller size)
```bash
flutter build apk --split-per-abi
```
APK dosyaları:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

## 📱 iOS Build

```bash
flutter build ios --release
```

## 🏗️ Proje Yapısı / Project Structure

```
SoulChat/
├── lib/
│   ├── core/                    # Temel yapılandırma ve servisler
│   │   ├── config/             # Firebase, Router yapılandırması
│   │   ├── theme/              # Tema ve stil tanımlamaları
│   │   ├── services/           # Yerelleştirme, API servisleri
│   │   ├── models/             # Veri modelleri
│   │   └── utils/              # Yardımcı fonksiyonlar
│   ├── features/               # Özellik modülleri
│   │   ├── auth/               # Kimlik doğrulama
│   │   ├── home/               # Ana sayfa
│   │   ├── chat/               # Mesajlaşma
│   │   ├── profile/            # Profil yönetimi
│   │   ├── wallet/             # Cüzdan sistemi
│   │   ├── games/              # Oyunlar
│   │   ├── marketplace/        # Market
│   │   ├── live_streaming/     # Canlı yayın
│   │   ├── voice_chat/         # Sesli sohbet
│   │   └── settings/           # Ayarlar
│   ├── shared/                 # Paylaşılan bileşenler
│   │   ├── widgets/            # Yeniden kullanılabilir widget'lar
│   │   └── providers/          # Durum yönetimi
│   └── main.dart               # Uygulama giriş noktası
├── android/                     # Android yapılandırması
├── ios/                        # iOS yapılandırması
├── assets/                     # Görseller, animasyonlar, sesler
└── test/                       # Test dosyaları
```

## 🔧 Yapılandırma / Configuration

### Firebase Setup
1. Firebase Console'da yeni proje oluşturun
2. Android ve iOS uygulamaları ekleyin
3. Yapılandırma dosyalarını indirin ve ilgili dizinlere yerleştirin
4. `lib/core/config/firebase_config.dart` dosyasını güncelleyin

### RouteLLM API Entegrasyonu
```dart
// lib/core/services/route_llm_service.dart dosyasında
// API anahtarınızı ekleyin
const String ROUTE_LLM_API_KEY = 'your-api-key-here';
```

## 🌐 Desteklenen Diller / Supported Languages
- 🇹🇷 Türkçe (Turkish)
- 🇺🇸 English
- 🇪🇸 Español (Spanish)
- 🇸🇦 العربية (Arabic)
- 🇩🇪 Deutsch (German)
- 🇫🇷 Français (French)
- 🇮🇹 Italiano (Italian)
- 🇵🇹 Português (Portuguese)
- 🇷🇺 Русский (Russian)
- 🇨🇳 中文 (Chinese)
- 🇯🇵 日本語 (Japanese)
- 🇰🇷 한국어 (Korean)

## 📝 Önemli Notlar / Important Notes

### Firebase Yapılandırması
Firebase yapılandırma dosyalarındaki placeholder değerler örnek amaçlıdır. Kendi Firebase projenizden aldığınız gerçek değerlerle değiştirmeniz gerekmektedir:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/core/config/firebase_config.dart`

### API Keys
Aşağıdaki servislerin API anahtarlarını eklemeniz gerekmektedir:
- RouteLLM API
- Agora (Video/Voice calling)
- Firebase servisleri

## 🤝 Katkıda Bulunma / Contributing

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📄 Lisans / License

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 📞 İletişim / Contact

Proje Sahibi: [@umut71](https://github.com/umut71)

Proje Linki: [https://github.com/umut71/SoulChat](https://github.com/umut71/SoulChat)

## 🙏 Teşekkürler / Acknowledgments

- Flutter & Dart teams
- Firebase
- Tüm açık kaynak katkıda bulunanlar

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!