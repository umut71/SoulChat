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
import 'package:soulchat/features/friends/screens/friends_screen.dart';
import 'package:soulchat/features/stories/screens/stories_screen.dart';
import 'package:soulchat/features/notifications/screens/notifications_screen.dart';
import 'package:soulchat/features/search/screens/search_screen.dart';
import 'package:soulchat/features/achievements/screens/achievements_screen.dart';
import 'package:soulchat/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:soulchat/features/tournaments/screens/tournaments_screen.dart';
import 'package:soulchat/features/premium/screens/premium_screen.dart';
import 'package:soulchat/features/about/screens/about_screen.dart';
import 'package:soulchat/features/support/screens/support_screen.dart';
import 'package:soulchat/features/music_studio/screens/music_studio_screen.dart';
import 'package:soulchat/features/image_editor/screens/image_editor_screen.dart';
import 'package:soulchat/features/video_editor/screens/video_editor_screen.dart';
import 'package:soulchat/features/ai_tools/screens/ai_tools_screen.dart';
import 'package:soulchat/features/rewards/screens/rewards_screen.dart';
import 'package:soulchat/features/events/screens/events_screen.dart';
import 'package:soulchat/features/groups/screens/groups_screen.dart';
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
      
      // Social Features
      GoRoute(
        path: '/friends',
        name: 'friends',
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/stories',
        name: 'stories',
        builder: (context, state) => const StoriesScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/groups',
        name: 'groups',
        builder: (context, state) => const GroupsScreen(),
      ),
      
      // Gaming
      GoRoute(
        path: '/games',
        name: 'games',
        builder: (context, state) => const GamesScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/tournaments',
        name: 'tournaments',
        builder: (context, state) => const TournamentsScreen(),
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      
      // Creative Tools
      GoRoute(
        path: '/music-studio',
        name: 'music-studio',
        builder: (context, state) => const MusicStudioScreen(),
      ),
      GoRoute(
        path: '/image-editor',
        name: 'image-editor',
        builder: (context, state) => const ImageEditorScreen(),
      ),
      GoRoute(
        path: '/video-editor',
        name: 'video-editor',
        builder: (context, state) => const VideoEditorScreen(),
      ),
      GoRoute(
        path: '/ai-tools',
        name: 'ai-tools',
        builder: (context, state) => const AIToolsScreen(),
      ),
      
      // Other Features
      GoRoute(
        path: '/live',
        name: 'live',
        builder: (context, state) => const LiveStreamingScreen(),
      ),
      GoRoute(
        path: '/voice-chat',
        name: 'voice-chat',
        builder: (context, state) => const VoiceChatScreen(),
      ),
      GoRoute(
        path: '/rewards',
        name: 'rewards',
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/premium',
        name: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      
      // Settings & Info
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportScreen(),
      ),
    ],
  );
});
