import 'package:flutter/material.dart';

class TvStreamingScreen extends StatelessWidget {
  const TvStreamingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live TV - 50+ Channels')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          final channels = ['CNN', 'BBC', 'ESPN', 'HBO', 'MTV', 'Discovery'];
          return Card(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tv, size: 40, color: Colors.white),
                  SizedBox(height: 8),
                  Text(channels[index % channels.length], style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
