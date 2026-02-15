import 'package:flutter/material.dart';

class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager'), actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Total', '45', Colors.blue),
                  _buildStat('Completed', '28', Colors.green),
                  _buildStat('Pending', '17', Colors.orange),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: CheckboxListTile(
                    title: Text('Task ${index + 1}'),
                    subtitle: Text('Due: Today'),
                    value: index % 3 == 0,
                    onChanged: (v) {},
                    secondary: Icon(Icons.task_alt),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label),
      ],
    );
  }
}
