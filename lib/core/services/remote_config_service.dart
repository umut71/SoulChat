import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:soulchat/core/config/app_config.dart';

/// API anahtarlarını Firebase Remote Config üzerinden alır; kodda açıkta kalmaz.
/// Firebase Console > Remote Config'te şu key'leri tanımlayın:
/// - route_llm_api_key, route_llm_base_url, agora_app_id, agora_certificate
class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  static bool _fetched = false;

  static const _defaults = <String, dynamic>{
    'route_llm_api_key': '',
    'route_llm_base_url': 'https://api.routellm.com/v1',
    'agora_app_id': '',
    'agora_certificate': '',
  };

  static Future<void> initialize() async {
    try {
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await _remoteConfig.fetchAndActivate();
      _fetched = true;
    } catch (_) {}
  }

  static String get routeLlmApiKey {
    final v = _fetched ? _remoteConfig.getString('route_llm_api_key') : '';
    return v.isNotEmpty ? v : AppConfig.routeLlmApiKey;
  }

  static String get routeLlmBaseUrl {
    final v = _fetched ? _remoteConfig.getString('route_llm_base_url') : '';
    return v.isNotEmpty ? v : AppConfig.routeLlmBaseUrl;
  }

  static String get agoraAppId {
    final v = _fetched ? _remoteConfig.getString('agora_app_id') : '';
    return v.isNotEmpty ? v : AppConfig.agoraAppId;
  }

  static String get agoraCertificate {
    final v = _fetched ? _remoteConfig.getString('agora_certificate') : '';
    return v.isNotEmpty ? v : AppConfig.agoraCertificate;
  }
}
