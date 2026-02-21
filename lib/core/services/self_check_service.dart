import 'package:firebase_core/firebase_core.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/services/remote_config_service.dart';

/// Uygulama açılışında API bağlantılarını kontrol eder.
/// Google Cloud: EnvConfig.googleApiKey (tek Vertex/Map key – Gemini, Harita, TTS, STT).
class SelfCheckService {
  static bool _googleCloudOk = false;
  static bool _firebaseOk = false;
  static bool _abacusOk = false;
  static bool _useBackupChat = false;

  static bool get googleCloudOk => _googleCloudOk;
  static bool get firebaseOk => _firebaseOk;
  static bool get abacusOk => _abacusOk;
  static bool get useBackupChat => _useBackupChat;

  /// Tüm bağlantıları kontrol et; yedek gerekiyorsa işaretle (hızlı, ağ çağrısı yok).
  static Future<SelfCheckResult> runOnStartup() async {
    _googleCloudOk = EnvConfig.googleApiKey.isNotEmpty;
    _firebaseOk = false;
    try {
      _firebaseOk = Firebase.apps.isNotEmpty;
    } catch (_) {}

    _abacusOk = false;
    try {
      _abacusOk = RemoteConfigService.routeLlmApiKey.isNotEmpty;
    } catch (_) {}

    _useBackupChat = !_abacusOk || !_googleCloudOk;

    return SelfCheckResult(
      googleCloud: _googleCloudOk,
      firebase: _firebaseOk,
      abacus: _abacusOk,
      useBackupChat: _useBackupChat,
    );
  }
}

class SelfCheckResult {
  final bool googleCloud;
  final bool firebase;
  final bool abacus;
  final bool useBackupChat;

  SelfCheckResult({
    required this.googleCloud,
    required this.firebase,
    required this.abacus,
    required this.useBackupChat,
  });
}
