import 'package:flutter/material.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testimonials')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('Testimonials', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Coming soon with full functionality!'),
          ],
        ),
      ),
    );
  }
}
