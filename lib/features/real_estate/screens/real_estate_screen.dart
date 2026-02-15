import 'package:flutter/material.dart';

class RealEstateScreen extends StatelessWidget {
  const RealEstateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real Estate'), actions: [IconButton(icon: Icon(Icons.filter_list), onPressed: () {})]),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(16),
            child: Row(
              children: ['All', 'For Sale', 'For Rent', 'Houses', 'Apartments', 'Land'].map((cat) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(cat), selected: cat == 'All', onSelected: (v) {}),
              )).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        color: Colors.grey.shade300,
                        child: Center(child: Icon(Icons.home, size: 50)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${(index + 2) * 50}K', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            Text('${(index + 2)} Bedroom House', style: TextStyle(fontSize: 12)),
                            Text('Location ${index + 1}', style: TextStyle(fontSize: 10, color: Colors.grey)),
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
