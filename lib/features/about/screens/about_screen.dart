import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoulChat: AI Universe Hakkında'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppInfo(context),
          const SizedBox(height: 24),
          _buildFeaturesList(context),
          const SizedBox(height: 24),
          _buildTeamSection(context),
          const SizedBox(height: 24),
          _buildSocialLinks(context),
          const SizedBox(height: 24),
          _buildLegalLinks(context),
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF00D9C0)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'SoulChat: AI Universe',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0'),
            const SizedBox(height: 16),
            const Text(
              'World-class social, gaming & crypto mobile application',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(FontAwesomeIcons.message, 'Real-time Messaging'),
            _buildFeatureItem(FontAwesomeIcons.video, 'Video & Voice Calls'),
            _buildFeatureItem(FontAwesomeIcons.broadcastTower, 'Live Streaming'),
            _buildFeatureItem(FontAwesomeIcons.gamepad, 'Mini Games'),
            _buildFeatureItem(FontAwesomeIcons.coins, 'SoulCoin Wallet'),
            _buildFeatureItem(FontAwesomeIcons.shop, 'Marketplace'),
            _buildFeatureItem(FontAwesomeIcons.globe, '12 Languages'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          FaIcon(icon, size: 20),
          const SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our Team',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Built with ❤️ by a passionate team of developers, designers, and innovators who believe in connecting people through technology.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect With Us',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(FontAwesomeIcons.twitter, Colors.blue, 'https://twitter.com'),
                _buildSocialButton(FontAwesomeIcons.facebook, Colors.blue.shade800, 'https://facebook.com'),
                _buildSocialButton(FontAwesomeIcons.instagram, Colors.pink, 'https://instagram.com'),
                _buildSocialButton(FontAwesomeIcons.github, Colors.black, 'https://github.com/umut71/SoulChat'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String url) {
    return IconButton(
      icon: FaIcon(icon),
      color: color,
      iconSize: 32,
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
    );
  }

  Widget _buildLegalLinks(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => context.push('/terms'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => context.push('/privacy'),
        ),
        ListTile(
          leading: const Icon(Icons.gavel),
          title: const Text('Licenses'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => showLicensePage(context: context),
        ),
      ],
    );
  }
}
