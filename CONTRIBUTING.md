# Katkıda Bulunma Rehberi / Contributing Guide

SoulChat projesine katkıda bulunmak istediğiniz için teşekkürler! 🎉

## Nasıl Katkıda Bulunabilirsiniz?

### 1. Bug Bildirimi / Reporting Bugs
- GitHub Issues kullanarak bug bildirin
- Detaylı açıklama ve adımlar ekleyin
- Ekran görüntüleri paylaşın
- Cihaz ve Flutter versiyonunu belirtin

### 2. Yeni Özellik Önerisi / Feature Requests
- Önce Issues'da önerinizi tartışın
- Use case ve faydalarını açıklayın
- Mockup veya tasarım ekleyin (opsiyonel)

### 3. Kod Katkısı / Code Contribution

#### Adımlar:
1. **Fork** edin
2. **Branch** oluşturun: `git checkout -b feature/amazing-feature`
3. **Commit** yapın: `git commit -m 'Add amazing feature'`
4. **Push** edin: `git push origin feature/amazing-feature`
5. **Pull Request** açın

#### Kod Standartları:
- Flutter linter kurallarına uyun
- Anlamlı değişken isimleri kullanın
- Kod yorumları ekleyin (gerektiğinde)
- Widget'ları küçük ve yeniden kullanılabilir tutun

#### Commit Mesajları:
```
feat: Add voice effects feature
fix: Fix chat message loading bug
docs: Update README with new setup steps
style: Format code according to linter
refactor: Improve wallet service structure
test: Add unit tests for auth service
```

### 4. Dokümantasyon / Documentation
- README güncellemeleri
- Kod örnekleri
- Tutorial yazıları
- API dokümantasyonu

## Geliştirme Ortamı Kurulumu

```bash
# Repository'yi klonlayın
git clone https://github.com/umut71/SoulChat.git
cd SoulChat

# Bağımlılıkları yükleyin
flutter pub get

# Çalıştırın
flutter run
```

## Test

```bash
# Tüm testleri çalıştır
flutter test

# Widget testleri
flutter test test/widget_test.dart

# Integration testleri
flutter drive --target=test_driver/app.dart
```

## Code Review Süreci

1. Tüm testler geçmeli
2. Linter hataları olmamalı
3. En az bir reviewer onayı gerekli
4. Konfliktler çözülmeli

## İletişim

- GitHub Issues
- Email: dev@soulchat.app
- Discord: [SoulChat Community]

Katkılarınız için teşekkürler! 🙏
