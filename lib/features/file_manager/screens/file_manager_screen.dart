import 'package:flutter/material.dart';

class FileManagerScreen extends StatelessWidget {
  const FileManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final folders = ['Documents', 'Downloads', 'Images', 'Videos', 'Music', 'Archives'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [Icon(Icons.folder), Text('125 GB'), Text('Used')]),
                Column(children: [Icon(Icons.sd_storage), Text('512 GB'), Text('Total')]),
                Column(children: [Icon(Icons.cloud), Text('387 GB'), Text('Free')]),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.folder, size: 64, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(folders[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
