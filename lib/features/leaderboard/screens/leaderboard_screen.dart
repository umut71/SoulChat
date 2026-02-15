import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedPeriod = 'weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show leaderboard info
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPeriodSelector(),
          _buildTopThree(),
          Expanded(
            child: _buildLeaderboardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'daily', label: Text('Daily')),
          ButtonSegment(value: 'weekly', label: Text('Weekly')),
          ButtonSegment(value: 'all_time', label: Text('All Time')),
        ],
        selected: {_selectedPeriod},
        onSelectionChanged: (Set<String> newSelection) {
          setState(() {
            _selectedPeriod = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTopPlayer(2, 'Player 2', 8500, Colors.grey),
          _buildTopPlayer(1, 'Player 1', 12000, Colors.amber),
          _buildTopPlayer(3, 'Player 3', 7200, Colors.brown),
        ],
      ),
    );
  }

  Widget _buildTopPlayer(int rank, String name, int score, Color color) {
    final heights = {1: 120.0, 2: 100.0, 3: 80.0};
    final icons = {1: FontAwesomeIcons.crown, 2: FontAwesomeIcons.medal, 3: FontAwesomeIcons.award};

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: color.withOpacity(0.2),
                child: Text(
                  'P$rank',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FaIcon(icons[rank], color: color, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '$score pts',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: heights[rank],
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(8),
          child: Text(
            '#$rank',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 50,
      itemBuilder: (context, index) {
        final rank = index + 4;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            title: Text('Player $rank'),
            subtitle: Text('Level ${rank + 10}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${10000 - (rank * 100)} pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '↑ ${rank}',
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
