import 'package:just_audio/just_audio.dart';
import 'package:soulchat/core/services/google_tts_service.dart';

/// Web stub: dosya tabanlı ses işlemleri desteklenmiyor.
void initVoiceConversionService() {}

final AudioPlayer _player = AudioPlayer();

AudioPlayer getVoiceConversionPlayer() => _player;

Future<void> speakTextImpl({
  required String text,
  required TtsVoiceType voiceType,
  required String languageCode,
}) async {
  throw UnsupportedError('Sesli okuma web\'de desteklenmiyor.');
}

Future<String> textFromWavFileImpl(String path, {required String languageCode}) async {
  throw UnsupportedError('Ses dosyası işleme web\'de desteklenmiyor.');
}
