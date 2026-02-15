import 'package:flutter/material.dart';

class CarRentalScreen extends StatelessWidget {
  const CarRentalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car Rental')),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pick-up', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('New York, NY'),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Drop-off', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Los Angeles, CA'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text('Jan 15, 2024 - Jan 20, 2024')),
                      ElevatedButton(onPressed: () {}, child: Text('Search')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Available Cars', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15,
              itemBuilder: (context, index) {
                final cars = ['Toyota Camry', 'Honda Accord', 'BMW 3 Series', 'Mercedes C-Class', 'Tesla Model 3'];
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.directions_car, size: 40),
                    ),
                    title: Text(cars[index % cars.length]),
                    subtitle: Text('Automatic • 5 Seats'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${(index + 4) * 10}/day', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('or similar', style: TextStyle(fontSize: 10)),
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
