import 'package:flutter/material.dart';

class ContestsScreen extends StatelessWidget {
  const ContestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yarışmalar')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(16),
            child: Row(
              children: ['All', 'Active', 'Upcoming', 'Ended'].map((cat) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(cat), selected: cat == 'All', onSelected: (v) {}),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Yarışma ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                              child: Text('Active', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Prize Pool: \$${(index + 1) * 1000}'),
                        Text('Participants: ${(index + 1) * 250}'),
                        Text('Ends in: ${24 - index} hours'),
                        SizedBox(height: 12),
                        ElevatedButton(child: Text('Join Now'), onPressed: () {}, style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40))),
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
