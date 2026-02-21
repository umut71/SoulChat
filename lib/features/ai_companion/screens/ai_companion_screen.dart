import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';
import 'package:soulchat/core/constants/soulcoin_costs.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/core/services/gemini_service.dart';
import 'package:soulchat/core/services/google_tts_service.dart';
import 'package:soulchat/core/services/gemini_chat_service.dart';
import 'package:soulchat/core/services/voice_conversion_service.dart';
import 'package:soulchat/core/services/system_architect_service.dart';
import 'package:soulchat/core/services/system_doctor_service.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';
import 'package:soulchat/shared/widgets/character_profile_sheet.dart';
import 'package:soulchat/core/services/temp_recording_io.dart'
    if (dart.library.html) 'package:soulchat/core/services/temp_recording_web.dart' as temp_rec;
import 'dart:convert';

class AiCompanionScreen extends ConsumerStatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  ConsumerState<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends ConsumerState<AiCompanionScreen> {
  final _messages = <_Msg>[];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _loading = false;
  bool _historyLoaded = false;
  bool _recording = false;
  bool _ttsPlaying = false;
  final _geminiChat = GeminiChatService();
  final _audioRecorder = AudioRecorder();
  TtsVoiceType _characterVoice = TtsVoiceType.female;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    // AI ekranı açıldığında terminalde Merhaba testi ve hata logları görünsün
    GeminiService.runSimpleMerhabaTest().catchError((e) {
      // Hata zaten [GEMINI_DEBUG] ile GeminiService içinde yazıldı
    });
  }

  Future<void> _loadHistory() async {
    final list = await FirestoreService.getAiConversation(limit: 50);
    if (!mounted) return;
    setState(() {
      for (final m in list) {
        _messages.add(_Msg(
          isUser: m['isFromUser'] == true,
          text: m['text'] as String? ?? '',
          imageUrl: m['imageUrl'] as String?,
          createdAt: DateTime.now(),
        ));
      }
      if (_messages.isEmpty) {
        _messages.add(_Msg(isUser: false, text: 'Galaksiye hoş geldin Umut, her şey hazır!', createdAt: DateTime.now()));
      }
      _historyLoaded = true;
    });
  }

  void _playTapSound() {
    SystemSound.play(SystemSoundType.click);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _buildContextPrompt() {
    final recent = _messages.reversed.take(6).toList();
    if (recent.isEmpty) return '';
    final sb = StringBuffer();
    for (final m in recent) {
      sb.writeln(m.isUser ? 'User: ${m.text}' : 'Assistant: ${m.text}');
    }
    return sb.toString().trim();
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _loading) return;
    _inputController.clear();
    _playTapSound();
    setState(() {
      _messages.add(_Msg(isUser: true, text: text, createdAt: DateTime.now()));
      _loading = true;
    });
    ref.read(soulCoinProvider.notifier).add(SoulCoinCosts.messageReward);
    FirestoreService.saveAiMessage(text, isFromUser: true).catchError((_) {});
    SystemArchitectService.submitDevelopmentRequest(text).catchError((_) {});
    try {
      final contextPrompt = _buildContextPrompt();
      final prompt = contextPrompt.isEmpty
          ? text
          : 'Önceki konuşma:\n$contextPrompt\n\nKullanıcı: $text\n\nYanıt ver:';
      final reply = await _geminiChat.sendMessage(prompt).timeout(
        const Duration(seconds: 10),
        onTimeout: () => SystemDoctorService.getChatTakeoverMessage(),
      );
      if (!mounted) return;
      setState(() {
        _messages.add(_Msg(isUser: false, text: reply, createdAt: DateTime.now()));
        _loading = false;
      });
      await FirestoreService.saveAiMessage(reply, isFromUser: false);
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    } catch (e, st) {
      if (!mounted) return;
      setState(() { _loading = false; });
      await SystemArchitectService.handleErrorAndNotify(
        context,
        module: 'Sohbet',
        error: e,
        stackTrace: st?.toString(),
      );
      setState(() {
        _messages.add(_Msg(isUser: false, text: 'Yanıt alınamadı. Sistem Denetleyici devrede.', createdAt: DateTime.now()));
      });
    }
  }

  Future<void> _generateImage() async {
    if (!ref.read(soulCoinProvider.notifier).canSpend(SoulCoinCosts.imageGeneration)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görsel üretmek için ${SoulCoinCosts.imageGeneration} SoulCoin gerekir')),
      );
      return;
    }
    final promptController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Görsel üret (${SoulCoinCosts.imageGeneration} SC)'),
        content: TextField(
          controller: promptController,
          decoration: const InputDecoration(
            hintText: 'Görsel için açıklama yazın...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, promptController.text.trim()),
            child: const Text('Üret'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    _playTapSound();
    final ok = await ref.read(soulCoinProvider.notifier).spend(SoulCoinCosts.imageGeneration);
    if (!ok) return;
    setState(() => _loading = true);
    try {
      final url = await _geminiChat.generateImage(result);
      if (!mounted) return;
      if (!url.startsWith('http') && !url.startsWith('data:')) {
        ref.read(soulCoinProvider.notifier).add(SoulCoinCosts.imageGeneration);
      }
      setState(() {
        if (url.startsWith('http') || url.startsWith('data:')) {
          _messages.add(_Msg(isUser: false, text: 'Görsel:', imageUrl: url, createdAt: DateTime.now()));
        } else {
          _messages.add(_Msg(isUser: false, text: url, createdAt: DateTime.now()));
        }
        _loading = false;
      });
      if (url.startsWith('http') || url.startsWith('data:')) {
        await FirestoreService.saveAiMessage('Görsel:', isFromUser: false, imageUrl: url);
      } else {
        await FirestoreService.saveAiMessage(url, isFromUser: false);
      }
    } catch (e, st) {
      if (!mounted) return;
      ref.read(soulCoinProvider.notifier).add(SoulCoinCosts.imageGeneration);
      setState(() { _loading = false; });
      await SystemArchitectService.handleErrorAndNotify(
        context,
        module: 'Görsel',
        error: e,
        stackTrace: st?.toString(),
      );
      setState(() {
        _messages.add(_Msg(isUser: false, text: 'Görsel oluşturulamadı. Sistem Denetleyici devrede.', createdAt: DateTime.now()));
      });
    }
  }

  void _showVoiceSheet() {
    _playTapSound();
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Ses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.mic),
                title: const Text('Sesli mesaj gönder'),
                subtitle: const Text('Kaydedip metne çevir, sohbet olarak gönder'),
                onTap: () {
                  Navigator.pop(ctx);
                  _recordAndSendAsMessage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.record_voice_over),
                title: const Text('Sesimi karakter sesine dönüştür'),
                subtitle: Text('${SoulCoinCosts.voiceConversion} SC'),
                onTap: () {
                  Navigator.pop(ctx);
                  _recordAndConvertToCharacterVoice();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _recordAndSendAsMessage() async {
    final path = await temp_rec.getTempRecordingPath('soulchat_voice');
    if (path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ses kaydı web\'de desteklenmiyor')),
        );
      }
      return;
    }
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon izni gerekli')),
      );
      return;
    }
    try {
      await _audioRecorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
      setState(() => _recording = true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kaydediliyor... Durdurmak için tekrar dokunun.')),
      );
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          title: const Text('Ses kaydı'),
          content: const Text('Kaydı bitirmek için Tamam\'a basın.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } catch (_) {}
    setState(() => _recording = false);
    await _audioRecorder.stop();
    setState(() => _loading = true);
    try {
      final text = await VoiceConversionService.textFromWavFile(path);
      await temp_rec.deleteTempFile(path);
      if (!mounted) return;
      if (text.isEmpty) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ses anlaşılamadı, tekrar deneyin.')),
        );
        return;
      }
      _inputController.text = text;
      setState(() => _loading = false);
    } catch (e, st) {
      await temp_rec.deleteTempFile(path);
      if (!mounted) return;
      setState(() => _loading = false);
      await SystemArchitectService.handleErrorAndNotify(context, module: 'Ses', error: e, stackTrace: st?.toString());
    }
  }

  Future<void> _recordAndConvertToCharacterVoice() async {
    if (!ref.read(soulCoinProvider.notifier).canSpend(SoulCoinCosts.voiceConversion)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ses dönüştürme için ${SoulCoinCosts.voiceConversion} SoulCoin gerekir')),
      );
      return;
    }
    final path = await temp_rec.getTempRecordingPath('soulchat_conv');
    if (path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ses dönüştürme web\'de desteklenmiyor')),
        );
      }
      return;
    }
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon izni gerekli')),
      );
      return;
    }
    await _audioRecorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
    setState(() => _recording = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kaydediliyor... Bitirince Tamam\'a basın.')),
    );
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('Ses kaydı'),
        content: const Text('Kaydı bitirip karakter sesine dönüştürmek için Tamam\'a basın.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
    setState(() => _recording = false);
    await _audioRecorder.stop();
    final ok = await ref.read(soulCoinProvider.notifier).spend(SoulCoinCosts.voiceConversion);
    if (!ok) return;
    setState(() => _ttsPlaying = true);
    try {
      await VoiceConversionService.userVoiceToCharacterVoice(
        wavFilePath: path,
        characterVoice: _characterVoice,
      );
      await temp_rec.deleteTempFile(path);
    } catch (e, st) {
      ref.read(soulCoinProvider.notifier).add(SoulCoinCosts.voiceConversion);
      if (!mounted) return;
      await SystemArchitectService.handleErrorAndNotify(context, module: 'Ses', error: e, stackTrace: st?.toString());
    }
    if (mounted) setState(() => _ttsPlaying = false);
  }

  Future<void> _playMessageTts(String text) async {
    if (text.isEmpty) return;
    if (!ref.read(soulCoinProvider.notifier).canSpend(SoulCoinCosts.ttsPerMessage)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sesli okuma için ${SoulCoinCosts.ttsPerMessage} SoulCoin gerekir')),
      );
      return;
    }
    final ok = await ref.read(soulCoinProvider.notifier).spend(SoulCoinCosts.ttsPerMessage);
    if (!ok) return;
    setState(() => _ttsPlaying = true);
    try {
      await VoiceConversionService.speakText(
        text: text,
        voiceType: _characterVoice,
      );
    } catch (e, st) {
      ref.read(soulCoinProvider.notifier).add(SoulCoinCosts.ttsPerMessage);
      if (!mounted) return;
      await SystemArchitectService.handleErrorAndNotify(context, module: 'Ses', error: e, stackTrace: st?.toString());
    }
    if (mounted) setState(() => _ttsPlaying = false);
  }

  void _openMusicStudio() {
    _playTapSound();
    context.go('/music-studio');
  }

  Widget _buildMessageImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(imageUrl: imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Icon(Icons.smart_toy, size: 80, color: Colors.grey));
    }
    if (imageUrl.startsWith('data:image')) {
      return _buildDataUrlImage(imageUrl, 200);
    }
    return const Icon(Icons.image, size: 80);
  }

  Widget _buildDataUrlImage(String dataUrl, double height) {
    try {
      final base64 = dataUrl.contains(',') ? dataUrl.split(',').last : dataUrl;
      final bytes = base64Decode(base64);
      return Image.memory(bytes, height: height, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80));
    } catch (_) {
      return const Icon(Icons.broken_image, size: 80);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(soulCoinProvider);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => showCharacterProfileSheet(
            context,
            name: 'AI Asistan',
            biography: 'Galaksiye yayılmış yapay zeka asistanı. Sohbet, görsel üretimi ve sesli yanıt ile her an yanında.',
            interests: const ['Sohbet', 'Görsel üretimi', 'Sesli yanıt', 'Müzik'],
            voiceTone: 'Samimi ve yardımcı',
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('AI Asistan'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: Text('$balance SC', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          // #region agent log – API test butonu
          IconButton(
            icon: const Icon(Icons.wifi_tethering, color: Colors.orangeAccent),
            tooltip: 'API Bağlantı Testi',
            onPressed: () async {
              debugPrint('[GEMINI:TEST_BTN] Test butonuna basıldı.');
              if (!mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const AlertDialog(
                  content: Row(children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text('Hazırlanıyor…'),
                  ]),
                ),
              );
              String result;
              try {
                result = await GeminiService.runSimpleMerhabaTest();
                result = '✅ BAŞARILI!\n\n$result';
              } catch (e) {
                result = '❌ HATA:\n\n$e';
              }
              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Sonuç'),
                  content: SingleChildScrollView(child: SelectableText(result)),
                  actions: [TextButton(onPressed: () => Navigator.pop(_), child: const Text('Tamam'))],
                ),
              );
            },
          ),
          // #endregion
          IconButton(
            icon: Icon(_recording ? Icons.stop : Icons.mic),
            onPressed: _loading ? null : _showVoiceSheet,
            tooltip: 'Sesli mesaj / Sesimi karakter sesine dönüştür',
          ),
          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: _loading ? null : _openMusicStudio,
            tooltip: 'Müzik Stüdyosu',
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _loading ? null : _generateImage,
            tooltip: 'Görsel üret (${SoulCoinCosts.imageGeneration} SC)',
          ),
        ],
      ),
      body: !_historyLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_loading && index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(width: 12),
                              Text('Yazıyor...', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 14)),
                            ],
                          ),
                        );
                      }
                      final msgIndex = _loading ? _messages.length - index : _messages.length - 1 - index;
                      final msg = _messages[msgIndex];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Align(
                          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                            child: _GlassMessageBubble(
                              isUser: msg.isUser,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (msg.imageUrl != null && msg.imageUrl!.isNotEmpty) ...[
                                    _buildMessageImage(msg.imageUrl!),
                                    if (msg.text.isNotEmpty) const SizedBox(height: 8),
                                  ],
                                  if (msg.text.isNotEmpty)
                                    Text(
                                      msg.text,
                                      style: TextStyle(color: msg.isUser ? Colors.white : AppTheme.offWhite, fontSize: 15),
                                    ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _formatTime(msg.createdAt),
                                        style: TextStyle(fontSize: 10, color: (msg.isUser ? Colors.white : AppTheme.offWhite).withOpacity(0.7)),
                                      ),
                                      if (msg.isUser) ...[
                                        const SizedBox(width: 4),
                                        Icon(Icons.done_all, size: 12, color: Colors.white.withOpacity(0.8)),
                                      ],
                                    ],
                                  ),
                                  if (!msg.isUser && (msg.text.isNotEmpty || msg.imageUrl != null))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: _ttsPlaying ? null : () async {
                                              _playTapSound();
                                              await _playMessageTts(msg.text);
                                            },
                                            icon: Icon(Icons.volume_up, size: 18, color: _ttsPlaying ? Colors.grey : Theme.of(context).primaryColor),
                                            label: Text('Sesli oku (${SoulCoinCosts.ttsPerMessage} SC)', style: TextStyle(fontSize: 12, color: _ttsPlaying ? Colors.grey : Theme.of(context).primaryColor)),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          TextButton.icon(
                                            onPressed: () async {
                                              _playTapSound();
                                              await FirestoreService.addFeedPost(msg.text, imageUrl: msg.imageUrl);
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akışa paylaşıldı')));
                                            },
                                            icon: const Icon(Icons.share, size: 18),
                                            label: const Text('Akışa paylaş'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context).primaryColor,
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          decoration: InputDecoration(
                            hintText: 'Mesaj yazın (+${SoulCoinCosts.messageReward} SC)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                            filled: true,
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _loading ? null : _send,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

String _formatTime(DateTime? t) {
  if (t == null) return '';
  final now = DateTime.now();
  if (now.difference(t).inDays > 0) return '${t.day}.${t.month} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _GlassMessageBubble extends StatelessWidget {
  final bool isUser;
  final Widget child;

  const _GlassMessageBubble({required this.isUser, required this.child});

  @override
  Widget build(BuildContext context) {
    const neonPurple = Color(0xFF7C4DFF);
    const deepBlue = Color(0xFF16213E);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isUser ? neonPurple.withOpacity(0.85) : deepBlue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Msg {
  final bool isUser;
  final String text;
  final String? imageUrl;
  final DateTime? createdAt;

  _Msg({required this.isUser, required this.text, this.imageUrl, this.createdAt});
}
