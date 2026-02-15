import 'package:flutter/material.dart';

class CloudStorageScreen extends StatelessWidget {
  const CloudStorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Storage'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.purple.shade600],
              ),
            ),
            child: Column(
              children: [
                const Text('Storage Used', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 12),
                const Text('245 GB / 500 GB', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.49,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 8),
                const Text('49% Used', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFileCard('Documents', Icons.description, '45 GB', Colors.blue),
                _buildFileCard('Photos', Icons.photo, '120 GB', Colors.green),
                _buildFileCard('Videos', Icons.video_library, '65 GB', Colors.red),
                _buildFileCard('Music', Icons.music_note, '12 GB', Colors.orange),
                _buildFileCard('Others', Icons.folder, '3 GB', Colors.grey),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }

  Widget _buildFileCard(String title, IconData icon, String size, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(size),
        trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () {}),
      ),
    );
  }
}
