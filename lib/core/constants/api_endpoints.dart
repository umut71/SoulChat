class ApiEndpoints {
  static const String baseUrl = 'https://api.soulchat.app';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // Users
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String updateProfile = '/users/profile';
  
  // Chat
  static const String chats = '/chats';
  static String chatById(String id) => '/chats/$id';
  static const String messages = '/messages';
  
  // Games
  static const String games = '/games';
  static String gameById(String id) => '/games/$id';
  static const String leaderboard = '/games/leaderboard';
  
  // Marketplace
  static const String products = '/marketplace/products';
  static const String packages = '/marketplace/packages';
  static const String purchase = '/marketplace/purchase';
  
  // Wallet
  static const String wallet = '/wallet';
  static const String transactions = '/wallet/transactions';
  static const String buySoulCoins = '/wallet/buy-coins';
}
