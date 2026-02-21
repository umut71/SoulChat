import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:soulchat/core/config/env_config.dart';

/// Google Cloud Speech-to-Text API. Tek anahtar: EnvConfig.googleApiKey (Vertex/Map key).
class GoogleSttService {
  static String get _apiKey => EnvConfig.googleApiKey;
  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static const String _baseUrl = 'https://speech.googleapis.com/v1/speech:recognize';

  /// Ses dosyası bytes (tek kanal, 16-bit PCM veya FLAC/LINEAR16 önerilir).
  /// [audioBytes]: Ham ses (ör. 16kHz mono LINEAR16).
  /// [encoding]: LINEAR16, FLAC, MP3 vb. (API dokümanına göre).
  /// [sampleRateHertz]: 16000 önerilir.
  static Future<String> recognize({
    required List<int> audioBytes,
    String languageCode = 'tr-TR',
    String encoding = 'LINEAR16',
    int sampleRateHertz = 16000,
  }) async {
    if (audioBytes.isEmpty) throw Exception('STT: ses verisi boş');
    try {
      final res = await _dio.post(
        _baseUrl,
        queryParameters: {'key': _apiKey},
        data: {
          'config': {
            'encoding': encoding,
            'sampleRateHertz': sampleRateHertz,
            'languageCode': languageCode,
            'model': 'default',
          },
          'audio': {
            'content': base64Encode(audioBytes),
          },
        },
      );
      final data = res.data as Map<String, dynamic>?;
      final results = data?['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        return '';
      }
      final first = results.first as Map<String, dynamic>;
      final alternatives = first['alternatives'] as List<dynamic>?;
      if (alternatives == null || alternatives.isEmpty) return '';
      final altFirst = alternatives.first as Map<String, dynamic>;
      final transcript = altFirst['transcript'] as String?;
      return transcript?.trim() ?? '';
    } on DioException catch (e) {
      Object? msg = e.message;
      if (e.response?.data is Map) {
        final err = (e.response!.data as Map)['error'];
        msg = (err is Map ? err['message'] : null) ?? e.message;
      }
      throw Exception('STT hatası: $msg');
    }
  }

  /// WAV dosya bytes; API encoding ve sample rate'i başlıktan çıkarır.
  static Future<String> recognizeFromWav(
    List<int> wavBytes, {
    String languageCode = 'tr-TR',
  }) async {
    if (wavBytes.isEmpty) throw Exception('STT: WAV verisi boş');
    try {
      final res = await _dio.post(
        _baseUrl,
        queryParameters: {'key': _apiKey},
        data: {
          'config': {
            'languageCode': languageCode,
            'model': 'default',
            // encoding/sampleRate belirtilmez; WAV header'dan algılanır
          },
          'audio': {'content': base64Encode(wavBytes)},
        },
      );
      final data = res.data as Map<String, dynamic>?;
      final results = data?['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return '';
      final first = results.first as Map<String, dynamic>;
      final alternatives = first['alternatives'] as List<dynamic>?;
      if (alternatives == null || alternatives.isEmpty) return '';
      final altFirst = alternatives.first as Map<String, dynamic>;
      final transcript = altFirst['transcript'] as String?;
      return transcript?.trim() ?? '';
    } on DioException catch (e) {
      Object? msg = e.message;
      if (e.response?.data is Map) {
        final err = (e.response!.data as Map)['error'];
        msg = (err is Map ? err['message'] : null) ?? e.message;
      }
      throw Exception('STT hatası: $msg');
    }
  }

  /// Base64 string olarak ses (kayıt servisi base64 veya bytes verebilir).
  static Future<String> recognizeFromBase64(
    String base64Audio, {
    String languageCode = 'tr-TR',
    String encoding = 'LINEAR16',
    int sampleRateHertz = 16000,
  }) async {
    final bytes = base64Decode(base64Audio);
    return recognize(
      audioBytes: bytes,
      languageCode: languageCode,
      encoding: encoding,
      sampleRateHertz: sampleRateHertz,
    );
  }
}
