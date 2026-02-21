import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/utils/debug_log.dart';

/// Agora RTC: .env AGORA_APP_ID veya Remote Config. Buraya Agora ID yaz – gerçek kamera açılır.
class AgoraService {
  static RtcEngine? _engine;
  static bool _initialized = false;
  static VoidCallback? _onJoinSuccess;
  static VoidCallback? _onLeave;

  static RtcEngine? get engine => _engine;

  static Future<RtcEngine?> initialize({
    required bool videoEnabled,
    VoidCallback? onJoinSuccess,
    VoidCallback? onLeave,
  }) async {
    _onJoinSuccess = onJoinSuccess;
    _onLeave = onLeave;
    if (_engine != null) return _engine;
    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: EnvConfig.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      if (videoEnabled) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      }
      await _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
      _engine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _initialized = true;
          _onJoinSuccess?.call();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          _onLeave?.call();
        },
      ));
      return _engine;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> joinChannel({
    required String channelId,
    int uid = 0,
    String? token,
    bool videoEnabled = true,
    VoidCallback? onJoined,
  }) async {
    // #region agent log
    debugLog(
      location: 'agora_service_impl.dart:joinChannel',
      message: 'join_start',
      data: {'channelId': channelId},
      hypothesisId: 'L2,L3',
    );
    // #endregion
    final safeToken = token ?? '';
    final tokenValue = (safeToken.isEmpty) ? '' : safeToken;
    final eng = await initialize(
      videoEnabled: videoEnabled,
      onJoinSuccess: onJoined,
    );
    // #region agent log
    debugLog(
      location: 'agora_service_impl.dart:joinChannel',
      message: 'after_initialize',
      data: {'engineNotNull': eng != null},
      hypothesisId: 'L2',
    );
    // #endregion
    if (eng == null) return false;
    try {
      await eng.joinChannel(
        token: tokenValue,
        channelId: channelId,
        uid: uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleAudience,
          autoSubscribeAudio: true,
          autoSubscribeVideo: videoEnabled,
        ),
      );
      // #region agent log
      debugLog(
        location: 'agora_service_impl.dart:joinChannel',
        message: 'join_success',
        data: {'channelId': channelId},
        hypothesisId: 'L2',
      );
      // #endregion
      return true;
    } catch (e) {
      // #region agent log
      debugLog(
        location: 'agora_service_impl.dart:joinChannel',
        message: 'join_catch',
        data: {'error': e.toString(), 'errorType': e.runtimeType.toString()},
        hypothesisId: 'L3',
      );
      // #endregion
      return false;
    }
  }

  static Future<void> leaveChannel() async {
    if (_engine == null) return;
    try {
      await _engine!.leaveChannel();
    } catch (_) {}
  }

  static Future<void> dispose() async {
    if (_engine == null) return;
    try {
      await _engine!.release();
    } catch (_) {}
    _engine = null;
    _initialized = false;
  }

  static Future<void> setMute(bool mute) async {
    if (_engine == null) return;
    await _engine!.muteLocalAudioStream(mute);
  }
}
