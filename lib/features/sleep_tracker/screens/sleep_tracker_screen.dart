import 'package:flutter/material.dart';

class SleepTrackerScreen extends StatelessWidget {
  const SleepTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Last Night Sleep', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    const Text('7h 32m', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Bedtime', '10:45 PM', Icons.bedtime),
                        _buildStat('Wake up', '6:17 AM', Icons.wb_sunny),
                        _buildStat('Quality', '85%', Icons.star),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weekly Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (i) {
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final hours = [7.5, 6.2, 8.1, 7.8, 6.5, 9.2, 7.3];
                        return Column(
                          children: [
                            Container(
                              width: 30,
                              height: hours[i] * 20,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(days[i]),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bedtime),
                label: const Text('Start Sleep Session'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: () {},
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
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
