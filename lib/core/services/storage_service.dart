import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload Profile Picture
  Future<String?> uploadProfilePicture(String userId, File file) async {
    try {
      final ref = _storage.ref().child('profiles/$userId/avatar.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // Upload Chat Media
  Future<String?> uploadChatMedia(String chatId, File file, String type) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('chats/$chatId/$type/$timestamp');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // Upload Live Stream Thumbnail
  Future<String?> uploadStreamThumbnail(String streamId, File file) async {
    try {
      final ref = _storage.ref().child('streams/$streamId/thumbnail.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // Delete File
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Handle error
    }
  }
}
