import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProgressCard(context),
          const SizedBox(height: 16),
          _buildAchievementSection(context, 'Social', [
            _Achievement('First Friend', 'Add your first friend', FontAwesomeIcons.userPlus, true, 10),
            _Achievement('Popular', 'Get 50 friends', FontAwesomeIcons.users, false, 50),
            _Achievement('Social Butterfly', 'Get 100 friends', FontAwesomeIcons.userGroup, false, 100),
          ]),
          _buildAchievementSection(context, 'Messaging', [
            _Achievement('Chatterbox', 'Send 100 messages', FontAwesomeIcons.message, true, 25),
            _Achievement('Conversationalist', 'Send 1000 messages', FontAwesomeIcons.comments, false, 50),
          ]),
          _buildAchievementSection(context, 'Gaming', [
            _Achievement('First Win', 'Win your first game', FontAwesomeIcons.trophy, true, 20),
            _Achievement('Champion', 'Win 10 games', FontAwesomeIcons.crown, false, 75),
            _Achievement('Legend', 'Win a tournament', FontAwesomeIcons.award, false, 200),
          ]),
          _buildAchievementSection(context, 'Streaming', [
            _Achievement('First Stream', 'Start your first stream', FontAwesomeIcons.video, false, 30),
            _Achievement('Popular Streamer', 'Get 1000 viewers', FontAwesomeIcons.fire, false, 100),
          ]),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '12/45',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 12 / 45,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            const Text('Keep going! 33 more achievements to unlock'),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementSection(BuildContext context, String title, List<_Achievement> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...achievements.map((achievement) => _buildAchievementCard(context, achievement)),
      ],
    );
  }

  Widget _buildAchievementCard(BuildContext context, _Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: achievement.unlocked
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: FaIcon(
            achievement.icon,
            color: achievement.unlocked ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
        title: Text(
          achievement.title,
          style: TextStyle(
            color: achievement.unlocked ? null : Colors.grey,
          ),
        ),
        subtitle: Text(achievement.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.coins,
              size: 16,
              color: achievement.unlocked ? Colors.amber : Colors.grey,
            ),
            Text(
              '+${achievement.reward}',
              style: TextStyle(
                color: achievement.unlocked ? Colors.amber : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final int reward;

  _Achievement(this.title, this.description, this.icon, this.unlocked, this.reward);
}
