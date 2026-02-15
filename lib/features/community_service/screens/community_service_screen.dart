import 'package:flutter/material.dart';

class Community_serviceScreen extends StatelessWidget {
  const Community_serviceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community_service')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('Community_service', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Coming soon with full functionality!'),
          ],
        ),
      ),
    );
  }
}
