class UserModel {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final int soulCoins;
  final int level;
  final int experience;
  final DateTime createdAt;
  final DateTime? lastSeen;
  final List<String> friends;
  final Map<String, dynamic>? settings;
  final bool isOnline;
  final String? voiceEffectId;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.soulCoins = 0,
    this.level = 1,
    this.experience = 0,
    required this.createdAt,
    this.lastSeen,
    this.friends = const [],
    this.settings,
    this.isOnline = false,
    this.voiceEffectId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      soulCoins: json['soulCoins'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen'] as String) : null,
      friends: List<String>.from(json['friends'] ?? []),
      settings: json['settings'] as Map<String, dynamic>?,
      isOnline: json['isOnline'] as bool? ?? false,
      voiceEffectId: json['voiceEffectId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'soulCoins': soulCoins,
      'level': level,
      'experience': experience,
      'createdAt': createdAt.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'friends': friends,
      'settings': settings,
      'isOnline': isOnline,
      'voiceEffectId': voiceEffectId,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    int? soulCoins,
    int? level,
    int? experience,
    DateTime? createdAt,
    DateTime? lastSeen,
    List<String>? friends,
    Map<String, dynamic>? settings,
    bool? isOnline,
    String? voiceEffectId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      soulCoins: soulCoins ?? this.soulCoins,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      friends: friends ?? this.friends,
      settings: settings ?? this.settings,
      isOnline: isOnline ?? this.isOnline,
      voiceEffectId: voiceEffectId ?? this.voiceEffectId,
    );
  }
}
