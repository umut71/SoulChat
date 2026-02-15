import 'package:flutter/material.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessions = [
      {'title': 'Morning Meditation', 'duration': '10 min', 'icon': '🌅'},
      {'title': 'Stress Relief', 'duration': '15 min', 'icon': '😌'},
      {'title': 'Sleep Sounds', 'duration': '30 min', 'icon': '🌙'},
      {'title': 'Focus Flow', 'duration': '20 min', 'icon': '🧘'},
      {'title': 'Breathe Easy', 'duration': '5 min', 'icon': '💨'},
      {'title': 'Gratitude Practice', 'duration': '12 min', 'icon': '🙏'},
    ];
    
    return Scaffold(
      appBar: AppBar(title: const Text('Meditation & Mindfulness')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade300, Colors.blue.shade300],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.self_improvement, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text('Find Your Inner Peace', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Daily meditation for a better you', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(session['icon']!, style: const TextStyle(fontSize: 40)),
                    title: Text(session['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(session['duration']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_filled, color: Colors.purple, size: 40),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
