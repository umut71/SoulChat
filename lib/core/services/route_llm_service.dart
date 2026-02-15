import 'package:dio/dio.dart';

class RouteLLMService {
  static const String _baseUrl = 'https://api.routellm.com/v1';
  static const String _apiKey = 'YOUR_ROUTE_LLM_API_KEY_HERE';
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<String> sendMessage(String message, {String? conversationId}) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4',
          'messages': [
            {'role': 'user', 'content': message}
          ],
          if (conversationId != null) 'conversation_id': conversationId,
        },
      );

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      throw Exception('RouteLLM API Error: $e');
    }
  }

  Future<List<String>> getSuggestions(String context) async {
    try {
      final response = await _dio.post(
        '/suggestions',
        data: {'context': context},
      );

      return List<String>.from(response.data['suggestions']);
    } catch (e) {
      return [];
    }
  }
}
