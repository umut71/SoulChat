/// SoulChat multimedya işlemleri için SoulCoin maliyetleri.
/// Tüm GCP kullanımı (Ses, Müzik, Görsel) 300$ kredi üzerinden yönetilir;
/// kullanıcıdan bu miktarlar SoulCoin olarak düşülür.
class SoulCoinCosts {
  SoulCoinCosts._();

  /// Mesaj başına verilen SC (teşvik).
  static const int messageReward = 2;

  /// Görsel üretimi (AI image).
  static const int imageGeneration = 5;

  /// TTS: Karakter mesajını sesli okuma (Google Cloud TTS).
  static const int ttsPerMessage = 5;

  /// Ses dönüştürme: Kullanıcı sesi → karakter sesi (STT + TTS).
  static const int voiceConversion = 10;

  /// Müzik Stüdyosu: Temaya göre şarkı/melodi üretimi.
  static const int songGeneration = 50;
}
