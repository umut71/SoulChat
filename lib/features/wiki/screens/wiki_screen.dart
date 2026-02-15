import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WikiScreen extends StatelessWidget {
  const WikiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoulWiki'),
        actions: [
          IconButton(icon: const FaIcon(FontAwesomeIcons.magnifyingGlass), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                FaIcon(FontAwesomeIcons.book, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text('Knowledge Base', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Explore and Learn', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ...List.generate(15, (index) => ListTile(
            leading: CircleAvatar(child: FaIcon([FontAwesomeIcons.laptop, FontAwesomeIcons.atom, FontAwesomeIcons.flask, FontAwesomeIcons.globe, FontAwesomeIcons.book][index % 5])),
            title: Text('Article ${index + 1}'),
            subtitle: const Text('Category • 5 min read'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          )),
        ],
      ),
    );
  }
}
