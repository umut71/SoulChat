import 'package:just_audio/just_audio.dart';
import 'package:soulchat/core/services/google_stt_service.dart';
import 'package:soulchat/core/services/google_tts_service.dart';

import 'voice_conversion_service_io.dart'
    if (dart.library.html) 'voice_conversion_service_web.dart' as impl;

/// Kullanıcı sesi → karakter sesi: STT (metin) + TTS (karakter sesi).
/// Web: dosya tabanlı işlemler desteklenmez; mobilde tam çalışır.
class VoiceConversionService {
  static AudioPlayer get player => impl.getVoiceConversionPlayer();

  static Future<void> speakText({
    required String text,
    TtsVoiceType voiceType = TtsVoiceType.female,
    String languageCode = 'tr-TR',
  }) async {
    await impl.speakTextImpl(
      text: text,
      voiceType: voiceType,
      languageCode: languageCode,
    );
  }

  static Future<String> textFromWavFile(String path, {String languageCode = 'tr-TR'}) async {
    return impl.textFromWavFileImpl(path, languageCode: languageCode);
  }

  static Future<void> userVoiceToCharacterVoice({
    required String wavFilePath,
    TtsVoiceType characterVoice = TtsVoiceType.female,
    String languageCode = 'tr-TR',
  }) async {
    final text = await textFromWavFile(wavFilePath, languageCode: languageCode);
    if (text.isEmpty) throw Exception('Ses anlaşılamadı, tekrar deneyin.');
    await speakText(text: text, voiceType: characterVoice, languageCode: languageCode);
  }

  static Future<void> stop() async {
    await player.stop();
  }

  static bool get isPlaying => player.playing;
}
