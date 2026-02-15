import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soulchat/core/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _chats => _firestore.collection('chats');
  CollectionReference get _messages => _firestore.collection('messages');

  // Create User Profile
  Future<void> createUserProfile(UserModel user) async {
    await _users.doc(user.id).set(user.toJson());
  }

  // Get User Profile
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  // Update User Profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _users.doc(userId).update(data);
  }

  // Get User Stream
  Stream<UserModel?> getUserStream(String userId) {
    return _users.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    });
  }

  // Send Message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
    String? mediaUrl,
    String? messageType,
  }) async {
    await _messages.add({
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      'mediaUrl': mediaUrl,
      'messageType': messageType ?? 'text',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Update chat last message
    await _chats.doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get Messages Stream
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _messages
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  // Update SoulCoins
  Future<void> updateSoulCoins(String userId, int amount) async {
    await _users.doc(userId).update({
      'soulCoins': FieldValue.increment(amount),
    });
  }

  // Add Transaction
  Future<void> addTransaction({
    required String userId,
    required String type,
    required double amount,
    required String description,
  }) async {
    await _firestore.collection('transactions').add({
      'userId': userId,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
