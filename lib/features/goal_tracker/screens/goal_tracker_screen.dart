import 'package:flutter/material.dart';

class GoalTrackerScreen extends StatelessWidget {
  const GoalTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal Tracker'), actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          final goals = ['Learn Flutter', 'Lose 10kg', 'Save \$5000', 'Read 24 Books', 'Run Marathon', 'Learn Spanish'];
          final progress = [0.75, 0.40, 0.60, 0.50, 0.30, 0.80];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goals[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: progress[index], minHeight: 8),
                  SizedBox(height: 4),
                  Text('${(progress[index] * 100).toInt()}% Complete', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
