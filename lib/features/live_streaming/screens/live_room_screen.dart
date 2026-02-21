import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/services/agora_service.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/core/services/system_architect_service.dart';
import 'package:soulchat/core/services/system_doctor_service.dart';

class LiveRoomScreen extends StatefulWidget {
  final String channelId;
  final String title;

  const LiveRoomScreen({super.key, required this.channelId, this.title = 'Canlı Yayın'});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _joining = true;
  bool _joined = false;
  String? _error;
  String? _errorFriendly;
  bool _simulationMode = false;
  String? _permissionGuide;

  @override
  void initState() {
    super.initState();
    _join();
  }

  Future<bool> _requestCameraAndMic() async {
    if (kIsWeb) return true;
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    final cameraOk = statuses[Permission.camera]?.isGranted ?? false;
    final micOk = statuses[Permission.microphone]?.isGranted ?? false;
    if (cameraOk && micOk) return true;
    if (!mounted) return false;
    final guide = await SystemDoctorService.getPermissionGuide('kamera ve mikrofon');
    if (!mounted) return false;
    setState(() {
      _joining = false;
      _error = guide;
      _errorFriendly = null;
      _permissionGuide = guide;
    });
    SystemArchitectService.getFriendlyErrorMessage('Canlı Yayın', guide).then((m) {
      if (mounted) setState(() => _errorFriendly = m);
    });
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('Zorunlu İzinler'),
        content: Text(
          'Canlı yayın için kamera ve mikrofon izni gereklidir. '
          'Ayarlar > Uygulamalar > SoulChat > İzinler bölümünden izinleri açın.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Tamam')),
          FilledButton(
            onPressed: () {
              Navigator.pop(c);
              openAppSettings();
            },
            child: const Text('Ayarlara git'),
          ),
        ],
      ),
    );
    return false;
  }

  Future<void> _join() async {
    setState(() {
      _joining = true;
      _joined = false;
      _error = null;
      _errorFriendly = null;
      _simulationMode = false;
    });
    if (kIsWeb) {
      setState(() {
        _joining = false;
        _error = 'Canlı yayın şu an yalnızca mobil uygulamada kullanılabilir.';
      });
      return;
    }
    if (EnvConfig.isAgoraDemoAppId) {
      if (mounted) _enableSimulationMode();
      return;
    }
    final isHost = widget.channelId == 'soul_live_host' || widget.channelId.contains('host');
    if (isHost) {
      FirestoreService.createLiveSession(channelId: widget.channelId, title: widget.title);
    }
    final hasPermission = await _requestCameraAndMic();
    if (!hasPermission || !mounted) return;
    final ok = await AgoraService.joinChannel(
      channelId: widget.channelId,
      videoEnabled: true,
      onJoined: () {
        if (mounted) setState(() { _joining = false; _joined = true; });
      },
    );
    if (!mounted) return;
    if (!ok) {
      final guide = _permissionGuide ?? await SystemDoctorService.getPermissionGuide('kamera ve mikrofon');
      if (!mounted) return;
      setState(() {
        _joining = false;
        _error = guide;
        _errorFriendly = null;
        _permissionGuide = guide;
      });
      SystemArchitectService.getFriendlyErrorMessage('Canlı Yayın', guide).then((m) {
        if (mounted) setState(() => _errorFriendly = m);
      });
      return;
    }
    if (!_joined) setState(() { _joining = false; });
  }

  void _enableSimulationMode() {
    setState(() {
      _error = null;
      _joining = false;
      _joined = false;
      _simulationMode = true;
    });
  }

  Future<void> _leave() async {
    final channelId = widget.channelId;
    final isHost = channelId == 'soul_live_host' || channelId.contains('host');
    if (isHost) FirestoreService.endLiveSession(channelId);
    await AgoraService.leaveChannel();
    await AgoraService.dispose();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_joined)
            IconButton(
              icon: const Icon(Icons.call_end),
              onPressed: _leave,
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: _simulationMode
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off, size: 64, color: Colors.blue.shade300),
                      const SizedBox(height: 16),
                      const Text('Canlı yayın kapalı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Canlı yayın şu an kullanılamıyor. Lütfen daha sonra tekrar deneyin.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: _leave, child: const Text('Geri dön')),
                    ],
                  ),
                )
              : _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 64, color: Colors.orange.shade300),
                          const SizedBox(height: 16),
                          Text(_errorFriendly ?? _error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _enableSimulationMode,
                            child: const Text('Simülasyon Modu ile izle'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(onPressed: _leave, child: const Text('Geri dön')),
                        ],
                      ),
                    )
                  : _joining
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Kanala bağlanılıyor...'),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam, size: 80, color: Colors.green.shade400),
                        const SizedBox(height: 16),
                        const Text('Yayına bağlandınız', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Kanal: ${widget.channelId}', style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _leave,
                          icon: const Icon(Icons.call_end),
                          label: const Text('Yayından çık'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
