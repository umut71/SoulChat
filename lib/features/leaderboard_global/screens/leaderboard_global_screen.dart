import 'package:flutter/material.dart';

class LeaderboardGlobalScreen extends StatelessWidget {
  const LeaderboardGlobalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Global Leaderboard')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber, Colors.orange])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTopPlayer(2, 'Player 2', '9,850'),
                _buildTopPlayer(1, 'Player 1', '10,450', isFirst: true),
                _buildTopPlayer(3, 'Player 3', '9,200'),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(16), child: Row(children: [Text('Your Rank: #142', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))])),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 50,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('#${index + 4}')),
                    title: Text('Player ${index + 4}'),
                    subtitle: Text('Level ${20 + index}'),
                    trailing: Text('${9000 - index * 50} pts', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPlayer(int rank, String name, String points, {bool isFirst = false}) {
    return Column(
      children: [
        Container(
          width: isFirst ? 80 : 60,
          height: isFirst ? 80 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: rank == 1 ? Colors.amber : rank == 2 ? Colors.grey.shade400 : Colors.orange.shade300,
          ),
          child: Center(child: Icon(Icons.emoji_events, size: isFirst ? 40 : 30, color: Colors.white)),
        ),
        SizedBox(height: 8),
        Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        Text('$points pts', style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}
