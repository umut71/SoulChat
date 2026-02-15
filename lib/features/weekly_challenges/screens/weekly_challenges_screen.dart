import 'package:flutter/material.dart';

class Weekly_challengesScreen extends StatelessWidget {
  const Weekly_challengesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weekly_challenges')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('Weekly_challenges', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Coming soon with full functionality!'),
          ],
        ),
      ),
    );
  }
}
