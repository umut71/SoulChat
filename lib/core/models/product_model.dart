class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String? imageUrl;
  final String category;
  final int stock;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'SOULCOIN',
    this.imageUrl,
    required this.category,
    this.stock = 0,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SOULCOIN',
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      stock: json['stock'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'isAvailable': isAvailable,
    };
  }
}

class CoinPackage {
  final String id;
  final String name;
  final int coinAmount;
  final double price;
  final int bonusCoins;
  final bool isPopular;

  CoinPackage({
    required this.id,
    required this.name,
    required this.coinAmount,
    required this.price,
    this.bonusCoins = 0,
    this.isPopular = false,
  });

  int get totalCoins => coinAmount + bonusCoins;

  factory CoinPackage.fromJson(Map<String, dynamic> json) {
    return CoinPackage(
      id: json['id'] as String,
      name: json['name'] as String,
      coinAmount: json['coinAmount'] as int,
      price: (json['price'] as num).toDouble(),
      bonusCoins: json['bonusCoins'] as int? ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coinAmount': coinAmount,
      'price': price,
      'bonusCoins': bonusCoins,
      'isPopular': isPopular,
    };
  }
}
