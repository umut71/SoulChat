import 'package:flutter/material.dart';

class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 50,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.primaries[index % Colors.primaries.length].shade200,
            ),
            child: Center(
              child: Icon(
                Icons.photo,
                size: 50,
                color: Colors.primaries[index % Colors.primaries.length],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
