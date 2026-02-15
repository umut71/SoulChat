class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final String? mediaUrl;
  final String messageType;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    this.mediaUrl,
    this.messageType = 'text',
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      message: json['message'] as String,
      mediaUrl: json['mediaUrl'] as String?,
      messageType: json['messageType'] as String? ?? 'text',
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      'mediaUrl': mediaUrl,
      'messageType': messageType,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}

class Chat {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? chatName;
  final String? chatImage;
  final bool isGroup;

  Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.chatName,
    this.chatImage,
    this.isGroup = false,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      participants: List<String>.from(json['participants']),
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] != null 
          ? DateTime.parse(json['lastMessageTime'] as String)
          : null,
      chatName: json['chatName'] as String?,
      chatImage: json['chatImage'] as String?,
      isGroup: json['isGroup'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'chatName': chatName,
      'chatImage': chatImage,
      'isGroup': isGroup,
    };
  }
}
