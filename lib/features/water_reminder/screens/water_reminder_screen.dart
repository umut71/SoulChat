import 'package:flutter/material.dart';

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({Key? key}) : super(key: key);

  @override
  State<WaterReminderScreen> createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  int _currentIntake = 6;
  final int _goalIntake = 8;

  @override
  Widget build(BuildContext context) {
    final percentage = (_currentIntake / _goalIntake * 100).toInt();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Water Reminder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Text('Today\'s Water Intake', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 24),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: _currentIntake / _goalIntake,
                            strokeWidth: 16,
                            backgroundColor: Colors.blue.shade100,
                            valueColor: const AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ),
                        Column(
                          children: [
                            Text('$_currentIntake / $_goalIntake', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                            const Text('glasses', style: TextStyle(color: Colors.grey)),
                            Text('$percentage%', style: TextStyle(fontSize: 24, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.water_drop),
                          label: const Text('Add Glass'),
                          onPressed: () {
                            if (_currentIntake < _goalIntake) {
                              setState(() => _currentIntake++);
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          child: const Text('Reset'),
                          onPressed: () => setState(() => _currentIntake = 0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.blue),
                title: const Text('Reminder Frequency'),
                subtitle: const Text('Every 2 hours'),
                trailing: Switch(value: true, onChanged: (v) {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
