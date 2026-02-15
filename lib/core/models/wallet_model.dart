class Transaction {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String status;
  final String? description;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.status,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'description': description,
    };
  }
}

class WalletModel {
  final String userId;
  final double soulCoins;
  final double cryptoBalance;
  final String? walletAddress;
  final List<Transaction> transactions;

  WalletModel({
    required this.userId,
    this.soulCoins = 0.0,
    this.cryptoBalance = 0.0,
    this.walletAddress,
    this.transactions = const [],
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['userId'] as String,
      soulCoins: (json['soulCoins'] as num?)?.toDouble() ?? 0.0,
      cryptoBalance: (json['cryptoBalance'] as num?)?.toDouble() ?? 0.0,
      walletAddress: json['walletAddress'] as String?,
      transactions: (json['transactions'] as List?)
              ?.map((t) => Transaction.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'soulCoins': soulCoins,
      'cryptoBalance': cryptoBalance,
      'walletAddress': walletAddress,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}
