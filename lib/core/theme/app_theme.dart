import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SoulChat: AI Universe - Mor, gece mavisi ve neon detaylı premium tasarım.
class AppTheme {
  // Ana palet: mor, gece mavisi, neon
  static const Color primaryColor = Color(0xFF7C4DFF);
  static const Color primaryDark = Color(0xFF5E35B1);
  static const Color secondaryColor = Color(0xFF00E5FF);
  static const Color accentColor = Color(0xFF00E676);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color neonPink = Color(0xFFFF4081);

  /// Off-White – göz yormayan, premium metin rengi (#F3F4F6)
  static const Color offWhite = Color(0xFFF3F4F6);

  // Gece mavisi arka planlar
  static const Color darkBackground = Color(0xFF0A0E21);
  static const Color darkSurface = Color(0xFF12172D);
  static const Color darkCard = Color(0xFF1A2142);
  static const Color darkCardElevated = Color(0xFF252D52);

  // Açık tema (mor tonları)
  static const Color lightBackground = Color(0xFFF5F3FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFEDE7F6);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: lightSurface,
        background: lightBackground,
        error: Color(0xFFFF5252),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: lightSurface,
        foregroundColor: Color(0xFF1A2142),
        iconTheme: IconThemeData(color: Color(0xFF1A2142)),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: lightSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A2142), letterSpacing: 0.25),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A2142), letterSpacing: 0.2),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1A2142), letterSpacing: 0.2),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1A2142), letterSpacing: 0.15),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1A2142), letterSpacing: 0.15),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 0.1),
        ),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
        },
      ),
    );
  }

  // Dark Theme (gece mavisi + neon)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: darkSurface,
        background: darkBackground,
        error: Color(0xFFFF5252),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkSurface,
        foregroundColor: offWhite,
        iconTheme: const IconThemeData(color: offWhite),
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: offWhite, letterSpacing: 0.3),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkCard,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shadowColor: primaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: secondaryColor, width: 2)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: offWhite, letterSpacing: 0.25),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: offWhite, letterSpacing: 0.2),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: offWhite, letterSpacing: 0.2),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: offWhite, letterSpacing: 0.15),
          bodyLarge: TextStyle(fontSize: 16, color: offWhite, letterSpacing: 0.15),
          bodyMedium: TextStyle(fontSize: 14, color: offWhite.withOpacity(0.9), letterSpacing: 0.1),
          bodySmall: TextStyle(fontSize: 12, color: offWhite.withOpacity(0.85), letterSpacing: 0.1),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: offWhite, letterSpacing: 0.2),
        ),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class _SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.03, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }
}
