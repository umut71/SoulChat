import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Background handler – uygulama kapalıyken çağrılır. Top-level fonksiyon olmalı.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // İleride: token yenileme, veri senkronizasyonu, yerel bildirim gösterimi
  // Şimdilik iskelet: mesaj alındığında log/side-effect burada eklenebilir
}

/// FCM: izin, token, foreground/background dinleyiciler.
class FcmService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web'de background handler farklı; foreground dinleyiciler kullanılabilir
      await _setupForegroundListeners();
      return;
    }
    // Mobil: arka plan handler'ı kaydet (uygulama kapalıyken bildirim)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _setupForegroundListeners();
    await requestPermissionIfNeeded();
    await _subscribeToToken();
  }

  static Future<void> _setupForegroundListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Foreground'da bildirim geldiğinde (opsiyonel: yerel bildirim göster)
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Kullanıcı bildirime tıkladığında (deep link / sayfa yönlendirme)
    });
  }

  static Future<void> requestPermissionIfNeeded() async {
    if (kIsWeb) return;
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;
    if (settings.authorizationStatus == AuthorizationStatus.provisional) return;
  }

  static Future<void> _subscribeToToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        // İsteğe bağlı: token'ı backend/Firestore'a kaydet (cihaz–kullanıcı eşlemesi)
      }
    } catch (_) {}
  }

  /// Token'ı backend'e göndermek veya test için kullanılabilir.
  static Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }
}
