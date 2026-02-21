import 'package:firebase_storage/firebase_storage.dart';

/// Web stub: File tabanlı upload desteklenmez; deleteFile çalışır.
class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String?> uploadProfilePicture(String userId, dynamic file) async {
    throw UnsupportedError('Profil resmi yükleme web\'de desteklenmiyor.');
  }

  Future<String?> uploadChatMedia(String chatId, dynamic file, String type) async {
    throw UnsupportedError('Medya yükleme web\'de desteklenmiyor.');
  }

  Future<String?> uploadStreamThumbnail(String streamId, dynamic file) async {
    throw UnsupportedError('Thumbnail yükleme web\'de desteklenmiyor.');
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {}
  }
}
