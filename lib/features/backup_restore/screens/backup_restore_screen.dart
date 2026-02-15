import 'package:flutter/material.dart';

class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.backup, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text('Last Backup', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('Today at 3:45 PM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.backup),
                      label: const Text('Backup Now'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Backup Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildBackupItem('Messages', Icons.message, true),
          _buildBackupItem('Photos', Icons.photo, true),
          _buildBackupItem('Videos', Icons.video_library, true),
          _buildBackupItem('Documents', Icons.description, true),
          _buildBackupItem('Contacts', Icons.contacts, true),
          _buildBackupItem('Settings', Icons.settings, false),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restore, color: Colors.orange),
              title: const Text('Restore from Backup'),
              subtitle: const Text('Recover your data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupItem(String title, IconData icon, bool enabled) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        value: enabled,
        onChanged: (value) {},
      ),
    );
  }
}
