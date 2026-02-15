import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Rewards'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStreakCard(context),
          const SizedBox(height: 24),
          _buildDailyCheckIn(context),
          const SizedBox(height: 24),
          _buildTasksList(context),
          const SizedBox(height: 24),
          _buildSpinWheel(context),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.fire, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Text(
                  '7 Day Streak!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Keep your streak going to earn bonus rewards!',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: index < 7 ? Colors.white : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: index < 7
                        ? const FaIcon(FontAwesomeIcons.check, color: Color(0xFFFF6B6B))
                        : Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckIn(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Check-In',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: List.generate(
                28,
                (index) {
                  final isChecked = index < 7;
                  final isToday = index == 7;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF00D9C0)],
                            )
                          : null,
                      color: isChecked ? Colors.green.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isToday ? Colors.transparent : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Day ${index + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isToday ? Colors.white : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isChecked)
                          const FaIcon(FontAwesomeIcons.check, color: Colors.green, size: 16)
                        else
                          FaIcon(
                            FontAwesomeIcons.coins,
                            color: isToday ? Colors.white : Colors.amber,
                            size: 16,
                          ),
                        Text(
                          '+${(index + 1) * 10}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    final tasks = [
      _Task('Send 10 messages', 50, true),
      _Task('Win a game', 100, true),
      _Task('Join a voice room', 75, false),
      _Task('Watch a stream', 30, false),
      _Task('Invite a friend', 200, false),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...tasks.map((task) => _buildTaskItem(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(_Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: task.completed ? Colors.green.shade100 : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              task.completed ? Icons.check : Icons.assignment,
              color: task.completed ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.coins, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('+${task.reward}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          if (!task.completed)
            ElevatedButton(
              onPressed: () {},
              child: const Text('Claim'),
            )
          else
            const FaIcon(FontAwesomeIcons.check, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildSpinWheel(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const FaIcon(FontAwesomeIcons.dharmachakra, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Spin the Wheel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Win up to 10,000 SoulCoins!',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Spin Now (100 SC)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Task {
  final String title;
  final int reward;
  final bool completed;

  _Task(this.title, this.reward, this.completed);
}
