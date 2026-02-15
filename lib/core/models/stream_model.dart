class LiveStream {
  final String id;
  final String userId;
  final String username;
  final String title;
  final String? thumbnailUrl;
  final int viewerCount;
  final DateTime startTime;
  final bool isLive;
  final String? category;

  LiveStream({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    this.thumbnailUrl,
    this.viewerCount = 0,
    required this.startTime,
    this.isLive = true,
    this.category,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      viewerCount: json['viewerCount'] as int? ?? 0,
      startTime: DateTime.parse(json['startTime'] as String),
      isLive: json['isLive'] as bool? ?? true,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'viewerCount': viewerCount,
      'startTime': startTime.toIso8601String(),
      'isLive': isLive,
      'category': category,
    };
  }
}

class VoiceRoom {
  final String id;
  final String name;
  final String hostId;
  final String hostName;
  final List<String> participants;
  final int maxParticipants;
  final bool isPublic;
  final String? topic;

  VoiceRoom({
    required this.id,
    required this.name,
    required this.hostId,
    required this.hostName,
    this.participants = const [],
    this.maxParticipants = 10,
    this.isPublic = true,
    this.topic,
  });

  factory VoiceRoom.fromJson(Map<String, dynamic> json) {
    return VoiceRoom(
      id: json['id'] as String,
      name: json['name'] as String,
      hostId: json['hostId'] as String,
      hostName: json['hostName'] as String,
      participants: List<String>.from(json['participants'] ?? []),
      maxParticipants: json['maxParticipants'] as int? ?? 10,
      isPublic: json['isPublic'] as bool? ?? true,
      topic: json['topic'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hostId': hostId,
      'hostName': hostName,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'isPublic': isPublic,
      'topic': topic,
    };
  }
}
