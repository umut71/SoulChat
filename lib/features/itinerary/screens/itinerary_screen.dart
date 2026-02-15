import 'package:flutter/material.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Itinerary - Paris Trip')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_city, size: 80, color: Colors.white),
                    SizedBox(height: 12),
                    Text('Paris, France', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('Jan 15 - Jan 20, 2024', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text('Day ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(title: Text('9:00 AM - Visit Eiffel Tower'), leading: Icon(Icons.location_on)),
                      ListTile(title: Text('12:00 PM - Lunch at Café'), leading: Icon(Icons.restaurant)),
                      ListTile(title: Text('3:00 PM - Louvre Museum'), leading: Icon(Icons.museum)),
                      ListTile(title: Text('7:00 PM - Dinner'), leading: Icon(Icons.dinner_dining)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
