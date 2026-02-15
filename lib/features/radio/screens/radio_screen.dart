import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio')),
      body: Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.radio, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text('Now Playing', style: TextStyle(color: Colors.white70)),
                const Text('Soul FM 104.5', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const FaIcon(FontAwesomeIcons.backward, color: Colors.white), onPressed: () {}),
                    IconButton(icon: const FaIcon(FontAwesomeIcons.pause, color: Colors.white, size: 40), onPressed: () {}),
                    IconButton(icon: const FaIcon(FontAwesomeIcons.forward, color: Colors.white), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(alignment: Alignment.centerLeft, child: Text('Stations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Station ${index + 1}'),
                subtitle: Text('${90 + index}.${(index * 3) % 10} FM'),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
