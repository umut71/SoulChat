import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// firebase_options.dart ile başlatılan Firebase üzerinden tüm veritabanı akışı.
/// Karakterler, Mesajlar, Cüzdan, Oyun Skorları tek merkezden senkron.
class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  // --- Cüzdan (SoulCoin bakiye) ---
  static const String _colUsers = 'users';
  static const String _fieldBalance = 'soulCoinBalance';

  static const _getOptions = GetOptions(source: Source.serverAndCache);
  /// soulchat-pro'dan kesin veri: get() ile zorla sunucudan çek (Force Fetch).
  static const _forceGetOptions = GetOptions(source: Source.server);

  static Future<int> getWalletBalance() async {
    if (_uid == null) return 0;
    try {
      final doc = await _firestore.collection(_colUsers).doc(_uid).get(_forceGetOptions);
      final data = doc.data();
      if (data != null && data[_fieldBalance] != null) {
        return (data[_fieldBalance] is int) ? data[_fieldBalance] as int : 0;
      }
    } catch (_) {}
    return 0;
  }

  static Future<void> setWalletBalance(int balance) async {
    if (_uid == null) return;
    try {
      await _firestore.collection(_colUsers).doc(_uid).set({
        _fieldBalance: balance,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  // --- VIP / Satın Alım Durumu ---
  static const String _fieldIsVip = 'isVip';
  static const String _fieldHasPurchased = 'hasPurchasedBefore';
  static const String _fieldVipExpiry = 'vipExpiresAt';

  /// Kullanıcının VIP ve ilk alım durumunu döner.
  static Future<({bool isVip, bool hasPurchasedBefore})> getUserPurchaseStatus() async {
    if (_uid == null) return (isVip: false, hasPurchasedBefore: false);
    try {
      final doc = await _firestore.collection(_colUsers).doc(_uid).get(_forceGetOptions);
      final data = doc.data() ?? {};
      return (
        isVip: data[_fieldIsVip] == true,
        hasPurchasedBefore: data[_fieldHasPurchased] == true,
      );
    } catch (_) {
      return (isVip: false, hasPurchasedBefore: false);
    }
  }

  /// Ödeme başarılı olduğunda çağrılır: VIP aç, hasPurchasedBefore=true, SoulCoin bonus ekle.
  static Future<void> activateVip({
    required String planId,
    required int bonusCoins,
    Duration? duration,
  }) async {
    if (_uid == null) return;
    try {
      final expiry = duration != null
          ? Timestamp.fromDate(DateTime.now().add(duration))
          : null;
      await _firestore.collection(_colUsers).doc(_uid).set({
        _fieldIsVip: true,
        _fieldHasPurchased: true,
        if (expiry != null) _fieldVipExpiry: expiry,
        'vipPlan': planId,
        'vipActivatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      // Cüzdana VIP bonus
      if (bonusCoins > 0) {
        final current = await getWalletBalance();
        await setWalletBalance(current + bonusCoins);
        await addTransaction(amount: bonusCoins, type: 'vip_bonus', description: 'VIP aktivasyon bonusu');
      }
    } catch (_) {}
  }

  /// Kullanıcının VIP durumunu döner (anlık kontrol).
  static Future<bool> isUserVip() async {
    final status = await getUserPurchaseStatus();
    return status.isVip;
  }

  // --- İşlem geçmişi (Production: her bakiye değişikliği kaydedilir) ---
  static const String _colTransactions = 'transactions';

  static Future<void> addTransaction({
    required int amount,
    required String type,
    String? toUserId,
    String? description,
  }) async {
    if (_uid == null) return;
    try {
      await _firestore.collection(_colTransactions).add({
        'fromUserId': _uid,
        'toUserId': toUserId,
        'amount': amount,
        'type': type,
        'description': description ?? type,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Başka kullanıcıya SoulCoin gönderir; bakiyeyi düşürür, karşı tarafı artırır, işlem kaydı oluşturur.
  static Future<bool> sendGift({required String toUserId, required int amount}) async {
    if (_uid == null || _uid == toUserId || amount <= 0) return false;
    try {
      final fromRef = _firestore.collection(_colUsers).doc(_uid);
      final toRef = _firestore.collection(_colUsers).doc(toUserId);
      await _firestore.runTransaction((tx) async {
        final fromDoc = await tx.get(fromRef);
        final toDoc = await tx.get(toRef);
        final fromBalance = (fromDoc.data()?[_fieldBalance] as num?)?.toInt() ?? 0;
        if (fromBalance < amount) throw StateError('Yetersiz bakiye');
        final toBalance = (toDoc.data()?[_fieldBalance] as num?)?.toInt() ?? 0;
        tx.set(fromRef, {_fieldBalance: fromBalance - amount, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        tx.set(toRef, {_fieldBalance: toBalance + amount, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        final transRef = _firestore.collection(_colTransactions).doc();
        tx.set(transRef, {
          'fromUserId': _uid,
          'toUserId': toUserId,
          'amount': amount,
          'type': 'gift',
          'description': 'Hediye',
          'createdAt': FieldValue.serverTimestamp(),
        });
      });
      return true;
    } catch (_) {}
    return false;
  }

  // --- Canlı yayın oturumları (Production: Yayın Başlat → Firebase'e kayıt) ---
  static const String _colLiveSessions = 'live_sessions';

  static Future<void> createLiveSession({
    required String channelId,
    required String title,
  }) async {
    if (_uid == null) return;
    try {
      await _firestore.collection(_colLiveSessions).add({
        'channelId': channelId,
        'userId': _uid,
        'title': title,
        'status': 'live',
        'startedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  static Future<void> endLiveSession(String channelId) async {
    if (_uid == null) return;
    try {
      final q = await _firestore
          .collection(_colLiveSessions)
          .where('channelId', isEqualTo: channelId)
          .where('userId', isEqualTo: _uid)
          .where('status', isEqualTo: 'live')
          .limit(1)
          .get(_forceGetOptions);
      for (final d in q.docs) {
        await d.reference.update({'status': 'ended', 'endedAt': FieldValue.serverTimestamp()});
      }
    } catch (_) {}
  }

  // --- Mesajlar (sohbet) ---
  static const String _colRooms = 'chat_rooms';
  static const String _colMessages = 'messages';

  static Future<void> sendMessage(String roomId, String text, {bool isFromUser = true}) async {
    try {
      await _firestore
          .collection(_colRooms)
          .doc(roomId)
          .collection(_colMessages)
          .add({
        'text': text,
        'userId': _uid,
        'isFromUser': isFromUser,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> messageStream(String roomId) {
    return _firestore
        .collection(_colRooms)
        .doc(roomId)
        .collection(_colMessages)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots();
  }

  // --- Oyun skorları ---
  static const String _colScores = 'game_scores';

  static Future<void> saveGameScore(String gameId, int score, {Map<String, dynamic>? extra}) async {
    if (_uid == null) return;
    try {
      await _firestore.collection(_colScores).add({
        'userId': _uid,
        'gameId': gameId,
        'score': score,
        'createdAt': FieldValue.serverTimestamp(),
        if (extra != null) ...extra,
      });
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard(String gameId, {int limit = 20}) async {
    try {
      final q = await _firestore
          .collection(_colScores)
          .where('gameId', isEqualTo: gameId)
          .orderBy('score', descending: true)
          .limit(limit)
          .get(_forceGetOptions);
      return q.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (_) {}
    return [];
  }

  // --- Karakterler (AI karakter listesi) - Offline cache: önce cache göster, arka planda güncelle ---
  static const String _colCharacters = 'characters';
  static List<Map<String, dynamic>> _charactersCache = [];
  static bool _charactersCacheLoaded = false;

  /// Firestore Mapping Fix: image/resim, name/isim, bio/aciklama dahil tüm alan adlarını kontrol et.
  /// Eksik alan ?? 'Varsayılan Değer'; uygulama ASLA boş liste göstermesin.
  static Map<String, dynamic> characterFromFirestore(String id, Map<String, dynamic>? data) {
    if (data == null) return _defaultCharacter(id);
    final nameRaw = data['name'] ?? data['isim'] ?? data['title'] ?? data['baslik'] ?? '';
    final bioRaw = data['bio'] ?? data['aciklama'] ?? data['description'] ?? data['desc'] ?? data['ozet'] ?? '';
    final imageRaw = data['image'] ?? data['resim'] ?? data['avatarUrl'] ?? data['avatar'] ?? data['photoUrl'] ?? data['photo'] ?? data['gorsel'] ?? '';
    final name = nameRaw?.toString().trim();
    final bio = bioRaw?.toString().trim();
    final image = imageRaw?.toString().trim();
    return <String, dynamic>{
      'id': id,
      'name': (name != null && name.isNotEmpty) ? name : 'Varsayılan Karakter',
      'description': (bio != null && bio.isNotEmpty) ? bio : '',
      'bio': (bio != null && bio.isNotEmpty) ? bio : '',
      'avatarUrl': (image != null && image.isNotEmpty) ? image : '',
      'image': (image != null && image.isNotEmpty) ? image : '',
    };
  }

  static Map<String, dynamic> _defaultCharacter(String id) => <String, dynamic>{
        'id': id,
        'name': 'Varsayılan Karakter',
        'description': '',
        'bio': '',
        'avatarUrl': '',
        'image': '',
      };

  static Future<List<Map<String, dynamic>>> getCharacters() async {
    try {
      // Collection adı Firestore'dakiyle BİREBİR aynı olmalı: 'characters'
      final q = await _firestore.collection(_colCharacters).limit(50).get(_forceGetOptions);
      final list = <Map<String, dynamic>>[];
      for (final d in q.docs) {
        try {
          list.add(characterFromFirestore(d.id, d.data()));
        } catch (e) {
          // Tek doküman hata verse bile devam et; varsayılan karakter ata
          list.add(characterFromFirestore(d.id, null));
        }
      }
      _charactersCache = list;
      _charactersCacheLoaded = true;
      if (list.isEmpty) {
        debugPrint('[FIRESTORE] Veri bulunamadı – collection: "$_colCharacters", offline fallback kullanılıyor.');
        return getCharactersOffline();
      }
      return list;
    } catch (e) {
      debugPrint('[FIRESTORE] getCharacters hata: $e');
      if (_charactersCacheLoaded) return _charactersCache;
      return getCharactersOffline();
    }
  }

  static List<Map<String, dynamic>> getCharactersOffline() {
    if (_charactersCache.isNotEmpty) return _charactersCache;
    return [
      {'id': 'offline_1', 'name': 'Luna', 'description': 'Gece ve rüya rehberi', 'avatarUrl': 'https://i.pravatar.cc/300?img=1'},
      {'id': 'offline_2', 'name': 'Nova', 'description': 'Bilim ve keşif meraklısı', 'avatarUrl': 'https://i.pravatar.cc/300?img=2'},
      {'id': 'offline_3', 'name': 'Sage', 'description': 'Felsefe ve sohbet ustası', 'avatarUrl': 'https://i.pravatar.cc/300?img=3'},
    ];
  }

  /// Firestore boşsa 20 popüler karakteri otomatik yükler (seed).
  static Future<void> seedSampleCharactersIfEmpty() async {
    try {
      final q = await _firestore.collection(_colCharacters).limit(1).get(_forceGetOptions);
      if (q.docs.isNotEmpty) return;
      const samples = [
        {'name': 'AI Sevgili', 'description': 'Seni dinleyen, her an yanında olan dijital arkadaş', 'avatarUrl': 'https://i.pravatar.cc/300?img=1'},
        {'name': 'Psikolog', 'description': 'Duygusal destek ve iç görü konuşmaları', 'avatarUrl': 'https://i.pravatar.cc/300?img=2'},
        {'name': 'Yazılımcı', 'description': 'Kod, teknoloji ve kariyer sohbetleri', 'avatarUrl': 'https://i.pravatar.cc/300?img=3'},
        {'name': 'Yaşam Koçu', 'description': 'Hedef belirleme ve motivasyon', 'avatarUrl': 'https://i.pravatar.cc/300?img=4'},
        {'name': 'Öğretmen', 'description': 'Öğrenme ve merak rehberi', 'avatarUrl': 'https://i.pravatar.cc/300?img=5'},
        {'name': 'Şef', 'description': 'Tarifler ve yemek kültürü', 'avatarUrl': 'https://i.pravatar.cc/300?img=6'},
        {'name': 'Müzisyen', 'description': 'Müzik, ritim ve beste sohbetleri', 'avatarUrl': 'https://i.pravatar.cc/300?img=7'},
        {'name': 'Sanatçı', 'description': 'Yaratıcılık ve görsel sanatlar', 'avatarUrl': 'https://i.pravatar.cc/300?img=8'},
        {'name': 'Doktor', 'description': 'Genel sağlık bilgisi ve yaşam tarzı', 'avatarUrl': 'https://i.pravatar.cc/300?img=9'},
        {'name': 'Avukat', 'description': 'Hukuki konularda bilgilendirme', 'avatarUrl': 'https://i.pravatar.cc/300?img=10'},
        {'name': 'Girişimci', 'description': 'İş fikirleri ve strateji sohbetleri', 'avatarUrl': 'https://i.pravatar.cc/300?img=11'},
        {'name': 'Astrolog', 'description': 'Burçlar ve kişisel yansımalar', 'avatarUrl': 'https://i.pravatar.cc/300?img=12'},
        {'name': 'Meditasyon Ustası', 'description': 'Farkındalık ve sakinlik rehberi', 'avatarUrl': 'https://i.pravatar.cc/300?img=13'},
        {'name': 'Hikaye Anlatıcı', 'description': 'Masallar ve yaratıcı hikayeler', 'avatarUrl': 'https://i.pravatar.cc/300?img=14'},
        {'name': 'Bilim İnsanı', 'description': 'Bilim ve merak dünyası', 'avatarUrl': 'https://i.pravatar.cc/300?img=15'},
        {'name': 'Spor Koçu', 'description': 'Antrenman ve sağlıklı yaşam', 'avatarUrl': 'https://i.pravatar.cc/300?img=16'},
        {'name': 'Moda Danışmanı', 'description': 'Stil ve kişisel imaj', 'avatarUrl': 'https://i.pravatar.cc/300?img=17'},
        {'name': 'Seyahat Rehberi', 'description': 'Rota önerileri ve kültür sohbetleri', 'avatarUrl': 'https://i.pravatar.cc/300?img=18'},
        {'name': 'Şair', 'description': 'Şiir ve duygu dili', 'avatarUrl': 'https://i.pravatar.cc/300?img=19'},
        {'name': 'Oyun Arkadaşı', 'description': 'Oyun stratejileri ve eğlence', 'avatarUrl': 'https://i.pravatar.cc/300?img=20'},
      ];
      for (final data in samples) {
        await _firestore.collection(_colCharacters).add({
          ...data as Map<String, dynamic>,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> charactersStream() {
    return _firestore.collection(_colCharacters).snapshots();
  }

  // --- AI konuşma geçmişi (hafıza) ---
  static String get _aiRoomId => 'ai_companion_${_uid ?? "guest"}';

  static Future<void> saveAiMessage(String text, {bool isFromUser = true, String? imageUrl}) async {
    try {
      await _firestore
          .collection(_colRooms)
          .doc(_aiRoomId)
          .collection(_colMessages)
          .add({
        'text': text,
        'userId': _uid,
        'isFromUser': isFromUser,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getAiConversation({int limit = 50}) async {
    try {
      final q = await _firestore
          .collection(_colRooms)
          .doc(_aiRoomId)
          .collection(_colMessages)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get(_forceGetOptions);
      final list = q.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      return list.reversed.toList();
    } catch (_) {}
    return [];
  }

  // --- Global Feed (akış) ---
  static const String _colFeed = 'feed';

  static Future<void> addFeedPost(String text, {String? imageUrl}) async {
    if (_uid == null) return;
    try {
      await _firestore.collection(_colFeed).add({
        'userId': _uid,
        'userName': _auth.currentUser?.displayName ?? _auth.currentUser?.email ?? 'Anonim',
        'text': text,
        'imageUrl': imageUrl,
        'likes': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> feedStream({int limit = 50}) {
    return _firestore
        .collection(_colFeed)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  // --- Geliştirme Talepleri (System Architect) ---
  static const String _colDevRequests = 'development_requests';

  static Future<void> addDevelopmentRequest({
    required String text,
    required String type,
  }) async {
    if (_uid == null) return;
    try {
      await _firestore.collection(_colDevRequests).add({
        'userId': _uid,
        'text': text,
      'type': type,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
    });
    } catch (_) {}
  }
}
