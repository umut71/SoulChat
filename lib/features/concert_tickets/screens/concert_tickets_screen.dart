import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ConcertTicketsScreen extends StatelessWidget {
  const ConcertTicketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concert Tickets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '🎫',
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Concert Tickets',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Coming soon with amazing features!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Features',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildFeatureItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureItems() {
    return [
      _buildFeatureItem('📱', 'Feature 1'),
      _buildFeatureItem('⚡', 'Feature 2'),
      _buildFeatureItem('🎯', 'Feature 3'),
      _buildFeatureItem('💡', 'Feature 4'),
    ];
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return FadeInLeft(
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Text(emoji, style: const TextStyle(fontSize: 24)),
          title: Text(text),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
