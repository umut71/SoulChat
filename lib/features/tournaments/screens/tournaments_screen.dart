import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TournamentsScreen extends StatelessWidget {
  const TournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeaturedTournament(context),
          const SizedBox(height: 24),
          Text(
            'Active Tournaments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...List.generate(
            5,
            (index) => _buildTournamentCard(context, index, isActive: true),
          ),
          const SizedBox(height: 24),
          Text(
            'Upcoming Tournaments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...List.generate(
            3,
            (index) => _buildTournamentCard(context, index, isActive: false),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const FaIcon(FontAwesomeIcons.trophy),
        label: const Text('Create Tournament'),
      ),
    );
  }

  Widget _buildFeaturedTournament(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.live_tv, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grand Championship',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.users, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      '128 Players',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    const FaIcon(FontAwesomeIcons.coins, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      '10,000 SC Prize',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, int index, {required bool isActive}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tournament ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.users, size: 14),
                const SizedBox(width: 6),
                Text('${(index + 1) * 16}/64 players'),
                const SizedBox(width: 20),
                const FaIcon(FontAwesomeIcons.coins, size: 14),
                const SizedBox(width: 6),
                Text('${(index + 1) * 1000} SC'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: ((index + 1) * 16) / 64,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(isActive ? 'Join' : 'Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
