import 'package:flutter/material.dart';

class LanguageLearningScreen extends StatelessWidget {
  const LanguageLearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'Spanish', 'flag': '🇪🇸', 'progress': 0.65, 'lessons': 45},
      {'name': 'French', 'flag': '🇫🇷', 'progress': 0.32, 'lessons': 22},
      {'name': 'German', 'flag': '🇩🇪', 'progress': 0.18, 'lessons': 12},
      {'name': 'Japanese', 'flag': '🇯🇵', 'progress': 0.50, 'lessons': 35},
      {'name': 'Korean', 'flag': '🇰🇷', 'progress': 0.25, 'lessons': 18},
    ];
    
    return Scaffold(
      appBar: AppBar(title: const Text('Language Learning')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.language, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text('Learn a New Language', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Daily practice makes perfect', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Languages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...languages.map((lang) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(lang['flag'] as String, style: const TextStyle(fontSize: 40)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lang['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text('${lang['lessons']} lessons completed'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: lang['progress'] as double,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Language'),
      ),
    );
  }
}
