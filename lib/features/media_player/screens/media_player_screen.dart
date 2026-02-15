import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MediaPlayerScreen extends StatelessWidget {
  const MediaPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Player')),
      body: Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: FaIcon(FontAwesomeIcons.music, size: 100, color: Colors.white)),
          ),
          const Text('Song Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Artist Name', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 30),
          Slider(value: 0.3, onChanged: (val) {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('1:30'),
                Text('4:20'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: const FaIcon(FontAwesomeIcons.shuffle), onPressed: () {}),
              IconButton(icon: const FaIcon(FontAwesomeIcons.backwardStep, size: 32), onPressed: () {}),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                child: IconButton(icon: const FaIcon(FontAwesomeIcons.pause, size: 32, color: Colors.white), onPressed: () {}),
              ),
              IconButton(icon: const FaIcon(FontAwesomeIcons.forwardStep, size: 32), onPressed: () {}),
              IconButton(icon: const FaIcon(FontAwesomeIcons.repeat), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => ListTile(
                  leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.music)),
                  title: Text('Track ${index + 1}'),
                  subtitle: const Text('Artist'),
                  trailing: const Text('3:45'),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
