import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:soulchat/core/theme/app_theme.dart';

/// Lottie ile boş liste / boş durum ekranı
class EmptyStateLottie extends StatelessWidget {
  final String message;
  final String? lottieUrl;
  final double size;

  const EmptyStateLottie({
    super.key,
    this.message = 'Henüz veri yok',
    this.lottieUrl,
    this.size = 200,
  });

  static const String defaultLottie = 'https://lottie.host/6f0b8c8e-5c75-4c8a-9c5e-8e5f5e5e5e5e/empty.json';
  static const String successLottie = 'https://lottie.host/1e5a8c8e-5c75-4c8a-9c5e-8e5f5e5e5e5e/success.json';

  @override
  Widget build(BuildContext context) {
    final url = lottieUrl ?? 'https://assets10.lottiefiles.com/packages/lf20_u4yrau.json';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: Lottie.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.inbox_outlined,
                  size: size * 0.5,
                  color: AppTheme.primaryColor.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Başarılı işlem sonrası kısa Lottie
class SuccessLottieOverlay extends StatelessWidget {
  final String? lottieUrl;

  const SuccessLottieOverlay({super.key, this.lottieUrl});

  @override
  Widget build(BuildContext context) {
    final url = lottieUrl ?? 'https://assets10.lottiefiles.com/packages/lf20_success_kux3eqhi.json';
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: Lottie.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.check_circle, color: Colors.green, size: 80),
        ),
      ),
    );
  }
}
