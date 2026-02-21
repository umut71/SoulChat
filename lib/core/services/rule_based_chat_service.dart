/// Ücretsiz, API anahtarı gerektirmeyen kural tabanlı sohbet. Cihaz içinde çalışır.
class RuleBasedChatService {
  /// Kullanıcı mesajına göre kısa cevap döner. Regex ve anahtar kelime eşlemesi.
  static String reply(String userMessage) {
    final lower = userMessage.trim().toLowerCase();
    if (lower.isEmpty) return 'Bir şeyler yazarsan cevap verebilirim.';

    // Selamlaşma
    if (RegExp(r'^(merhaba|selam|hey|hi|hello|günaydın|iyi günler|iyi akşamlar)\s*[!.]?$').hasMatch(lower)) {
      return 'Merhaba! Nasılsın?';
    }
    if (RegExp(r'^(naber|ne haber|nasılsın|nasilsin|nasıl sın)\s*[!.]?$').hasMatch(lower)) {
      return 'İyiyim, teşekkürler! Sen nasılsın?';
    }
    if (RegExp(r'^(iyiyim|iyi|süper|harika)\s*[!.]?$').hasMatch(lower)) {
      return 'Güzel, buna sevindim.';
    }

    // Soru kalıpları
    if (lower.contains('ne yapıyorsun') || lower.contains('ne yapiyorsun')) {
      return 'Seninle sohbet ediyorum. Sen ne yapıyorsun?';
    }
    if (lower.contains('kimsin') || lower.contains('sen kim')) {
      return 'Ben SoulChat\'in sohbet asistanıyım. Ücretsiz modda çalışıyorum.';
    }
    if (lower.contains('yardım') || lower.contains('yardim') || lower.contains('help')) {
      return 'İstediğin konuda soru sorabilirsin. Selamlaşma, duygu veya basit sorular yaz.';
    }
    if (lower.contains('teşekkür') || lower.contains('tesekkur') || lower.contains('sağol') || lower.contains('sagol')) {
      return 'Rica ederim! Başka bir şey var mı?';
    }
    if (lower.contains('evet') && lower.length < 15) {
      return 'Güzel. Devam edelim mi?';
    }
    if (lower.contains('hayır') || lower.contains('hayir') && lower.length < 15) {
      return 'Tamam. Başka konuda yardımcı olayım mı?';
    }

    // Duygu
    if (lower.contains('mutlu') || lower.contains('sevinç') || lower.contains('sevindim')) {
      return 'Buna sevindim!';
    }
    if (lower.contains('üzgün') || lower.contains('üzgünüm') || lower.contains('kötü')) {
      return 'Geçmiş olsun. İstersen sohbet edebiliriz.';
    }
    if (lower.contains('sıkıldım') || lower.contains('sikildim') || lower.contains('can sıkıntısı')) {
      return 'Oyunlar veya Kripto sayfasına bakabilirsin; eğlenceli olabilir.';
    }

    // Uygulama
    if (lower.contains('soulchat') || lower.contains('uygulama') || lower.contains('app')) {
      return 'SoulChat ile sohbet, canlı yayın, kripto takibi ve oyunlara erişebilirsin. Ücretsiz mod aktif.';
    }
    if (lower.contains('kripto') || lower.contains('bitcoin') || lower.contains('btc') || lower.contains('eth')) {
      return 'Kripto sayfasından canlı fiyatları görebilirsin. CoinGecko ücretsiz API kullanılıyor.';
    }
    if (lower.contains('yayın') || lower.contains('canlı') || lower.contains('live')) {
      return 'Canlı yayın için Agora kullanılıyor. Ücretsiz deneme için console.agora.io\'dan App ID alabilirsin.';
    }

    // Veda
    if (RegExp(r'^(görüşürüz|güle güle|bye|hoşça kal|kapat)\s*[!.]?$').hasMatch(lower)) {
      return 'Görüşürüz! İyi günler.';
    }

    // Uzun veya eşleşmeyen: kısa genel cevap
    if (lower.length > 80) {
      return 'Uzun bir mesaj yazdın. Kısaca özetlersen veya tek bir soru sorarsan daha iyi yanıt verebilirim.';
    }
    return 'Anladım. Başka bir şekilde sorarsan veya selamlaşma/duygu yazarsan devam edebiliriz.';
  }

  /// Öneri listesi (sabit, API yok).
  static List<String> getSuggestions(String context) {
    return ['Merhaba!', 'Nasılsın?', 'Bugün ne yapalım?'];
  }
}
