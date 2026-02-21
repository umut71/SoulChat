import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulchat/features/ai_companion/screens/ai_companion_screen.dart';
import 'package:soulchat/features/games/screens/games_screen.dart';
import 'package:soulchat/features/home/screens/all_features_screen.dart';
import 'package:soulchat/features/live_streaming/screens/live_streaming_screen.dart';
import 'package:soulchat/features/voice_chat/screens/voice_chat_screen.dart';

/// GoRouter context hatası (No GoRouter found) olunca Navigator ile güvenli geçiş.
class SafeNav {
  SafeNav._();

  static void push(BuildContext context, String route) {
    final Widget? page = _routeToPage(route);
    if (page != null) {
      debugPrint('[GEMINI_DEBUG] Sayfa açılıyor (Navigator): $route');
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      return;
    }
    try {
      debugPrint('[GEMINI_DEBUG] Sayfa açılıyor (GoRouter): $route');
      context.push(route);
    } catch (e) {
      debugPrint('[GEMINI_DEBUG] Navigasyon hatası: $route — $e');
    }
  }

  static Widget? _routeToPage(String route) {
    switch (route) {
      case '/ai-companion':
        return const AiCompanionScreen();
      case '/live':
        return const LiveStreamingScreen();
      case '/voice-chat':
        return const VoiceChatScreen();
      case '/games':
        return const GamesScreen();
      case '/all-features':
        return const AllFeaturesScreen();
      default:
        return null;
    }
  }
}
