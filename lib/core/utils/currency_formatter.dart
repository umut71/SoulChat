import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatSoulCoins(num amount) {
    final formatter = NumberFormat.decimalPattern();
    return '${formatter.format(amount)} SC';
  }

  static String formatCrypto(num amount, String symbol) {
    final formatter = NumberFormat('#,##0.00######');
    return '${formatter.format(amount)} $symbol';
  }

  static String formatFiat(num amount, String currencyCode) {
    final formatter = NumberFormat.currency(symbol: getCurrencySymbol(currencyCode));
    return formatter.format(amount);
  }

  static String getCurrencySymbol(String currencyCode) {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'TRY': '₺',
      'JPY': '¥',
    };
    return symbols[currencyCode] ?? currencyCode;
  }

  static String formatCompact(num amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toString();
  }
}
