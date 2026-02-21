import 'package:dio/dio.dart';
import 'package:soulchat/core/config/env_config.dart';

/// Google Cloud API – Harita ve Çeviri. Tek anahtar: EnvConfig.googleApiKey (Vertex/Map key).
class GoogleCloudService {
  static String get _apiKey => EnvConfig.googleApiKey;
  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  /// Çeviri (Translation API v2).
  static Future<String> translate(String text, {String target = 'tr', String source = 'en'}) async {
    if (text.trim().isEmpty) return text;
    try {
      final res = await _dio.get(
        'https://translation.googleapis.com/language/translate/v2',
        queryParameters: {
          'key': _apiKey,
          'q': text,
          'target': target,
          if (source.isNotEmpty) 'source': source,
        },
      );
      final data = res.data as Map<String, dynamic>?;
      final translations = data?['data']?['translations'] as List<dynamic>?;
      final first = translations?.isNotEmpty == true ? translations!.first : null;
      return (first as Map<String, dynamic>?)?['translatedText'] as String? ?? text;
    } catch (e) {
      throw Exception('Translation error: $e');
    }
  }

  /// Harita: Static Map veya Places için aynı API key kullanılır.
  /// WebView/iframe: https://maps.googleapis.com/maps/api/js?key=$_apiKey
  /// Android/iOS: Native SDK'da aynı key set edilir.
  static String get mapsApiKey => _apiKey;
}
