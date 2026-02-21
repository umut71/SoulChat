import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:soulchat/firebase_options.dart';
import 'package:soulchat/core/config/router_config.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/core/services/localization_service.dart';
import 'package:soulchat/core/services/fcm_service.dart';
import 'package:soulchat/core/services/remote_config_service.dart';
import 'package:soulchat/core/services/self_check_service.dart';
import 'package:soulchat/core/services/system_doctor_service.dart';
import 'package:soulchat/shared/providers/locale_provider.dart';
import 'package:soulchat/shared/providers/theme_provider.dart';

import 'package:soulchat/core/config/init_error.dart' as init_error;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  await _initAsync().timeout(
    const Duration(seconds: 6),
    onTimeout: () {
      init_error.firebaseInitError ??= 'Başlatma zaman aşımı';
    },
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    SystemDoctorService.reportGlobalError(details.exception, details.stack);
  };
  runZonedGuarded(() {
    if (init_error.firebaseInitError != null) {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade700),
                    const SizedBox(height: 16),
                    const Text(
                      'Firebase Bağlantı Hatası',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      init_error.firebaseInitError!,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      return;
    }
    runApp(
      const ProviderScope(
        child: SoulChatApp(),
      ),
    );
    Future.microtask(() => FcmService.initialize());
  }, (error, stack) {
    SystemDoctorService.reportGlobalError(error, stack);
  });
}

Future<void> _initAsync() async {
  final firebaseError = await safeInitFirebase();
  if (firebaseError != null) {
    debugPrint('[FIREBASE] Init hatası (uygulama yine de açılıyor): $firebaseError');
    init_error.firebaseInitError = firebaseError;
  }
  // Web'de önbellek çakışmalarını engelle; karakterlerin Firestore'dan akmasını sağla
  if (Firebase.apps.isNotEmpty) {
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  }
  // Auth oturumu: Web'de varsayılan LOCAL (IndexedDB); kullanıcı uygulamayı kapatıp açınca Home'dan devam eder.

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await RemoteConfigService.initialize()
        .timeout(const Duration(seconds: 3), onTimeout: () {
      debugPrint('[REMOTE_CONFIG] Zaman aşımı – varsayılanlarla devam.');
    });
  } catch (e) {
    debugPrint('[REMOTE_CONFIG] Hata: $e');
  }

  try {
    await SelfCheckService.runOnStartup();
  } catch (e) {
    debugPrint('[SELF_CHECK] Hata: $e');
  }
}

/// Güvenli başlatma: timeout ile takılmayı önler; hata olursa terminale yazar, uygulama yine açılır.
Future<String?> safeInitFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Firebase başlatma 5 saniyede tamamlanamadı.');
        },
      );
      // Web Persistence: eski önbellek verisi takılmasın; her seferinde sunucudan çek
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    }
    return null;
  } catch (e) {
    debugPrint('[FIREBASE] safeInitFirebase catch: $e');
    final msg = e.toString();
    if (msg.contains('already exists') || (msg.contains('DEFAULT') && msg.contains('exists'))) {
      return null;
    }
    return msg;
  }
}

/// Firebase başlatma hatası durumunda ekranda hata mesajı gösterir.
class FirebaseErrorApp extends StatelessWidget {
  final String message;

  const FirebaseErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade700),
                const SizedBox(height: 16),
                const Text(
                  'Firebase başlatılamadı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoulChatApp extends ConsumerWidget {
  const SoulChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'SoulChat: AI Universe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: LocalizationService.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return ValueListenableBuilder<String?>(
          valueListenable: SystemDoctorService.globalRecoveryMessage,
          builder: (_, message, __) {
            if (message != null) {
              return _RecoveryOverlay(message: message, onGoHome: () => router.go('/home'));
            }
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}

/// 2 saniye sonra otomatik kapanır ve ana sayfaya gider. Buton da aynı işlemi yapar.
class _RecoveryOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onGoHome;

  const _RecoveryOverlay({required this.message, required this.onGoHome});

  @override
  State<_RecoveryOverlay> createState() => _RecoveryOverlayState();
}

class _RecoveryOverlayState extends State<_RecoveryOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _closeAndGoHome);
  }

  void _closeAndGoHome() {
    if (!mounted) return;
    SystemDoctorService.clearRecovery();
    // Overlay kalktıktan sonra bir sonraki frame'de git; aynı frame'de hem
    // ValueListenableBuilder rebuild hem router.go '_elements.contains(element)' hatasına yol açar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onGoHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7C4DFF);
    return Material(
      color: Colors.black87,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 48, color: primaryColor),
                const SizedBox(height: 16),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  '2 saniye içinde ana sayfaya yönlendirileceksin.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _closeAndGoHome(),
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text('Şimdi ana sayfaya git'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
