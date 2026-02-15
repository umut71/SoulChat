import 'package:flutter/material.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habit Tracker'), actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          final habits = ['Exercise', 'Read', 'Meditate', 'Drink Water', 'Early Wake', 'Healthy Eating', 'Study', 'Yoga'];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(habits[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text('${(index + 1) * 7} days streak', style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: List.generate(7, (i) => Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: i < 5 ? Colors.green : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Icon(i < 5 ? Icons.check : Icons.close, color: Colors.white)),
                    )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
