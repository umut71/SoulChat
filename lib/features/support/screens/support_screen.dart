import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildFAQSection(context),
          const SizedBox(height: 24),
          _buildContactSection(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(context, 'Live Chat', FontAwesomeIcons.comments, Colors.blue),
                _buildActionCard(context, 'Email Us', FontAwesomeIcons.envelope, Colors.green),
                _buildActionCard(context, 'Call Us', FontAwesomeIcons.phone, Colors.orange),
                _buildActionCard(context, 'Video Guide', FontAwesomeIcons.video, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Frequently Asked Questions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          _buildFAQItem(
            'How do I reset my password?',
            'Go to Settings > Account > Change Password to reset your password.',
            context,
          ),
          _buildFAQItem(
            'How do I earn SoulCoins?',
            'You can earn SoulCoins through daily login, completing challenges, winning games, and inviting friends.',
            context,
          ),
          _buildFAQItem(
            'How do I report a user?',
            'Visit the user\'s profile and tap the menu icon, then select "Report User".',
            context,
          ),
          _buildFAQItem(
            'How do I delete my account?',
            'Go to Settings > Account > Delete Account. Please note this action is irreversible.',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildContactItem(FontAwesomeIcons.envelope, 'support@soulchat.app'),
            _buildContactItem(FontAwesomeIcons.phone, '+1 (555) 123-4567'),
            _buildContactItem(FontAwesomeIcons.locationDot, '123 Tech Street, Silicon Valley, CA'),
            const SizedBox(height: 16),
            const Text('Support Hours: Mon-Fri, 9 AM - 6 PM PST'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          FaIcon(icon, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
