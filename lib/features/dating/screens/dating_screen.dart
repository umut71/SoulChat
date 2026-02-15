import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DatingScreen extends StatelessWidget {
  const DatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoulMatch'),
        actions: [
          IconButton(icon: const FaIcon(FontAwesomeIcons.sliders), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 600,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.pink, Colors.orange]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.black.withOpacity(0.7), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex, 25', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.locationDot, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text('5 km away', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(heroTag: 'pass', onPressed: () {}, backgroundColor: Colors.red, child: const FaIcon(FontAwesomeIcons.xmark)),
                FloatingActionButton(heroTag: 'super', onPressed: () {}, backgroundColor: Colors.blue, child: const FaIcon(FontAwesomeIcons.star)),
                FloatingActionButton(heroTag: 'like', onPressed: () {}, backgroundColor: Colors.green, child: const FaIcon(FontAwesomeIcons.heart)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
