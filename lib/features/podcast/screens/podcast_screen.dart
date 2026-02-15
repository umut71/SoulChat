import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcasts'),
        actions: [
          IconButton(icon: const FaIcon(FontAwesomeIcons.magnifyingGlass), onPressed: () {}),
          IconButton(icon: const FaIcon(FontAwesomeIcons.bookmark), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNowPlaying(context),
          const SizedBox(height: 24),
          _buildSection(context, 'Trending', 10),
          const SizedBox(height: 24),
          _buildSection(context, 'Your Subscriptions', 8),
        ],
      ),
    );
  }

  Widget _buildNowPlaying(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, child: FaIcon(FontAwesomeIcons.podcast, size: 40)),
          const SizedBox(height: 16),
          const Text('Now Playing', style: TextStyle(color: Colors.white)),
          const Text('Tech Talk #42', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: const FaIcon(FontAwesomeIcons.backward, color: Colors.white), onPressed: () {}),
              IconButton(icon: const FaIcon(FontAwesomeIcons.pause, color: Colors.white, size: 40), onPressed: () {}),
              IconButton(icon: const FaIcon(FontAwesomeIcons.forward, color: Colors.white), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            itemBuilder: (context, index) => Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.primaries[index % Colors.primaries.length], Colors.primaries[(index + 1) % Colors.primaries.length]]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Podcast ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
