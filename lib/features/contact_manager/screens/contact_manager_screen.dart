import 'package:flutter/material.dart';

class ContactManagerScreen extends StatelessWidget {
  const ContactManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contacts = List.generate(30, (i) => {
      'name': 'Contact ${i+1}',
      'phone': '+1 (555) ${100 + i}-${1000 + i}',
      'email': 'contact${i+1}@example.com',
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(contact['name']!.substring(0, 1)),
            ),
            title: Text(contact['name']!),
            subtitle: Text(contact['phone']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: () {}),
                IconButton(icon: const Icon(Icons.message, color: Colors.blue), onPressed: () {}),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
