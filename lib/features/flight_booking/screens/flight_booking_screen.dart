import 'package:flutter/material.dart';

class FlightBookingScreen extends StatelessWidget {
  const FlightBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flight Booking')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: TextField(decoration: InputDecoration(hintText: 'From', prefixIcon: Icon(Icons.flight_takeoff)))),
                      SizedBox(width: 8),
                      Icon(Icons.swap_horiz),
                      SizedBox(width: 8),
                      Expanded(child: TextField(decoration: InputDecoration(hintText: 'To', prefixIcon: Icon(Icons.flight_land)))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Text('Jan 15, 2024')),
                      Expanded(child: Text('1 Passenger')),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: Text('Search Flights'), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45))),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Available Flights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15,
              itemBuilder: (context, index) {
                final airlines = ['American', 'United', 'Delta', 'Southwest', 'JetBlue'];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: Icon(Icons.flight, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(airlines[index % airlines.length], style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('10:${(index * 5) % 60} AM - 2:${(index * 7) % 60} PM'),
                              Text('${(index % 3) + 1} stop(s)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text('\$${(index + 2) * 75}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
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
