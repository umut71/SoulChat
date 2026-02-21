import 'package:soulchat/core/services/gemini_service.dart';

/// Müzik Stüdyosu: Vertex/Gemini ile tema analizi ve öneri; ileride MusicLM/Suno bağlanabilir.
class MusicStudioService {
  /// Temaya göre Vertex (Gemini) ile kısa müzik önerisi/şarkı fikri üretir.
  static Future<MusicStudioResult> generateFromTheme(String theme) async {
    if (theme.trim().isEmpty) {
      throw Exception('Lütfen bir tema veya duygu yazın.');
    }
    try {
      final prompt = '''Tema: "$theme"
Bu tema için kısa bir müzik/şarkı fikri ver (2-3 cümle, Türkçe): tür, tempo, duygu ve bir dize önerisi. Sadece bu metni yaz, başka açıklama ekleme.''';
      final reply = await GeminiService.sendMessage(prompt);
      return MusicStudioResult(
        success: true,
        theme: theme,
        title: 'Tema: $theme',
        message: reply.trim(),
        audioUrl: null,
        placeholderDemo: false,
      );
    } catch (e) {
      return MusicStudioResult(
        success: false,
        theme: theme,
        title: 'Tema: $theme',
        message: 'Vertex bağlantısı şu an yok. İnternet ve API anahtarını kontrol edip tekrar deneyin.',
        audioUrl: null,
        placeholderDemo: true,
      );
    }
  }
}

class MusicStudioResult {
  final bool success;
  final String theme;
  final String title;
  final String message;
  final String? audioUrl;
  final bool placeholderDemo;

  MusicStudioResult({
    required this.success,
    required this.theme,
    required this.title,
    required this.message,
    this.audioUrl,
    this.placeholderDemo = false,
  });
}
