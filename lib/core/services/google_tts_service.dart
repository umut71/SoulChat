import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:soulchat/core/config/env_config.dart';

/// Karakter kişiliğine uygun ses tonu.
enum TtsVoiceType {
  female,
  male,
  robotic,
}

/// Google Cloud Text-to-Speech API. Tek anahtar: EnvConfig.googleApiKey (Vertex/Map key).
class GoogleTtsService {
  static String get _apiKey => EnvConfig.googleApiKey;
  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  static const String _baseUrl = 'https://texttospeech.googleapis.com/v1';

  /// [languageCode]: tr-TR, en-US vb.
  static String _voiceName(TtsVoiceType type, [String languageCode = 'tr-TR']) {
    final lang = languageCode.split('-').first;
    final region = languageCode.contains('-') ? languageCode.split('-').last : 'TR';
    final code = '$lang-$region';
    switch (type) {
      case TtsVoiceType.female:
        return code == 'tr-TR' ? 'tr-TR-Standard-A' : 'en-US-Standard-A';
      case TtsVoiceType.male:
        return code == 'tr-TR' ? 'tr-TR-Standard-E' : 'en-US-Standard-D';
      case TtsVoiceType.robotic:
        return 'en-US-Wavenet-D'; // Daha nötr/mekanik
    }
  }

  /// Metni ses dosyasına dönüştürür; base64 MP3 döner.
  /// [text]: Okunacak metin.
  /// [voiceType]: Erkek, Kadın, Robotik.
  /// [languageCode]: tr-TR veya en-US.
  static Future<List<int>> synthesize({
    required String text,
    TtsVoiceType voiceType = TtsVoiceType.female,
    String languageCode = 'tr-TR',
  }) async {
    if (text.trim().isEmpty) throw Exception('TTS: metin boş');
    final name = _voiceName(voiceType, languageCode);
    try {
      final res = await _dio.post(
        '$_baseUrl/text:synthesize',
        queryParameters: {'key': _apiKey},
        data: {
          'input': {'text': text},
          'voice': {
            'languageCode': languageCode,
            'name': name,
          },
          'audioConfig': {
            'audioEncoding': 'MP3',
            'speakingRate': voiceType == TtsVoiceType.robotic ? 0.95 : 1.0,
            'pitch': voiceType == TtsVoiceType.robotic ? -1.0 : 0.0,
          },
        },
      );
      final data = res.data as Map<String, dynamic>?;
      final base64Audio = data?['audioContent'] as String?;
      if (base64Audio == null || base64Audio.isEmpty) {
        throw Exception('TTS: ses verisi alınamadı');
      }
      return base64Decode(base64Audio);
    } on DioException catch (e) {
      Object? msg = e.message;
      if (e.response?.data is Map) {
        final err = (e.response!.data as Map)['error'];
        msg = (err is Map ? err['message'] : null) ?? e.message;
      }
      throw Exception('TTS hatası: $msg');
    }
  }
}
