import 'package:flutter/material.dart';

class ReferralSystemScreen extends StatelessWidget {
  const ReferralSystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invite & Earn')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.card_giftcard, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text('Invite Friends', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Earn 500 SC for each friend!', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(child: Text('SOUL2024XYZ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        IconButton(icon: Icon(Icons.copy), onPressed: () {}),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(icon: Icon(Icons.share), label: Text('Share'), onPressed: () {}),
                      ElevatedButton.icon(icon: Icon(Icons.qr_code), label: Text('QR Code'), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [Text('24', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)), Text('Invited')]),
                    Column(children: [Text('18', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)), Text('Joined')]),
                    Column(children: [Text('9,000', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)), Text('SC Earned')]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [Text('Recent Referrals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Friend ${index + 1}'),
                    subtitle: Text('${index + 1} days ago'),
                    trailing: Chip(label: Text('+500 SC'), backgroundColor: Colors.green.shade100),
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
