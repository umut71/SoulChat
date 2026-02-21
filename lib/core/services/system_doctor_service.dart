import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soulchat/core/services/gemini_service.dart';

/// Sistem Doktoru: Global hata yakalama, kullanıcı dostu mesaj, reset.
/// Kullanıcı siyah ekran veya hata kodu görmez; "Galaksi güncelleniyor" + otomatik reset.
class SystemDoctorService {
  static final ValueNotifier<String?> globalRecoveryMessage = ValueNotifier<String?>(null);
  static DateTime? _recoveryClearedAt;

  /// Küresel hata için: Önce hemen mesaj göster (siyah ekran olmasın), sonra isteğe bağlı Gemini ile güncelle.
  /// Aynı anda sürekli çıkmasın diye clear'dan sonra 15 sn cooldown uygulanır.
  static Future<void> reportGlobalError(Object error, [StackTrace? st]) async {
    if (_recoveryClearedAt != null &&
        DateTime.now().difference(_recoveryClearedAt!).inSeconds < 15) {
      return;
    }
    // Hemen göster; Gemini beklerken siyah ekran kalmasın.
    globalRecoveryMessage.value = 'Galaksi şu an kendini güncelliyor, lütfen bekleyin.';
    try {
      final prompt = '''
Uygulamada beklenmeyen bir hata oluştu. Kullanıcıya göstermek için tek bir Türkçe cümle yaz:
"Galaksi şu an kendini güncelliyor, lütfen bekleyin" tonunda, sakin ve güven veren. Hata detayı verme. Sadece bu tek cümleyi yaz.

Hata: $error
''';
      final msg = await GeminiService.sendMessage(prompt);
      if (msg.trim().isNotEmpty) globalRecoveryMessage.value = msg.trim();
    } catch (_) {
      // Zaten varsayılan mesaj gösteriliyor; güncellemeye gerek yok.
    }
  }

  /// Recovery mesajını temizle (buton veya otomatik kapanınca). 15 sn cooldown başlar.
  static void clearRecovery() {
    globalRecoveryMessage.value = null;
    _recoveryClearedAt = DateTime.now();
  }

  /// Kamera/mikrofon izni rehberi: Gemini'den kısa adım ver.
  static Future<String> getPermissionGuide(String permissionType) async {
    try {
      final prompt = '''
Kullanıcı uygulamada $permissionType izni alamıyor. Türkçe olarak tek cümleyle rehberlik ver:
"Kameranı açman için Ayarlar > Uygulamalar > SoulChat > İzinler bölümünden kamera iznini açman lazım" gibi net bir cümle. Sadece bu cümleyi yaz.
''';
      return await GeminiService.sendMessage(prompt);
    } catch (_) {
      return 'Ayarlar > Uygulamalar > SoulChat > İzinler bölümünden kamera ve mikrofon iznini açın.';
    }
  }

  /// Son bilinen kripto fiyatları için Gemini'den kısa açıklama (yedek servis mesajı).
  static Future<String> getWalletFallbackMessage(Map<String, double> lastPrices) async {
    if (lastPrices.isEmpty) return 'Fiyatlar yükleniyor. Galaksi güncelleniyor.';
    try {
      final list = lastPrices.entries.map((e) => '${e.key}: \$${e.value.toStringAsFixed(2)}').join(', ');
      final prompt = '''Son bilinen kripto fiyatları: $list. Kullanıcıya Türkçe tek cümleyle "Bu fiyatlar anlık güncelleniyor" tonunda bilgi ver. Sadece bir cümle yaz.''';
      return await GeminiService.sendMessage(prompt);
    } catch (_) {
      return 'Son bilinen fiyatlar gösteriliyor. Bağlantı gelince güncellenecek.';
    }
  }

  /// AI sohbet timeout devralma mesajı.
  static Future<String> getChatTakeoverMessage() async {
    try {
      final prompt = '''Kullanıcı AI sohbetinde yanıt beklerken bağlantı yoğunluğu oluştu. Sen (yardımcı) devreye giriyorsun. "Bağlantı yoğun, ben seninle ilgileniyorum" tonunda Türkçe tek cümle yaz. Samimi ve kısa.''';
      return await GeminiService.sendMessage(prompt);
    } catch (_) {
      return 'Bağlantı yoğun, ben seninle ilgileniyorum. Nasıl yardımcı olabilirim?';
    }
  }
}
