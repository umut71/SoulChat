import 'package:flutter/material.dart';

class BettingScreen extends StatelessWidget {
  const BettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sports Betting')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [Text('Balance', style: TextStyle(color: Colors.grey)), Text('\$1,250', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]),
                  Column(children: [Text('Active Bets', style: TextStyle(color: Colors.grey)), Text('5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(16), child: Text('Live Matches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Team A vs Team B', style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                              child: Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(child: Text('Team A\n2.5'), onPressed: () {}),
                            ElevatedButton(child: Text('Draw\n3.2'), onPressed: () {}),
                            ElevatedButton(child: Text('Team B\n2.8'), onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
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
