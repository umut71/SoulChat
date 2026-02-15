import 'package:flutter/material.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _urlController = TextEditingController(text: 'https://soulchat.app');
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _urlController,
          decoration: InputDecoration(
            hintText: 'Search or enter URL',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWebPage('SoulChat'),
          _buildWebPage('Google'),
          _buildWebPage('YouTube'),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () {}),
            IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.tab), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildWebPage(String title) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Web content would appear here'),
          ],
        ),
      ),
    );
  }
}
