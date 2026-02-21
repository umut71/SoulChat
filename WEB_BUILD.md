# Web derleme ve çalıştırma

Paket veya renderer uyumluluk sorunlarında aşağıdaki komutları kullanın.

## Çalıştırma
```bash
flutter run -d chrome --web-renderer html
```

## Release derleme
```bash
flutter build web --web-renderer html
```

İsterseniz `--web-renderer canvaskit` de kullanılabilir (daha iyi grafik, daha büyük boyut).
