import 'package:flutter/material.dart';

class HotelBookingScreen extends StatelessWidget {
  const HotelBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Booking')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Where are you going?',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text('Jan 15 - Jan 20')),
                      Text('2 Adults • 1 Room'),
                    ],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(onPressed: () {}, child: Text('Search Hotels'), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45))),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Popular Hotels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        color: Colors.grey.shade300,
                        child: Center(child: Icon(Icons.hotel, size: 60)),
                      ),
                      ListTile(
                        title: Text('Grand Hotel ${index + 1}'),
                        subtitle: Text('Downtown • ${(index % 5) + 1} km from center'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(children: [Icon(Icons.star, size: 16, color: Colors.orange), Text('${4.0 + (index % 10) / 10}')]),
                            Text('\$${(index + 8) * 15}/night', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
