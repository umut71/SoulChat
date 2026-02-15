import 'package:flutter/material.dart';

class UnitConverterScreen extends StatelessWidget {
  const UnitConverterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Length', 'icon': Icons.straighten},
      {'name': 'Weight', 'icon': Icons.fitness_center},
      {'name': 'Volume', 'icon': Icons.local_drink},
      {'name': 'Temperature', 'icon': Icons.thermostat},
      {'name': 'Speed', 'icon': Icons.speed},
      {'name': 'Time', 'icon': Icons.access_time},
      {'name': 'Data', 'icon': Icons.data_usage},
      {'name': 'Energy', 'icon': Icons.bolt},
      {'name': 'Area', 'icon': Icons.crop_square},
      {'name': 'Currency', 'icon': Icons.attach_money},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Unit Converter')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.primaries[index % Colors.primaries.length], Colors.primaries[(index + 2) % Colors.primaries.length]],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categories[index]['icon'] as IconData, size: 50, color: Colors.white),
                    SizedBox(height: 12),
                    Text(categories[index]['name'] as String, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
