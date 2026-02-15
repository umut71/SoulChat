import 'package:flutter/material.dart';

class TimeTrackerScreen extends StatelessWidget {
  const TimeTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Tracker')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text('Today', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('6h 45m', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  ElevatedButton.icon(icon: Icon(Icons.play_arrow), label: Text('Start Timer'), onPressed: () {}),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.work)),
                    title: Text('Project ${index + 1}'),
                    subtitle: Text('${45 + index * 5} minutes'),
                    trailing: Text('Today'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
