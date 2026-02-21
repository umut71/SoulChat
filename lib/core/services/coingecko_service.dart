import 'package:dio/dio.dart';

/// Canlı kripto fiyatları – CoinGecko ücretsiz (demo) API. API anahtarı gerekmez.
/// https://api.coingecko.com/api/v3/simple/price – rate limit: ~10-30/dk.
class CoinGeckoService {
  static String? _lastApiError;
  static String? get lastApiError => _lastApiError;

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.coingecko.com/api/v3',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Future<Map<String, double>> getPrices(List<String> ids) async {
    if (ids.isEmpty) return {};
    try {
      _lastApiError = null;
      final res = await _dio.get(
        '/simple/price',
        queryParameters: {'ids': ids.join(','), 'vs_currencies': 'usd'},
      );
      final data = res.data as Map<String, dynamic>? ?? {};
      final out = <String, double>{};
      for (final e in data.entries) {
        final v = e.value;
        if (v is Map && v['usd'] != null) {
          out[e.key] = (v['usd'] is num) ? (v['usd'] as num).toDouble() : double.tryParse(v['usd'].toString()) ?? 0;
        }
      }
      return out;
    } catch (e) {
      _lastApiError = _messageFor(e);
      return {};
    }
  }

  static String _messageFor(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('401') || s.contains('unauthorized')) return 'API anahtarı geçersiz. Ayarlar\'dan kontrol edin.';
    if (s.contains('429') || s.contains('rate')) return 'İstek limiti aşıldı. Biraz sonra tekrar deneyin.';
    if (s.contains('socket') || s.contains('connection') || s.contains('timeout')) return 'İnternet bağlantısı yok veya zaman aşımı.';
    return 'Veri alınamadı. Lütfen Ayarlar\'dan API anahtarını girin veya bağlantıyı kontrol edin.';
  }

  /// Canlı piyasa: BTC, ETH, SOL vb. Production: hata durumunda demo/cache gösterme, uyarı ver.
  static Future<List<Map<String, dynamic>>> getMarketData() async {
    final ids = popularCoins.map((c) => c['id']!).toList();
    if (ids.isEmpty) return [];
    try {
      _lastApiError = null;
      final res = await _dio.get(
        '/simple/price',
        queryParameters: {
          'ids': ids.join(','),
          'vs_currencies': 'usd',
          'include_24hr_change': 'true',
          'include_market_cap': 'true',
        },
      );
      final data = res.data as Map<String, dynamic>? ?? {};
      final list = <Map<String, dynamic>>[];
      for (final c in popularCoins) {
        final id = c['id']!;
        final raw = data[id];
        if (raw is! Map) continue;
        final price = (raw['usd'] is num) ? (raw['usd'] as num).toDouble() : 0.0;
        final change = (raw['usd_24h_change'] is num) ? (raw['usd_24h_change'] as num).toDouble() : 0.0;
        final cap = (raw['usd_market_cap'] is num) ? (raw['usd_market_cap'] as num).toDouble() : 0.0;
        list.add({
          'id': id,
          'symbol': c['symbol'],
          'name': c['name'],
          'price': price,
          'change24h': change,
          'market_cap': cap,
        });
      }
      return list;
    } catch (e) {
      _lastApiError = _messageFor(e);
      return [];
    }
  }

  static bool get lastMarketDataFromCache => false;
  static bool get hasApiError => _lastApiError != null;

  static const List<Map<String, String>> popularCoins = [
    {'id': 'bitcoin', 'symbol': 'BTC', 'name': 'Bitcoin'},
    {'id': 'ethereum', 'symbol': 'ETH', 'name': 'Ethereum'},
    {'id': 'tether', 'symbol': 'USDT', 'name': 'Tether'},
    {'id': 'binancecoin', 'symbol': 'BNB', 'name': 'BNB'},
    {'id': 'solana', 'symbol': 'SOL', 'name': 'Solana'},
    {'id': 'cardano', 'symbol': 'ADA', 'name': 'Cardano'},
    {'id': 'ripple', 'symbol': 'XRP', 'name': 'XRP'},
    {'id': 'dogecoin', 'symbol': 'DOGE', 'name': 'Dogecoin'},
  ];
}
