import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.image), text: 'Images'),
              Tab(icon: FaIcon(FontAwesomeIcons.video), text: 'Videos'),
              Tab(icon: FaIcon(FontAwesomeIcons.music), text: 'Music'),
              Tab(icon: FaIcon(FontAwesomeIcons.fileLines), text: 'Links'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGrid(),
            _buildGrid(),
            _buildList(),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 20,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.primaries[index % Colors.primaries.length], Colors.primaries[(index + 1) % Colors.primaries.length]]),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.bookmark)),
        title: Text('Bookmark ${index + 1}'),
        subtitle: const Text('Saved 2 days ago'),
        trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ),
    );
  }
}
