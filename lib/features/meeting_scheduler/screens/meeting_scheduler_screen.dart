import 'package:flutter/material.dart';

class MeetingSchedulerScreen extends StatelessWidget {
  const MeetingSchedulerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Scheduler'),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.today, size: 40, color: Colors.blue),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('3 meetings scheduled'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text("Today's Meetings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                final times = ['09:00 AM', '02:00 PM', '04:30 PM'];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.video_call)),
                    title: Text('Team Meeting ${index + 1}'),
                    subtitle: Text(times[index] + ' - 1 hour'),
                    trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
