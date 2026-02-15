import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CryptoTradingScreen extends StatefulWidget {
  const CryptoTradingScreen({Key? key}) : super(key: key);

  @override
  State<CryptoTradingScreen> createState() => _CryptoTradingScreenState();
}

class _CryptoTradingScreenState extends State<CryptoTradingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> cryptos = [
    {'name': 'Bitcoin', 'symbol': 'BTC', 'price': 45230.50, 'change': 2.5, 'icon': '₿'},
    {'name': 'Ethereum', 'symbol': 'ETH', 'price': 3120.75, 'change': 5.2, 'icon': 'Ξ'},
    {'name': 'SoulCoin', 'symbol': 'SC', 'price': 0.85, 'change': 15.8, 'icon': '🪙'},
    {'name': 'Cardano', 'symbol': 'ADA', 'price': 1.25, 'change': -1.2, 'icon': '₳'},
    {'name': 'Solana', 'symbol': 'SOL', 'price': 98.50, 'change': 8.3, 'icon': '◎'},
    {'name': 'Polkadot', 'symbol': 'DOT', 'price': 28.75, 'change': -2.1, 'icon': '●'},
    {'name': 'Dogecoin', 'symbol': 'DOGE', 'price': 0.15, 'change': 12.5, 'icon': 'Ð'},
    {'name': 'Ripple', 'symbol': 'XRP', 'price': 0.75, 'change': 3.8, 'icon': '✕'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Trading'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Market'),
            Tab(text: 'Portfolio'),
            Tab(text: 'Orders'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMarketTab(),
          _buildPortfolioTab(),
          _buildOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildMarketTab() {
    return Column(
      children: [
        _buildMarketStats(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cryptos.length,
            itemBuilder: (context, index) {
              final crypto = cryptos[index];
              return FadeInLeft(
                delay: Duration(milliseconds: index * 100),
                child: _buildCryptoCard(crypto),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMarketStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.blue.shade700],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Market Cap', '\$2.1T', Icons.show_chart),
          _buildStatItem('24h Volume', '\$120B', Icons.trending_up),
          _buildStatItem('BTC Dominance', '42.5%', FontAwesomeIcons.bitcoin),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoCard(Map<String, dynamic> crypto) {
    final isPositive = crypto['change'] > 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          radius: 25,
          child: Text(
            crypto['icon'],
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          crypto['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(crypto['symbol']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${crypto['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${crypto['change'].abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showTradeDialog(crypto),
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeIn(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Total Portfolio Value',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$125,430.50',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '+\$12,340 (10.9%) Today',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final holdings = [
              {'crypto': 'BTC', 'amount': 2.5, 'value': 113076.25},
              {'crypto': 'ETH', 'amount': 15.0, 'value': 46811.25},
              {'crypto': 'SC', 'amount': 50000, 'value': 42500.0},
              {'crypto': 'SOL', 'amount': 25.5, 'value': 2511.75},
              {'crypto': 'ADA', 'amount': 1000, 'value': 1250.0},
            ];
            final holding = holdings[index];
            
            return FadeInUp(
              delay: Duration(milliseconds: index * 100),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(holding['crypto'] as String),
                  ),
                  title: Text(
                    '${holding['amount']} ${holding['crypto']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('\$${holding['value']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final orders = [
          {'type': 'Buy', 'crypto': 'BTC', 'amount': 0.5, 'price': 45200, 'status': 'Completed'},
          {'type': 'Sell', 'crypto': 'ETH', 'amount': 2.0, 'price': 3115, 'status': 'Pending'},
          {'type': 'Buy', 'crypto': 'SC', 'amount': 1000, 'price': 0.85, 'status': 'Completed'},
          {'type': 'Buy', 'crypto': 'SOL', 'amount': 5.0, 'price': 98, 'status': 'Completed'},
          {'type': 'Sell', 'crypto': 'ADA', 'amount': 500, 'price': 1.26, 'status': 'Cancelled'},
          {'type': 'Buy', 'crypto': 'DOT', 'amount': 10.0, 'price': 28.5, 'status': 'Completed'},
          {'type': 'Buy', 'crypto': 'DOGE', 'amount': 5000, 'price': 0.15, 'status': 'Pending'},
          {'type': 'Sell', 'crypto': 'XRP', 'amount': 1000, 'price': 0.76, 'status': 'Completed'},
          {'type': 'Buy', 'crypto': 'BTC', 'amount': 0.1, 'price': 45150, 'status': 'Completed'},
          {'type': 'Buy', 'crypto': 'ETH', 'amount': 1.0, 'price': 3120, 'status': 'Pending'},
        ];
        
        if (index >= orders.length) return const SizedBox.shrink();
        
        final order = orders[index];
        final isBuy = order['type'] == 'Buy';
        
        return FadeInRight(
          delay: Duration(milliseconds: index * 100),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isBuy ? Colors.green.shade100 : Colors.red.shade100,
                child: Icon(
                  isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isBuy ? Colors.green : Colors.red,
                ),
              ),
              title: Text(
                '${order['type']} ${order['amount']} ${order['crypto']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('@\$${order['price']}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: order['status'] == 'Completed'
                      ? Colors.green.shade100
                      : order['status'] == 'Pending'
                          ? Colors.orange.shade100
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['status'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: order['status'] == 'Completed'
                        ? Colors.green
                        : order['status'] == 'Pending'
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTradeDialog(Map<String, dynamic> crypto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Trade ${crypto['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Price: \$${crypto['price']}'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Buy order placed for ${crypto['symbol']}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('BUY'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sell order placed for ${crypto['symbol']}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    child: const Text('SELL'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
