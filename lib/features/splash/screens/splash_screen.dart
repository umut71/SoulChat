import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:soulchat/core/config/init_error.dart' as init_error;
import 'package:soulchat/core/constants/app_constants.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/shared/widgets/gradient_background.dart';

/// Logo ekranında takılmamak için: 3 saniye sonra zorla ana sayfaya geç.
const Duration _forceNavigateAfter = Duration(seconds: 3);
const Duration _dataTimeout = Duration(seconds: 5);
const Duration _connectionErrorShowAfter = Duration(seconds: 5);

/// Uygulama açılışı – 3 s sonra ana sayfa; hata varsa logoyu kaldırıp hatayı gösterir.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showConnectionError = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadInBackground();
    // 3 saniye sonra zorla ana sayfaya geç (Firebase/bağlantı gecikse bile logo takılmaz)
    Future.delayed(_forceNavigateAfter, () {
      if (!mounted) return;
      context.go('/home');
    });
    // 5 s sonra hâlâ bu ekrandaysak "Bağlantı Hatası" + buton göster
    Future.delayed(_connectionErrorShowAfter, () {
      if (!mounted) return;
      setState(() => _showConnectionError = true);
    });
  }

  /// Firebase/karakter verisi arka planda yüklenir; 5 sn içinde gelmezse tekrar dene butonu gösterilir.
  void _loadInBackground() {
    setState(() => _loadError = null);
    FirestoreService.getCharacters().timeout(
      _dataTimeout,
      onTimeout: () => <Map<String, dynamic>>[],
    ).then((list) async {
      if (list.isEmpty) {
        try {
          await FirestoreService.seedSampleCharactersIfEmpty();
        } catch (_) {}
      }
      if (mounted) setState(() => _loadError = null);
    }).catchError((e, st) {
      if (mounted) setState(() => _loadError = e?.toString() ?? 'Veritabanı hatası');
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = init_error.firebaseInitError != null || _loadError != null;
    final errorMessage = init_error.firebaseInitError ?? _loadError;

    // Hata varsa: logoyu kaldır, sadece hata metni + Ana Sayfaya Git
    if (hasError && errorMessage != null) {
      return Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange.shade200),
                    const SizedBox(height: 24),
                    Text(
                      'Bağlantı Hatası',
                      style: TextStyle(
                        color: Colors.orange.shade200,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      errorMessage.length > 200 ? '${errorMessage.substring(0, 200)}...' : errorMessage,
                      style: TextStyle(color: AppTheme.offWhite.withOpacity(0.95), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.go('/home');
                      },
                      child: const Text('Ana Sayfaya Git'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Giriş animasyonu: tam ekran uzay/galaksi Lottie, üstte logo + başlık
    const galaxyLottieUrl = 'https://assets10.lottiefiles.com/packages/lf20_u4yrau.json';
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackground(
            fullScreen: true,
            colors: GradientBackground.deepSpaceGradient,
            child: const SizedBox.expand(),
          ),
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/galaxy_intro.json',
              fit: BoxFit.cover,
              repeat: true,
              errorBuilder: (_, __, ___) => Lottie.network(
                galaxyLottieUrl,
                fit: BoxFit.cover,
                repeat: true,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Pulse(
                      duration: const Duration(milliseconds: 2000),
                      infinite: true,
                      child: _buildLogo(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeIn(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.offWhite.withOpacity(0.95),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                if (_showConnectionError) ...[
                  Text(
                    'Bağlantı hatası, tekrar dene',
                    style: TextStyle(
                      color: AppTheme.offWhite.withOpacity(0.95),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _loadInBackground();
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Tekrar Dene'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.go('/home');
                    },
                    child: const Text('Ana Sayfaya Git'),
                  ),
                ] else ...[
                  Text(
                    'Galaksi Hazırlanıyor...',
                    style: TextStyle(
                      color: AppTheme.offWhite.withOpacity(0.95),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3 saniye içinde ana sayfaya yönlendirileceksiniz.',
                    style: TextStyle(
                      color: AppTheme.offWhite.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.6),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'SC',
          style: TextStyle(
            color: AppTheme.offWhite,
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
