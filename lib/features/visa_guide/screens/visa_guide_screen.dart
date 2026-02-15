import 'package:flutter/material.dart';

class VisaGuideScreen extends StatelessWidget {
  const VisaGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visa Guide')),
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
                      hintText: 'Search country...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Popular Destinations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 20,
              itemBuilder: (context, index) {
                final countries = ['United States', 'United Kingdom', 'Canada', 'Australia', 'Germany', 'France', 'Japan', 'UAE'];
                final visaTypes = ['Visa Required', 'Visa on Arrival', 'No Visa Required', 'e-Visa Available'];
                final colors = [Colors.red, Colors.orange, Colors.green, Colors.blue];
                final visaType = index % 4;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(countries[index % countries.length][0])),
                    title: Text(countries[index % countries.length]),
                    subtitle: Text(visaTypes[visaType]),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors[visaType].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(visaTypes[visaType], style: TextStyle(color: colors[visaType], fontSize: 12, fontWeight: FontWeight.bold)),
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
