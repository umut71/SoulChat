import 'package:flutter/material.dart';

class LotteryScreen extends StatelessWidget {
  const LotteryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lottery')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.yellow, Colors.orange]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text('Next Draw', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('Jackpot', style: TextStyle(fontSize: 16)),
                  Text('\$1,000,000', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 16),
                  Text('Draw in: 2 days 14:23:45', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 24),
                  ElevatedButton(child: Text('Buy Ticket - 10 SC'), onPressed: () {}, style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16))),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(16), child: Text('Your Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.confirmation_number)),
                    title: Text('Ticket #${1000 + index}'),
                    subtitle: Text('Numbers: 12, 24, 36, 48, 60, 72'),
                    trailing: Chip(label: Text('Active')),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
