import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ARFiltersScreen extends StatelessWidget {
  const ARFiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(color: Colors.grey.shade800),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('AR Filters', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (context, index) => Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.primaries[index % Colors.primaries.length], Colors.primaries[(index + 1) % Colors.primaries.length]]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon([FontAwesomeIcons.faceSmile, FontAwesomeIcons.faceLaugh, FontAwesomeIcons.cat, FontAwesomeIcons.dog, FontAwesomeIcons.crow][index % 5], color: Colors.white, size: 32),
                            const SizedBox(height: 8),
                            Text('Filter ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: const FaIcon(FontAwesomeIcons.image, color: Colors.white), onPressed: () {}),
                      Container(
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: IconButton(icon: const FaIcon(FontAwesomeIcons.circle, color: Colors.white, size: 40), onPressed: () {}),
                      ),
                      IconButton(icon: const FaIcon(FontAwesomeIcons.arrowsRotate, color: Colors.white), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
