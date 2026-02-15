import 'package:flutter/material.dart';

class InvoiceManagerScreen extends StatelessWidget {
  const InvoiceManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Manager'),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.receipt)),
              title: Text('Invoice #${1000 + index}'),
              subtitle: Text('Client Name - \$${(index + 1) * 500}'),
              trailing: Chip(label: Text(index % 3 == 0 ? 'Paid' : 'Pending')),
            ),
          );
        },
      ),
    );
  }
}
