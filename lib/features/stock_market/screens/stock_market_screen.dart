import 'package:flutter/material.dart';

class StockMarketScreen extends StatelessWidget {
  const StockMarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Market'), actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})]),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Portfolio Value', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('\$45,230.50', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('+2.5% today', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Watchlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15,
              itemBuilder: (context, index) {
                final stocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA', 'META', 'NFLX'];
                final prices = [175.50, 142.30, 380.20, 145.80, 245.60, 320.15, 450.30];
                final changes = ['+2.5%', '+1.8%', '-0.5%', '+3.2%', '-1.2%', '+4.5%', '+2.1%'];
                final isPositive = index % 3 != 2;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(stocks[index % stocks.length].substring(0, 1))),
                    title: Text(stocks[index % stocks.length]),
                    subtitle: Text('\$${prices[index % prices.length]}'),
                    trailing: Chip(
                      label: Text(changes[index % changes.length]),
                      backgroundColor: isPositive ? Colors.green.shade100 : Colors.red.shade100,
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
