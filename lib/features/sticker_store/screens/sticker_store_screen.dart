import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StickerStoreScreen extends StatelessWidget {
  const StickerStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sticker Store')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 30,
        itemBuilder: (context, index) => Card(
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  [FontAwesomeIcons.faceSmile, FontAwesomeIcons.faceLaugh, FontAwesomeIcons.faceGrin, FontAwesomeIcons.heart, FontAwesomeIcons.star, FontAwesomeIcons.fire][index % 6],
                  size: 48,
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
                const SizedBox(height: 8),
                Text('Pack ${index + 1}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
