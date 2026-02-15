import 'package:flutter/material.dart';

class ResumeBuilderScreen extends StatelessWidget {
  const ResumeBuilderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resume Builder'), actions: [IconButton(icon: Icon(Icons.save), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
                    SizedBox(height: 16),
                    Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Software Engineer'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildSection('Contact', Icons.contact_phone, ['email@example.com', '+1 234 567 890', 'linkedin.com/in/johndoe']),
            _buildSection('Skills', Icons.star, ['Flutter', 'Dart', 'Firebase', 'UI/UX Design', 'Git']),
            _buildSection('Experience', Icons.work, ['Senior Developer - Tech Co (2020-2023)', 'Developer - Startup Inc (2018-2020)']),
            _buildSection('Education', Icons.school, ['BS Computer Science - University (2014-2018)']),
            SizedBox(height: 20),
            ElevatedButton.icon(icon: Icon(Icons.download), label: Text('Download PDF'), onPressed: () {}, style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50))),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<String> items) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon), SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
            SizedBox(height: 12),
            ...items.map((item) => Padding(padding: EdgeInsets.only(bottom: 8), child: Text('• $item'))),
          ],
        ),
      ),
    );
  }
}
