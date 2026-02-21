import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:soulchat/core/utils/debug_log.dart';

/// Web: Agora hiç import edilmez; platformViewRegistry ve toJS hataları oluşmaz.
class AgoraService {
  static Object? _engine;

  static Object? get engine => _engine;

  static Future<Object?> initialize({
    required bool videoEnabled,
    VoidCallback? onJoinSuccess,
    VoidCallback? onLeave,
  }) async =>
      null;

  static Future<bool> joinChannel({
    required String channelId,
    int uid = 0,
    String? token,
    bool videoEnabled = true,
    VoidCallback? onJoined,
  }) async {
    // #region agent log
    debugLog(
      location: 'agora_service_stub.dart:joinChannel',
      message: 'stub_called',
      data: {'channelId': channelId},
      hypothesisId: 'L1',
    );
    // #endregion
    return false;
  }

  static Future<void> leaveChannel() async {}

  static Future<void> dispose() async {}

  static Future<void> setMute(bool mute) async {}
}
