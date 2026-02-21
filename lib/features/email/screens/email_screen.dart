import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emails = List.generate(20, (i) => {
      'from': 'user${i+1}@example.com',
      'subject': 'Email Subject ${i+1}',
      'preview': 'This is a preview of email message ${i+1}...',
      'time': '${i+1}h ago',
      'unread': i < 3,
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          final email = emails[index];
          final from = email['from'] as String;
          final subject = email['subject'] as String;
          final preview = email['preview'] as String;
          final time = email['time'] as String;
          final unread = email['unread'] as bool;
          return ListTile(
            leading: CircleAvatar(
              child: Text(from.substring(0, 1).toUpperCase()),
            ),
            title: Text(
              subject,
              style: TextStyle(
                fontWeight: unread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(time),
            tileColor: unread ? Colors.blue.shade50 : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
