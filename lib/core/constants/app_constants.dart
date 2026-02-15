class AppConstants {
  // App Info
  static const String appName = 'SoulChat';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'World-class social, gaming & crypto mobile application';

  // URLs
  static const String termsUrl = 'https://soulchat.app/terms';
  static const String privacyUrl = 'https://soulchat.app/privacy';
  static const String supportUrl = 'https://soulchat.app/support';

  // Limits
  static const int maxMessageLength = 1000;
  static const int maxUsernameLength = 20;
  static const int minUsernameLength = 3;
  static const int maxBioLength = 150;

  // Chat
  static const int maxMessagesPerLoad = 50;
  static const int typingIndicatorDuration = 3; // seconds

  // Voice/Video
  static const int maxVoiceRoomParticipants = 10;
  static const int maxVideoCallParticipants = 8;

  // Coins
  static const int dailyLoginReward = 10;
  static const int messageReward = 1;
  static const int gameWinReward = 50;

  // Files
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];
}
