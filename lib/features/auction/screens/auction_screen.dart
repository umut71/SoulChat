import 'package:flutter/material.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auctions'), actions: [IconButton(icon: Icon(Icons.gavel), onPressed: () {})]),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(16),
            child: Row(
              children: ['All', 'Live', 'Ending Soon', 'New', 'Hot'].map((cat) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(cat), selected: cat == 'All', onSelected: (v) {}),
              )).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Container(color: Colors.grey.shade300, child: Center(child: Icon(Icons.image, size: 50)))),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Item ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Current: \$${(index + 1) * 50}', style: TextStyle(color: Colors.green)),
                            Text('Ends in: ${24 - index}h', style: TextStyle(fontSize: 12, color: Colors.red)),
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
