import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/core/services/coingecko_service.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';
import 'package:soulchat/shared/widgets/app_lottie.dart';

const _demoHoldings = {
  'bitcoin': 0.001,
  'ethereum': 0.01,
  'solana': 1.0,
  'dogecoin': 100.0,
};

/// Portfolio: holdings + live prices
final portfolioDataProvider = FutureProvider<({Map<String, double> holdings, Map<String, double> prices})>((ref) async {
  final ids = CoinGeckoService.popularCoins.map((c) => c['id']!).toList();
  final prices = await CoinGeckoService.getPrices(ids);
  return (holdings: _demoHoldings, prices: prices);
});

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(soulCoinProvider);
    final portfolioAsync = ref.watch(portfolioDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cüzdan'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Son işlemler')),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegalNotice(context),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      FaIcon(FontAwesomeIcons.coins, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'SoulCoin (Oyun Puanı)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uygulama içi puan/kredi – gerçek kripto para değildir.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$balance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sanal para – gerçek kripto işlemi SoulChat üzerinden yapılmamaktadır.',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reklam izleniyor... +5 SoulCoin kazanıyorsunuz')),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        ref.read(soulCoinProvider.notifier).add(5);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('+5 SoulCoin eklendi')),
                        );
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.tv, size: 18),
                    label: const Text('Reklam izle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      ref.read(soulCoinProvider.notifier).add(100);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('+100 SoulCoin eklendi')),
                      );
                    },
                    icon: const FaIcon(FontAwesomeIcons.bagShopping, size: 18),
                    label: const Text('Satın al'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'SoulCoin sadece uygulama içi oyunlar ve AI sohbet için kullanılır.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Kripto takip (canlı fiyat – sadece bilgi amaçlı)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            portfolioAsync.when(
              data: (data) {
                if (data.holdings.isEmpty && data.prices.isEmpty) {
                  return const Card(child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('Fiyatlar yüklenemedi')),
                  ));
                }
                return _PortfolioList(holdings: data.holdings, prices: data.prices);
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, __) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text('Fiyatlar yüklenemedi', style: TextStyle(color: Colors.grey.shade600))),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Son işlemler',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _RecentTransactions(),
            const SizedBox(height: 24),
            _buildLegalNotice(context),
          ],
        ),
      ),
    );
  }

  static Widget _buildLegalNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700.withOpacity(0.5)),
      ),
      child: Text(
        'Buradaki veriler sadece bilgi amaçlıdır. SoulChat bir borsa değildir; gerçek kripto alım-satımı uygulama üzerinden yapılmamaktadır. SoulCoin uygulama içi sanal puandır.',
        style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PortfolioList extends StatelessWidget {
  final Map<String, double> holdings;
  final Map<String, double> prices;

  const _PortfolioList({required this.holdings, required this.prices});

  @override
  Widget build(BuildContext context) {
    double totalUsd = 0;
    final rows = <Widget>[];
    for (final c in CoinGeckoService.popularCoins) {
      final id = c['id']!;
      final amount = holdings[id] ?? 0;
      if (amount <= 0) continue;
      final price = prices[id] ?? 0;
      final value = amount * price;
      totalUsd += value;
      rows.add(Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber.shade700,
            child: Text((c['symbol'] ?? id).substring(0, 1), style: const TextStyle(color: Colors.white)),
          ),
          title: Text('${c['symbol']} – ${c['name']}'),
          subtitle: Text('$amount × \$${price.toStringAsFixed(2)}'),
          trailing: Text(
            '\$${value.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }
    if (rows.isEmpty) {
      return Card(
        child: EmptyStateLottie(
          message: 'Kripto takip (simülasyon) – fiyatlar yüklenince görünecek.',
          size: 160,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Toplam ≈ \$${totalUsd.toStringAsFixed(2)} USD (simülasyon)', style: Theme.of(context).textTheme.titleSmall),
        ),
        ...rows,
      ],
    );
  }
}

class _RecentTransactions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demo = [
      {'label': 'Quiz ödülü', 'amount': 25, 'positive': true},
      {'label': 'Çarkıfelek', 'amount': 100, 'positive': true},
      {'label': 'Yazı-Tura', 'amount': 10, 'positive': false},
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demo.length,
      itemBuilder: (context, index) {
        final d = demo[index];
        final pos = d['positive'] as bool;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: pos ? Colors.green : Colors.red,
              child: Icon(pos ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
            ),
            title: Text(d['label'] as String),
            subtitle: const Text('Simülasyon • Bugün'),
            trailing: Text(
              '${pos ? '+' : '-'}${d['amount']} SC',
              style: TextStyle(color: pos ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
