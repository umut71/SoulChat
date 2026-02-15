import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulchat/features/auth/screens/login_screen.dart';
import 'package:soulchat/features/auth/screens/register_screen.dart';
import 'package:soulchat/features/home/screens/home_screen.dart';
import 'package:soulchat/features/chat/screens/chat_list_screen.dart';
import 'package:soulchat/features/chat/screens/chat_detail_screen.dart';
import 'package:soulchat/features/profile/screens/profile_screen.dart';
import 'package:soulchat/features/wallet/screens/wallet_screen.dart';
import 'package:soulchat/features/marketplace/screens/marketplace_screen.dart';
import 'package:soulchat/features/games/screens/games_screen.dart';
import 'package:soulchat/features/live_streaming/screens/live_streaming_screen.dart';
import 'package:soulchat/features/voice_chat/screens/voice_chat_screen.dart';
import 'package:soulchat/features/settings/screens/settings_screen.dart';
import 'package:soulchat/shared/widgets/main_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main App Routes with Navigation Bar
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: '/wallet',
            name: 'wallet',
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: '/marketplace',
            name: 'marketplace',
            builder: (context, state) => const MarketplaceScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Chat Detail
      GoRoute(
        path: '/chat/:id',
        name: 'chat-detail',
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          return ChatDetailScreen(chatId: chatId);
        },
      ),
      
      // Games
      GoRoute(
        path: '/games',
        name: 'games',
        builder: (context, state) => const GamesScreen(),
      ),
      
      // Live Streaming
      GoRoute(
        path: '/live',
        name: 'live',
        builder: (context, state) => const LiveStreamingScreen(),
      ),
      
      // Voice Chat
      GoRoute(
        path: '/voice-chat',
        name: 'voice-chat',
        builder: (context, state) => const VoiceChatScreen(),
      ),
      
      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
