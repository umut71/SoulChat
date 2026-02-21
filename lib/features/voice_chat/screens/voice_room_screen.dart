import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soulchat/core/config/env_config.dart';
import 'package:soulchat/core/services/agora_service.dart';
import 'package:soulchat/core/services/system_architect_service.dart';

class VoiceRoomScreen extends StatefulWidget {
  final String channelId;
  final String title;

  const VoiceRoomScreen({super.key, required this.channelId, this.title = 'Sesli Oda'});

  @override
  State<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen> {
  bool _joining = true;
  bool _joined = false;
  bool _muted = false;
  String? _error;
  String? _errorFriendly;
  bool _simulationMode = false;

  @override
  void initState() {
    super.initState();
    _join();
  }

  Future<bool> _requestMic() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;
    if (!mounted) return false;
    final err = 'Sesli oda için mikrofon izni gereklidir. Ayarlar > Uygulamalar > SoulChat > İzinler bölümünden açın.';
    setState(() {
      _joining = false;
      _error = err;
      _errorFriendly = null;
    });
    SystemArchitectService.getFriendlyErrorMessage('Sesli Oda', err).then((m) {
      if (mounted) setState(() => _errorFriendly = m);
    });
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('Zorunlu İzin'),
        content: const Text(
          'Sesli oda için mikrofon izni gereklidir. Ayarlar > Uygulamalar > SoulChat > İzinler bölümünden izni açın.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Tamam')),
          FilledButton(onPressed: () { Navigator.pop(c); openAppSettings(); }, child: const Text('Ayarlara git')),
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
      _simulationMode = false;
    });
    if (EnvConfig.isAgoraDemoAppId) {
      if (mounted) setState(() {
        _joining = false;
        _simulationMode = true;
        _error = null;
        _errorFriendly = null;
      });
      return;
    }
    final hasPermission = await _requestMic();
    if (!hasPermission || !mounted) return;
    final ok = await AgoraService.joinChannel(
      channelId: widget.channelId,
      videoEnabled: false,
      onJoined: () {
        if (mounted) setState(() { _joining = false; _joined = true; });
      },
    );
    if (!mounted) return;
    if (!ok) {
      final err = 'Odaya bağlanılamadı. Mikrofon iznini kontrol edip tekrar deneyin.';
      setState(() {
        _joining = false;
        _error = err;
        _errorFriendly = null;
      });
      SystemArchitectService.getFriendlyErrorMessage('Sesli Oda', err).then((m) {
        if (mounted) setState(() => _errorFriendly = m);
      });
      return;
    }
    if (!_joined) setState(() { _joining = false; });
  }

  Future<void> _leave() async {
    await AgoraService.leaveChannel();
    await AgoraService.dispose();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _toggleMute() async {
    await AgoraService.setMute(!_muted);
    if (mounted) setState(() => _muted = !_muted);
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
                      Icon(Icons.mic_none, size: 64, color: Colors.blue.shade300),
                      const SizedBox(height: 16),
                      const Text('Demo Modu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Sesli oda (Agora App ID ayarlanmadı). Arayüzü deneyebilirsiniz.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
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
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(_errorFriendly ?? _error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: _leave, child: const Text('Geri dön')),
                    ],
                  ),
                )
              : _joining
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Odaya bağlanılıyor...'),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mic, size: 80, color: Colors.blue.shade400),
                        const SizedBox(height: 16),
                        const Text('Sesli odaya bağlandınız', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Oda: ${widget.channelId}', style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filled(
                              onPressed: _toggleMute,
                              icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                              iconSize: 36,
                              style: IconButton.styleFrom(
                                backgroundColor: _muted ? Colors.orange : Colors.green,
                              ),
                            ),
                            const SizedBox(width: 24),
                            ElevatedButton.icon(
                              onPressed: _leave,
                              icon: const Icon(Icons.call_end),
                              label: const Text('Odadan çık'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
