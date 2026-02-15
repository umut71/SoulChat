import 'package:flutter/material.dart';

class ScreenSharingScreen extends StatelessWidget {
  const ScreenSharingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Sharing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.screen_share, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Share Your Screen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Sharing'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
            ),
          ],
        ),
      ),
    );
  }
}
