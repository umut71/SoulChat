import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'General Knowledge', 'icon': Icons.lightbulb, 'color': Colors.blue, 'quizzes': 50},
      {'name': 'Science', 'icon': Icons.science, 'color': Colors.green, 'quizzes': 35},
      {'name': 'History', 'icon': Icons.history_edu, 'color': Colors.orange, 'quizzes': 40},
      {'name': 'Geography', 'icon': Icons.public, 'color': Colors.teal, 'quizzes': 45},
      {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.red, 'quizzes': 30},
      {'name': 'Movies', 'icon': Icons.movie, 'color': Colors.purple, 'quizzes': 38},
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz & Trivia'),
        actions: [
          IconButton(icon: const Icon(Icons.leaderboard), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.blue.shade600],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Points', '2,450', Icons.stars),
                  _buildStat('Rank', '#127', Icons.emoji_events),
                  _buildStat('Streak', '5 days', Icons.local_fire_department),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(category['icon'] as IconData, size: 48, color: category['color'] as Color),
                                const SizedBox(height: 12),
                                Text(
                                  category['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${category['quizzes']} quizzes',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
