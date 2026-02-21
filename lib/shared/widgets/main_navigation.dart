import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/shared/widgets/gradient_background.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const MainNavigation({super.key, required this.child, required this.currentPath});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  static void _playTapSound() => SystemSound.play(SystemSoundType.click);

  int _indexFromPath(String path) {
    switch (path) {
      case '/home': return 0;
      case '/chat': return 1;
      case '/feed': return 2;
      case '/wallet': return 3;
      case '/marketplace': return 4;
      case '/profile': return 5;
      default: return 0;
    }
  }

  void _onItemTapped(int index) {
    HapticFeedback.lightImpact();
    _playTapSound();
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/chat');
        break;
      case 2:
        context.go('/feed');
        break;
      case 3:
        context.go('/wallet');
        break;
      case 4:
        context.go('/marketplace');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        fullScreen: true,
        colors: GradientBackground.deepSpaceGradient,
        child: widget.child,
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              border: Border(top: BorderSide(color: Colors.white24, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _indexFromPath(widget.currentPath),
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.secondaryColor,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house, size: 20),
                  activeIcon: FaIcon(FontAwesomeIcons.house, size: 24),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.message, size: 20),
                  activeIcon: FaIcon(FontAwesomeIcons.message, size: 24),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.rss, size: 20),
                  activeIcon: FaIcon(FontAwesomeIcons.rss, size: 24),
                  label: 'Akış',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.wallet, size: 20),
                  activeIcon: FaIcon(FontAwesomeIcons.wallet, size: 24),
                  label: 'Cüzdan',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.shop, size: 20),
                  activeIcon: FaIcon(FontAwesomeIcons.shop, size: 24),
                  label: 'Market',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.user, size: 20),
                  activeIcon: FaIcon(FontAwesomeIcons.user, size: 24),
                  label: 'Profil',
                ),
              ],
        ),
          ),
        ),
      ),
    );
  }
}
