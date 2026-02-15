import 'package:flutter/material.dart';

class ExpenseTrackerScreen extends StatelessWidget {
  const ExpenseTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Monthly Budget', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('\$2,450 / \$3,000', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  LinearProgressIndicator(value: 0.82, minHeight: 8),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Recent Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                TextButton(onPressed: () {}, child: Text('Add New')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15,
              itemBuilder: (context, index) {
                final categories = ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment'];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.attach_money)),
                    title: Text(categories[index % categories.length]),
                    subtitle: Text('${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
                    trailing: Text('\$${(index + 1) * 25}', style: TextStyle(fontWeight: FontWeight.bold)),
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
