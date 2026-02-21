import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soulchat/core/services/google_stt_service.dart';
import 'package:soulchat/core/services/google_tts_service.dart';

/// IO implementasyonu: dart:io ile dosya işlemleri (mobil).
void initVoiceConversionService() {}

final AudioPlayer _player = AudioPlayer();

AudioPlayer getVoiceConversionPlayer() => _player;

Future<void> speakTextImpl({
  required String text,
  required TtsVoiceType voiceType,
  required String languageCode,
}) async {
  final bytes = await GoogleTtsService.synthesize(
    text: text,
    voiceType: voiceType,
    languageCode: languageCode,
  );
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3');
  await file.writeAsBytes(bytes);
  await _player.setFilePath(file.path);
  await _player.play();
  _player.processingStateStream.listen((s) async {
    if (s == ProcessingState.completed) {
      try {
        await file.delete();
      } catch (_) {}
    }
  });
}

Future<String> textFromWavFileImpl(String path, {required String languageCode}) async {
  final file = File(path);
  if (!await file.exists()) throw Exception('Ses dosyası bulunamadı');
  final bytes = await file.readAsBytes();
  return GoogleSttService.recognizeFromWav(bytes, languageCode: languageCode);
}
