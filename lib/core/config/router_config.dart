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
import 'package:soulchat/features/home/screens/all_features_screen.dart';
import 'package:soulchat/features/games/screens/coin_flip_screen.dart';
import 'package:soulchat/features/ai_companion/screens/ai_companion_screen.dart';
import 'package:soulchat/features/feed/screens/feed_screen.dart';
import 'package:soulchat/features/splash/screens/splash_screen.dart';
import 'package:soulchat/features/legal/screens/terms_screen.dart';
import 'package:soulchat/features/legal/screens/privacy_screen.dart';
import 'package:soulchat/shared/widgets/main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulchat/shared/providers/auth_provider.dart';
import 'package:soulchat/core/config/extra_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier(0);
  ref.listen(authStateProvider, (_, __) {
    refreshNotifier.value++;
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final asyncUser = ref.read(authStateProvider);
      final path = state.uri.path;
      // Auth Persistence: loading sırasında da currentUser ile giriş yapmış kullanıcıyı Login'e fırlatma
      final currentUser = FirebaseAuth.instance.currentUser;
      return asyncUser.when(
        data: (user) {
          final u = user ?? currentUser;
          if (u == null) {
            if (path == '/splash' || path == '/login' || path == '/register' ||
                path == '/terms' || path == '/privacy') return null;
            return '/login';
          }
          if (path == '/login' || path == '/register') return '/home';
          return null;
        },
        loading: () {
          if (currentUser != null && (path == '/login' || path == '/register')) return '/home';
          return null;
        },
        error: (_, __) => currentUser != null ? null : '/login',
      );
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                'Sayfa bulunamadı: ${state.uri.path}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Ana Sayfaya Git'),
              ),
            ],
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      
      // Main App Routes with Navigation Bar
      ShellRoute(
        builder: (context, state, child) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            final path = state.uri.path;
            if (path == '/home' || path == '/splash') {
              // Ana sayfada geri tuşu: uygulamadan çıkma (isteğe bağlı çıkış dialog'u eklenebilir)
              return;
            }
            GoRouter.of(context).pop();
          },
          child: MainNavigation(child: child, currentPath: state.uri.path),
        ),
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
            path: '/feed',
            name: 'feed',
            builder: (context, state) => const FeedScreen(),
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
      GoRoute(
        path: '/all-features',
        name: 'all-features',
        builder: (context, state) => const AllFeaturesScreen(),
      ),
      GoRoute(
        path: '/coin-flip',
        name: 'coin-flip',
        builder: (context, state) => const CoinFlipScreen(),
      ),
      GoRoute(
        path: '/ai-companion',
        name: 'ai-companion',
        builder: (context, state) => const AiCompanionScreen(),
      ),
      ...extraRoutes,
    ],
  );
});
