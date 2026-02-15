import 'package:flutter/material.dart';

class CasinoScreen extends StatelessWidget {
  const CasinoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Casino'), backgroundColor: Colors.red.shade900),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red.shade900, Colors.red.shade700])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [Icon(Icons.account_balance_wallet, color: Colors.white), Text('Chips', style: TextStyle(color: Colors.white)), Text('15,000', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
                Column(children: [Icon(Icons.emoji_events, color: Colors.yellow), Text('Level', style: TextStyle(color: Colors.white)), Text('VIP 3', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(16), child: Text('Popular Games', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildGameCard('Slots', Icons.casino, Colors.red),
                _buildGameCard('Poker', Icons.style, Colors.green),
                _buildGameCard('Blackjack', Icons.filter_none, Colors.black),
                _buildGameCard('Roulette', Icons.album, Colors.red),
                _buildGameCard('Baccarat', Icons.credit_card, Colors.blue),
                _buildGameCard('Dice', Icons.casino, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(String name, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 8),
            Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
