class GameModel {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final int players;
  final String category;
  final int rewardCoins;
  final bool isActive;

  GameModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.players = 0,
    required this.category,
    this.rewardCoins = 0,
    this.isActive = true,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      players: json['players'] as int? ?? 0,
      category: json['category'] as String,
      rewardCoins: json['rewardCoins'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'players': players,
      'category': category,
      'rewardCoins': rewardCoins,
      'isActive': isActive,
    };
  }
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final int score;
  final int rank;
  final String? avatarUrl;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
    required this.rank,
    this.avatarUrl,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      username: json['username'] as String,
      score: json['score'] as int,
      rank: json['rank'] as int,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'score': score,
      'rank': rank,
      'avatarUrl': avatarUrl,
    };
  }
}
