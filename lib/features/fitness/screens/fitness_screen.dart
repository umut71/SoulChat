import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tracker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatsCard(context),
          const SizedBox(height: 16),
          _buildActivityRings(),
          const SizedBox(height: 16),
          _buildWorkoutList(),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat('8,432', 'Steps', FontAwesomeIcons.shoePrints, Colors.blue),
            _buildStat('3.2', 'km', FontAwesomeIcons.route, Colors.green),
            _buildStat('245', 'kcal', FontAwesomeIcons.fire, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        FaIcon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildActivityRings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Today\'s Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(height: 180, width: 180, child: CircularProgressIndicator(value: 0.75, strokeWidth: 15, backgroundColor: Colors.red.shade100, color: Colors.red)),
                  SizedBox(height: 140, width: 140, child: CircularProgressIndicator(value: 0.6, strokeWidth: 15, backgroundColor: Colors.green.shade100, color: Colors.green)),
                  SizedBox(height: 100, width: 100, child: CircularProgressIndicator(value: 0.4, strokeWidth: 15, backgroundColor: Colors.blue.shade100, color: Colors.blue)),
                  const Text('75%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList() {
    return Card(
      child: Column(
        children: List.generate(5, (index) => ListTile(
          leading: CircleAvatar(child: FaIcon([FontAwesomeIcons.personRunning, FontAwesomeIcons.bicycle, FontAwesomeIcons.dumbbell, FontAwesomeIcons.personSwimming, FontAwesomeIcons.personWalking][index])),
          title: Text(['Running', 'Cycling', 'Strength', 'Swimming', 'Walking'][index]),
          subtitle: Text('${30 + index * 10} min'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        )),
      ),
    );
  }
}
