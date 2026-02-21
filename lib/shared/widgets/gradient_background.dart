import 'package:flutter/material.dart';
import 'package:soulchat/core/theme/app_theme.dart';

/// Mor–mavi geçişli arka plan (tüm ekran veya bölüm).
class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool fullScreen;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.fullScreen = true,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  static List<Color> get defaultGradient => [
        AppTheme.primaryDark,
        AppTheme.primaryColor,
        const Color(0xFF4527A0),
        const Color(0xFF0A0E21),
      ];

  /// Derin uzay gradyanı – galaksi / premium ekranlar.
  static List<Color> get deepSpaceGradient => [
        const Color(0xFF0A0E21),
        const Color(0xFF1A1A2E),
        const Color(0xFF16213E),
        const Color(0xFF0F3460),
        const Color(0xFF533483),
        const Color(0xFF0A0E21),
      ];

  @override
  Widget build(BuildContext context) {
    final gradient = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? defaultGradient,
        ),
      ),
    );

    if (fullScreen) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: gradient),
          child,
        ],
      );
    }
    return gradient;
  }
}

/// Gradient buton stilleri
class GradientButtonStyle {
  static BoxDecoration primary({double radius = 12}) => BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration accent({double radius = 12}) => BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.secondaryColor, AppTheme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
