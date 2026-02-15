import 'package:flutter/material.dart';

class PasswordManagerScreen extends StatelessWidget {
  const PasswordManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwords = [
      {'site': 'Google', 'username': 'user@gmail.com', 'icon': Icons.email},
      {'site': 'Facebook', 'username': 'username', 'icon': Icons.facebook},
      {'site': 'Twitter', 'username': '@handle', 'icon': Icons.comment},
      {'site': 'Bank', 'username': 'account123', 'icon': Icons.account_balance},
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: passwords.length,
        itemBuilder: (context, index) {
          final pwd = passwords[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Icon(pwd['icon'] as IconData)),
              title: Text(pwd['site'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pwd['username'] as String),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.visibility), onPressed: () {}),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
