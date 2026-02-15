import 'package:flutter/material.dart';

class Scratch_cardsScreen extends StatelessWidget {
  const Scratch_cardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scratch_cards')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('Scratch_cards', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Coming soon with full functionality!'),
          ],
        ),
      ),
    );
  }
}
