import 'package:flutter/material.dart';

class FreelanceMarketplaceScreen extends StatelessWidget {
  const FreelanceMarketplaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Freelance Marketplace')),
      body: SafeArea(
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Web Dev', 'Mobile', 'Design', 'Writing', 'Marketing'].map((cat) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(cat), selected: cat == 'All', onSelected: (v) {}),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 15,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project Title ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Proje açıklaması ve gereksinimler. Teklif vermek için detaylara göz atın.'),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Chip(label: Text('Web Development')),
                            SizedBox(width: 8),
                            Chip(label: Text('Fixed Price')),
                            Spacer(),
                            Text('\$${(index + 5) * 100}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}
