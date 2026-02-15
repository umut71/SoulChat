import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('SoulChat Premium'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.crown, size: 80, color: Colors.white),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFeaturesList(context),
                  const SizedBox(height: 24),
                  _buildPricingCards(context),
                  const SizedBox(height: 24),
                  _buildFAQ(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = [
      _PremiumFeature('Ad-Free Experience', 'No ads, ever', FontAwesomeIcons.ban),
      _PremiumFeature('Unlimited Voice Effects', 'Access all voice changers', FontAwesomeIcons.microphone),
      _PremiumFeature('Custom Themes', 'Personalize your app', FontAwesomeIcons.palette),
      _PremiumFeature('Priority Support', '24/7 premium support', FontAwesomeIcons.headset),
      _PremiumFeature('Exclusive Badges', 'Show your VIP status', FontAwesomeIcons.certificate),
      _PremiumFeature('Double SoulCoins', 'Earn 2x coins on everything', FontAwesomeIcons.coins),
      _PremiumFeature('HD Streaming', 'Stream in 1080p quality', FontAwesomeIcons.video),
      _PremiumFeature('Unlimited Storage', 'Save unlimited media', FontAwesomeIcons.cloudArrowUp),
    ];

    return Card(
      color: const Color(0xFF16213E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Premium Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(feature.icon, color: const Color(0xFFFFD700), size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              feature.description,
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCards(BuildContext context) {
    return Column(
      children: [
        _buildPricingCard(
          context,
          'Monthly',
          '\$9.99',
          'per month',
          false,
        ),
        const SizedBox(height: 12),
        _buildPricingCard(
          context,
          'Yearly',
          '\$79.99',
          'per year (Save 33%)',
          true,
        ),
        const SizedBox(height: 12),
        _buildPricingCard(
          context,
          'Lifetime',
          '\$199.99',
          'one-time payment',
          false,
        ),
      ],
    );
  }

  Widget _buildPricingCard(BuildContext context, String title, String price, String subtitle, bool recommended) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: recommended
              ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
              : [const Color(0xFF16213E), const Color(0xFF1A1A2E)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: recommended ? Colors.transparent : Colors.grey.shade700,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (recommended)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'BEST VALUE',
                  style: TextStyle(
                    color: Color(0xFFFFA500),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade400),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: recommended ? Colors.white : const Color(0xFFFFD700),
                  foregroundColor: recommended ? const Color(0xFFFFA500) : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Subscribe Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(BuildContext context) {
    return Card(
      color: const Color(0xFF16213E),
      child: ExpansionTile(
        title: const Text('Frequently Asked Questions', style: TextStyle(color: Colors.white)),
        children: [
          _buildFAQItem('Can I cancel anytime?', 'Yes, you can cancel your subscription at any time.'),
          _buildFAQItem('What payment methods do you accept?', 'We accept all major credit cards and PayPal.'),
          _buildFAQItem('Is there a free trial?', 'Yes, new users get 7 days free trial.'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(answer, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _PremiumFeature {
  final String title;
  final String description;
  final IconData icon;

  _PremiumFeature(this.title, this.description, this.icon);
}
