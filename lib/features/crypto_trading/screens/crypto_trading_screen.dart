import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulchat/core/services/coingecko_service.dart';
import 'package:soulchat/core/services/system_architect_service.dart';

/// Canlı Piyasa Takip Paneli – sadece veri, işlem yok. SoulChat borsa değildir.
final marketDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return CoinGeckoService.getMarketData();
});

class CryptoTradingScreen extends ConsumerWidget {
  const CryptoTradingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(marketDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kripto Radar – Canlı Piyasa Takibi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: async.when(
              data: (list) {
                if (list.isEmpty) {
                  return _buildCryptoEmptyOrError(
                    context,
                    ref,
                    CoinGeckoService.lastApiError ?? 'API verisi yok.',
                    isError: false,
                  );
                }
                final totalCap = list.fold<double>(0, (s, c) => s + ((c['market_cap'] as num?)?.toDouble() ?? 0));
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(marketDataProvider),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildStatsHeader(context, list, totalCap),
                      const SizedBox(height: 16),
                      ...list.map((c) => _buildCoinRow(context, c)),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, __) => _buildCryptoEmptyOrError(
                context,
                ref,
                CoinGeckoService.lastApiError ?? e.toString(),
                isError: true,
              ),
            ),
          ),
          _buildLegalNotice(),
        ],
      ),
    );
  }

  static Widget _buildCryptoEmptyOrError(
    BuildContext context,
    WidgetRef ref,
    String rawMessage, {
    required bool isError,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.cloud_off : Icons.warning_amber_rounded,
              size: 56,
              color: isError ? Colors.grey : Colors.orange.shade700,
            ),
            const SizedBox(height: 16),
            Text(rawMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 24),
            const Text('DeepAgent piyasa analizi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: SystemArchitectService.deepAgentAnalyze(
                'Güncel kripto piyasa analizi yap. BTC, ETH ve genel piyasa hakkında 2-3 cümle Türkçe özet ver.',
              ),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                final text = snap.data ?? 'Analiz şu an alınamadı.';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.purple.shade900)),
                  ),
                );
              },
            ),
            TextButton.icon(
              onPressed: () => ref.invalidate(marketDataProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Yenile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, List<Map<String, dynamic>> list, double totalCap) {
    final btc = list.cast<Map<String, dynamic>?>().firstWhere((e) => e?['id'] == 'bitcoin', orElse: () => null);
    final btcCap = (btc != null && btc['market_cap'] != null) ? (btc['market_cap'] as num).toDouble() : 0.0;
    final btcDominance = totalCap > 0 ? (btcCap / totalCap * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Piyasa Değeri', _formatCap(totalCap), Icons.show_chart),
          _statItem('24s Hacim', '—', Icons.trending_up),
          _statItem('BTC Dominans', '${btcDominance.toStringAsFixed(1)}%', Icons.percent),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
        ),
      ],
    );
  }

  String _formatCap(double n) {
    if (n >= 1e12) return '\$${(n / 1e12).toStringAsFixed(2)}T';
    if (n >= 1e9) return '\$${(n / 1e9).toStringAsFixed(2)}B';
    if (n >= 1e6) return '\$${(n / 1e6).toStringAsFixed(2)}M';
    return '\$${n.toStringAsFixed(0)}';
  }

  Widget _buildCoinRow(BuildContext context, Map<String, dynamic> c) {
    final price = (c['price'] as num?)?.toDouble() ?? 0.0;
    final change = (c['change24h'] as num?)?.toDouble() ?? 0.0;
    final cap = (c['market_cap'] as num?)?.toDouble() ?? 0.0;
    final isPositive = change >= 0;
    final symbol = c['symbol'] as String? ?? '—';
    final name = c['name'] as String? ?? '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: Text(symbol.substring(0, symbol.length >= 2 ? 2 : 1), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('MCap: ${_formatCap(cap)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${price >= 1 ? price.toStringAsFixed(2) : price.toStringAsFixed(6)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}% 24s',
                style: TextStyle(
                  color: isPositive ? Colors.green.shade800 : Colors.red.shade800,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border(top: BorderSide(color: Colors.amber.shade200)),
      ),
      child: Text(
        'Bu veriler bilgilendirme amaçlıdır, yatırım tavsiyesi değildir. SoulChat bir borsa değildir; işlem yapılamaz.',
        style: TextStyle(fontSize: 11, color: Colors.amber.shade900),
        textAlign: TextAlign.center,
      ),
    );
  }
}
