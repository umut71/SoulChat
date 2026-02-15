import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(icon: const FaIcon(FontAwesomeIcons.heart), onPressed: () {}),
          IconButton(icon: const FaIcon(FontAwesomeIcons.paperPlane), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(child: Text('U${index + 1}')),
                title: Text('User ${index + 1}'),
                subtitle: const Text('2h ago'),
                trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.primaries[index % Colors.primaries.length], Colors.primaries[(index + 1) % Colors.primaries.length]]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(icon: const FaIcon(FontAwesomeIcons.heart), onPressed: () {}),
                        IconButton(icon: const FaIcon(FontAwesomeIcons.comment), onPressed: () {}),
                        IconButton(icon: const FaIcon(FontAwesomeIcons.share), onPressed: () {}),
                        const Spacer(),
                        IconButton(icon: const FaIcon(FontAwesomeIcons.bookmark), onPressed: () {}),
                      ],
                    ),
                    Text('${(index + 1) * 125} likes', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('This is a sample post description...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
