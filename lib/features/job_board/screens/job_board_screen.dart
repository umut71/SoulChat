import 'package:flutter/material.dart';

class JobBoardScreen extends StatelessWidget {
  const JobBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Board'), actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})]),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (context, index) {
          final companies = ['Google', 'Microsoft', 'Apple', 'Amazon', 'Meta', 'Netflix'];
          final positions = ['Software Engineer', 'Product Manager', 'UX Designer', 'Data Scientist', 'DevOps Engineer'];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(companies[index % companies.length][0])),
              title: Text(positions[index % positions.length]),
              subtitle: Text('${companies[index % companies.length]} - Remote'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${(index + 8) * 10}K-\$${(index + 15) * 10}K', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Full-time', style: TextStyle(fontSize: 12)),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
