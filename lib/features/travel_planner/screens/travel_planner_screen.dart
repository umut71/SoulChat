import 'package:flutter/material.dart';

class TravelPlannerScreen extends StatelessWidget {
  const TravelPlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Travel Planner'), actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.explore, size: 50, color: Colors.blue),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('5 upcoming trips'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Upcoming Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                final destinations = ['Paris, France', 'Tokyo, Japan', 'New York, USA', 'Dubai, UAE', 'Barcelona, Spain'];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.flight)),
                    title: Text(destinations[index]),
                    subtitle: Text('${index + 1}-${index + 7} Feb 2024 • ${(index + 3)} days'),
                    trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () {}),
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
