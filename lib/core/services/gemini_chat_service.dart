import 'package:soulchat/core/services/gemini_service.dart';
import 'package:soulchat/core/services/google_image_service.dart';

/// Tüm AI (DeepAgent, sohbet, analiz, görsel) Google Cloud Gemini üzerinden.
/// RouteLLM/Abacus kaldırıldı – .env GOOGLE_API_KEY ile gerçek istek.
class GeminiChatService {
  Future<String> sendMessage(String message, {String? conversationId}) async {
    return GeminiService.sendMessage(message, conversationId: conversationId);
  }

  Future<List<String>> getSuggestions(String context) async {
    return GeminiService.getSuggestions(context);
  }

  Future<String> generateImage(String prompt) async {
    return GoogleImageService.generateImage(prompt);
  }
}
