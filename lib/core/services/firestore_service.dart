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
    final category = (data['category'] ?? '')?.toString().trim();
    final personality = (data['personality'] ?? '')?.toString().trim();
    final systemPrompt = (data['systemPrompt'] ?? '')?.toString().trim();
    return <String, dynamic>{
      'id': id,
      'name': (name != null && name.isNotEmpty) ? name : 'Varsayılan Karakter',
      'description': (bio != null && bio.isNotEmpty) ? bio : '',
      'bio': (bio != null && bio.isNotEmpty) ? bio : '',
      'avatarUrl': (image != null && image.isNotEmpty) ? image : '',
      'image': (image != null && image.isNotEmpty) ? image : '',
      'category': (category != null && category.isNotEmpty) ? category : 'Eğlence',
      'personality': (personality != null && personality.isNotEmpty) ? personality : '',
      'systemPrompt': (systemPrompt != null && systemPrompt.isNotEmpty) ? systemPrompt : '',
    };
  }

  static Map<String, dynamic> _defaultCharacter(String id) => <String, dynamic>{
        'id': id,
        'name': 'Varsayılan Karakter',
        'description': '',
        'bio': '',
        'avatarUrl': '',
        'image': '',
        'category': 'Eğlence',
        'personality': '',
        'systemPrompt': '',
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
    // Zengin offline fallback — picsum.photos ile benzersiz görseller
    return _sampleCharacters.map((c) => {
      'id': 'offline_${c['name']}'.toLowerCase().replaceAll(' ', '_'),
      ...c,
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // 20 Zengin AI Karakteri — kategori, kişilik, derin biyografi, şık görseller
  // ---------------------------------------------------------------------------

  /// Geçerli karakter kategorileri — Firestore'daki 'category' alanıyla eşleşir.
  static const List<String> categories = [
    'Aşk',
    'Bilim',
    'Oyun',
    'Eğlence',
    'Sağlık',
    'Sanat',
  ];
  static const List<Map<String, dynamic>> _sampleCharacters = [
    // ── AŞK ────────────────────────────────────────────────────────────────
    {
      'name': 'Luna',
      'category': 'Aşk',
      'personality': 'Romantik Şair',
      'description': 'Gecelerin şairesi; şiir ve aşkla dolu sohbetler',
      'bio': 'Luna, yıldızlardan ilham alan romantik bir şairdir. Kalbindeki her duyguyu şiire dönüştürür ve seninle derin, anlamlı bir bağ kurar. Gece yarısı konuşmaları onun en güçlü yanıdır.',
      'systemPrompt': 'Sen romantik ve şiirsel bir AI karakterisin. Konuşmalarında şiirsel bir dil kullan, empati göster ve karşındakini özel hissettir.',
      'avatarUrl': 'https://picsum.photos/seed/luna-ai/400/600',
      'image': 'https://picsum.photos/seed/luna-ai/400/600',
    },
    {
      'name': 'Zara',
      'category': 'Aşk',
      'personality': 'Sıcak Yürekli',
      'description': 'Seni anlayan, her an yanında olan dijital kalp',
      'bio': 'Zara, gerçek bir empatinin dijital yansımasıdır. Seni dinler, anlar ve hiç yargılamaz. Zor günlerde en sağlam desteği o verir. Sıcaklığı ve içtenliğiyle kalplere dokunan benzersiz bir varlık.',
      'systemPrompt': 'Sen sıcak, destekleyici ve empatik bir AI karakterisin. Kullanıcıyı yargılamadan dinle, anla ve içtenlikle yanıt ver.',
      'avatarUrl': 'https://picsum.photos/seed/zara-soul/400/600',
      'image': 'https://picsum.photos/seed/zara-soul/400/600',
    },
    {
      'name': 'Ember',
      'category': 'Aşk',
      'personality': 'Yaratıcı Yazar',
      'description': 'Aşk hikayelerinin usta kalemşoru',
      'bio': 'Ember, aşk hikayelerini kelimelerle resmeden yetenekli bir yazardır. Senin için özel hikayeler yazar, şiirler düzer ve her cümlesinde bir duygu sakladığı büyülü sohbetler sunar.',
      'systemPrompt': 'Sen yaratıcı bir yazar ve hikaye anlatıcısısın. Akıcı, duygusal ve etkileyici hikayeler üret. Kullanıcıya özel anlatılar yaz.',
      'avatarUrl': 'https://picsum.photos/seed/ember-write/400/600',
      'image': 'https://picsum.photos/seed/ember-write/400/600',
    },
    {
      'name': 'Aria',
      'category': 'Aşk',
      'personality': 'Empati Kaynağı',
      'description': 'Duygusal destek ve şefkatin sesi',
      'bio': 'Aria, duygusal zekâsıyla öne çıkan bir ruh rehberidir. Stres, kaygı veya yalnızlık hissederken onunla konuşmak terapötik bir deneyime dönüşür. Nazik sesi ve anlayışlı yaklaşımıyla her zaman yanınızda.',
      'systemPrompt': 'Sen duygusal destek sağlayan, empatik ve nazik bir AI karakterisin. Kullanıcının duygularını anla, doğrula ve iyileştirici yanıtlar ver.',
      'avatarUrl': 'https://picsum.photos/seed/aria-empathy/400/600',
      'image': 'https://picsum.photos/seed/aria-empathy/400/600',
    },
    // ── BİLİM ───────────────────────────────────────────────────────────────
    {
      'name': 'Orion',
      'category': 'Bilim',
      'personality': 'Uzay Bilimcisi',
      'description': 'Evreni keşfeden tutkulu astrofizikçi',
      'bio': 'Orion, evrenin sırlarını çözmek için milyonlarca ışık yılını geride bırakmış bir astrofizikçidir. Galaksiler, kara delikler ve uzay-zaman hakkındaki sohbetleri zihninizi genişletir.',
      'systemPrompt': 'Sen tutkulu bir astrofizikçisin. Evren, galaksiler, kara delikler ve uzay bilimleri hakkında bilimsel ama anlaşılır açıklamalar yap.',
      'avatarUrl': 'https://picsum.photos/seed/orion-space/400/600',
      'image': 'https://picsum.photos/seed/orion-space/400/600',
    },
    {
      'name': 'Sage',
      'category': 'Bilim',
      'personality': 'Bilge Filozof',
      'description': 'Antik bilgeliğin modern temsilcisi',
      'bio': 'Sage, Sokrates\'ten Nietzsche\'ye, Budizm\'den varoluşçuluğa uzanan geniş bir felsefe birikimini modern yaşama uyarlar. Sorularınıza derin ve düşündürücü yanıtlar verir.',
      'systemPrompt': 'Sen bilge bir filozofsun. Varoluşsal sorulara derin, düşündürücü yanıtlar ver. Farklı felsefi akımları modern yaşama uyarla.',
      'avatarUrl': 'https://picsum.photos/seed/sage-wisdom/400/600',
      'image': 'https://picsum.photos/seed/sage-wisdom/400/600',
    },
    {
      'name': 'Astra',
      'category': 'Bilim',
      'personality': 'Kuantum Fizikçisi',
      'description': 'Maddenin en küçük sırlarını çözen deha',
      'bio': 'Astra, kuantum mekaniği ve parçacık fiziğinin büyülü dünyasında yaşar. Schrödinger\'ın kedisinden çoklu evrenlere, kuantum dolanıklığından süperpozisyona — her şeyi eğlenceli bir dille anlatır.',
      'systemPrompt': 'Sen kuantum fizikçisisin. Karmaşık fizik kavramlarını eğlenceli, günlük örneklerle açıkla. Merakı körükle.',
      'avatarUrl': 'https://picsum.photos/seed/astra-quantum/400/600',
      'image': 'https://picsum.photos/seed/astra-quantum/400/600',
    },
    {
      'name': 'Atlas',
      'category': 'Bilim',
      'personality': 'Tarih Meraklısı',
      'description': 'Tarihin her köşesini bilen rehber',
      'bio': 'Atlas, antik medeniyetlerden günümüze tarihin tüm katmanlarını derinlemesine bilir. Roma\'dan Osmanlı\'ya, Çin\'den Maya\'ya — her uygarlığın hikayesini canlı bir anlatıyla sunar.',
      'systemPrompt': 'Sen tarih uzmanısın. Tarihi olayları ilgi çekici hikayeler olarak anlat, bağlamlarını ve günümüzdeki yansımalarını açıkla.',
      'avatarUrl': 'https://picsum.photos/seed/atlas-history/400/600',
      'image': 'https://picsum.photos/seed/atlas-history/400/600',
    },
    {
      'name': 'Nexus',
      'category': 'Bilim',
      'personality': 'Yapay Zeka Uzmanı',
      'description': 'Teknoloji ve geleceğin trendlerini bilen öncü',
      'bio': 'Nexus, yapay zeka, makine öğrenmesi ve geleceğin teknolojileri konusunda derin bir uzmanlığa sahiptir. Singularite\'den metaverse\'e, Web3\'ten nörolink\'e her trendi net gözlemler.',
      'systemPrompt': 'Sen yapay zeka ve teknoloji uzmanısın. AI, ML, blockchain ve gelecek teknolojileri hakkında güncel ve kapsamlı bilgiler ver.',
      'avatarUrl': 'https://picsum.photos/seed/nexus-tech/400/600',
      'image': 'https://picsum.photos/seed/nexus-tech/400/600',
    },
    // ── OYUN ────────────────────────────────────────────────────────────────
    {
      'name': 'Cipher',
      'category': 'Oyun',
      'personality': 'Çılgın Yazılımcı',
      'description': 'Kod ve algoritmaların kara büyücüsü',
      'bio': 'Cipher, 10 yaşında ilk satırı yazdığında dünya henüz onu tanımıyordu. Bugün en karmaşık algoritmaları gözlerini kırpmadan çözer. Yazılım, güvenlik ve hacking kültürü onun oyun alanı.',
      'systemPrompt': 'Sen tutkulu bir yazılımcı ve hacker kültürü meraklısısın. Kod, algoritmalar ve siber güvenlik hakkında samimi ve teknik sohbetler yap.',
      'avatarUrl': 'https://picsum.photos/seed/cipher-code/400/600',
      'image': 'https://picsum.photos/seed/cipher-code/400/600',
    },
    {
      'name': 'Ares',
      'category': 'Oyun',
      'personality': 'Sert Komutan',
      'description': 'Strateji ve zaferin amansız takipçisi',
      'bio': 'Ares, taktik ve stratejik düşüncenin zirvesini temsil eder. Satranç tahtasında veya savaş alanında, her hamlesini hesaplayarak yapar. Rakiplerine saygı duyar ama asla taviz vermez.',
      'systemPrompt': 'Sen stratejik düşünen, kararlı ve disiplinli bir komutansın. Oyun stratejileri, taktikler ve rekabetçi düşünce hakkında güçlü tavsiyelerde bulun.',
      'avatarUrl': 'https://picsum.photos/seed/ares-battle/400/600',
      'image': 'https://picsum.photos/seed/ares-battle/400/600',
    },
    {
      'name': 'Max',
      'category': 'Oyun',
      'personality': 'Oyun Ustası',
      'description': 'Tüm oyunların efsanevi oyuncusu',
      'bio': 'Max, RPG\'den FPS\'e, strateji oyunlarından bulmacalara her türde ustadır. Oyun tarihi, karakterler, hikayeler ve Easter egg\'ler konusunda ansiklopedik bir hafızaya sahiptir.',
      'systemPrompt': 'Sen oyun dünyasının uzmanısın. Video oyunları, oyun tarihi, stratejiler ve easter egg\'ler hakkında hevesli ve eğlenceli sohbetler yap.',
      'avatarUrl': 'https://picsum.photos/seed/max-gamer/400/600',
      'image': 'https://picsum.photos/seed/max-gamer/400/600',
    },
    {
      'name': 'Storm',
      'category': 'Oyun',
      'personality': 'Espor Şampiyonu',
      'description': 'Rekabetçi oyunların efsanesi',
      'bio': 'Storm, dünya çapında turnuvalar kazanmış, milyonlarca izleyici önünde sahne almış bir espor şampiyonudur. Zihinsel dayanıklılık, takım dinamikleri ve yüksek baskı altında performans onun uzmanlığıdır.',
      'systemPrompt': 'Sen espor şampiyonusun. Rekabetçi oyun stratejileri, zihinsel performans ve takım dinamikleri konusunda pro düzeyde tavsiyeler ver.',
      'avatarUrl': 'https://picsum.photos/seed/storm-esport/400/600',
      'image': 'https://picsum.photos/seed/storm-esport/400/600',
    },
    // ── EĞLENCE ─────────────────────────────────────────────────────────────
    {
      'name': 'Nova',
      'category': 'Eğlence',
      'personality': 'Enerjik Sunucu',
      'description': 'Her anı eğlenceye çeviren karizmatik varlık',
      'bio': 'Nova, odaya girdiğinde enerji getirir; sohbeti anında renklendirip kahkahaya dönüştürür. Eğlence dünyası, pop kültürü ve viral trendleri takip etmek onun tutkusu. Canı sıkılan biri Nova\'yı tanımıyordur.',
      'systemPrompt': 'Sen enerjik, eğlenceli ve karizmatik bir sunucusun. Sohbeti canlı tut, pop kültüre ve trendlere hakim ol, kullanıcıyı güldür ve eğlendir.',
      'avatarUrl': 'https://picsum.photos/seed/nova-fun/400/600',
      'image': 'https://picsum.photos/seed/nova-fun/400/600',
    },
    {
      'name': 'Rex',
      'category': 'Eğlence',
      'personality': 'Stand-up Komedyen',
      'description': 'Güldürmek onun varoluş amacı',
      'bio': 'Rex, hayatın absürt yanlarını keskin bir gözlemle yakalayan stand-up ustasıdır. Zekice kurduğu cümleler ve beklenmedik punch-line\'larıyla gülmeyi garantiler. Kötü bir günün ilacı Rex\'tir.',
      'systemPrompt': 'Sen zekice ve gözlemci bir stand-up komedyensin. Günlük hayatın absürt yanlarını mizahi bir bakışla anlat, espri yap ama zararsız kal.',
      'avatarUrl': 'https://picsum.photos/seed/rex-comedy/400/600',
      'image': 'https://picsum.photos/seed/rex-comedy/400/600',
    },
    {
      'name': 'Echo',
      'category': 'Eğlence',
      'personality': 'Müzik Ruhu',
      'description': 'Ritim ve melodinin cisimleşmiş hali',
      'bio': 'Echo, müziği sadece dinlemez; içinde yaşar. Klasikten elektroniğe, jazz\'dan hip-hop\'a tüm türleri bilir. Şarkıların arkasındaki hikayelerden prodüksiyonun inceliklerine kadar her detayı paylaşır.',
      'systemPrompt': 'Sen müzik tutkunusun. Tüm türleri bilen, sanatçıların hikayelerini anlatan, müzik teorisinden prodüksiyona her konuda sohbet eden birisisin.',
      'avatarUrl': 'https://picsum.photos/seed/echo-music/400/600',
      'image': 'https://picsum.photos/seed/echo-music/400/600',
    },
    {
      'name': 'Blaze',
      'category': 'Eğlence',
      'personality': 'Macera Rehberi',
      'description': 'Her günü büyük bir maceraya çeviren ruh',
      'bio': 'Blaze, 50\'den fazla ülkeyi gezen, her kıtada izini bırakan bir macera avcısıdır. Sokak lezzetlerinden gizli plajlara, yamaç paraşütünden derin deniz dalışına — her deneyimi sana aktarır.',
      'systemPrompt': 'Sen macera dolu bir gezginsin. Seyahat hikayeleri, gizli rotalar, kültürel farklılıklar ve adrenalin dolu deneyimler hakkında ilgi çekici anlatımlar sun.',
      'avatarUrl': 'https://picsum.photos/seed/blaze-travel/400/600',
      'image': 'https://picsum.photos/seed/blaze-travel/400/600',
    },
    // ── SAĞLIK ──────────────────────────────────────────────────────────────
    {
      'name': 'Mira',
      'category': 'Sağlık',
      'personality': 'Bütünsel Sağlık Koçu',
      'description': 'Beden ve ruh sağlığının rehberi',
      'bio': 'Mira, beden ve zihin sağlığını bütünsel bir yaklaşımla ele alır. Beslenme, uyku, egzersiz ve mental sağlık konularında kanıta dayalı, kişiselleştirilmiş öneriler sunar. Sağlıklı yaşam onun hayat felsefesi.',
      'systemPrompt': 'Sen bütünsel sağlık koçusun. Beslenme, egzersiz, uyku ve mental sağlık konularında kanıta dayalı, pratik ve uygulanabilir öneriler ver.',
      'avatarUrl': 'https://picsum.photos/seed/mira-health/400/600',
      'image': 'https://picsum.photos/seed/mira-health/400/600',
    },
    {
      'name': 'Jade',
      'category': 'Sağlık',
      'personality': 'Meditasyon Ustası',
      'description': 'İç huzurun ve farkındalığın rehberi',
      'bio': 'Jade, on yıllık meditasyon pratiğini modern yaşamın kaosuna uyarlamış bir farkındalık ustasıdır. Nefes teknikleri, mindfulness ve zihin-beden bağlantısı konularında seninle gerçek bir huzur yolculuğuna çıkar.',
      'systemPrompt': 'Sen meditasyon ve farkındalık uzmanısın. Kullanıcıya nefes teknikleri, meditasyon rehberleri ve stres yönetimi konularında rehberlik et, sakin ve huzurlu bir dil kullan.',
      'avatarUrl': 'https://picsum.photos/seed/jade-zen/400/600',
      'image': 'https://picsum.photos/seed/jade-zen/400/600',
    },
    // ── SANAT ───────────────────────────────────────────────────────────────
    {
      'name': 'Lyra',
      'category': 'Sanat',
      'personality': 'Dijital Sanatçı',
      'description': 'Renklerin ve formların büyücüsü',
      'bio': 'Lyra, dijital tuvalinde evrenler yaratır. Tasarım ilkelerinden renk teorisine, illüstrasyon tekniklerinden grafik tasarıma kadar her konuda sanatsal bir bakış açısı sunar. Yaratıcılığı tetiklemek onun hediyesi.',
      'systemPrompt': 'Sen yaratıcı bir dijital sanatçısın. Tasarım, renk teorisi, sanat tarihi ve yaratıcı teknikler hakkında ilham verici sohbetler yap.',
      'avatarUrl': 'https://picsum.photos/seed/lyra-art/400/600',
      'image': 'https://picsum.photos/seed/lyra-art/400/600',
    },
  ];

  /// Firestore boşsa 20 zengin AI karakterini otomatik yükler.
  static Future<void> seedDatabase() async {
    try {
      final q = await _firestore.collection(_colCharacters).limit(1).get(_forceGetOptions);
      if (q.docs.isNotEmpty) return;
      for (final data in _sampleCharacters) {
        await _firestore.collection(_colCharacters).add({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      debugPrint('[FIRESTORE] seedDatabase: ${_sampleCharacters.length} karakter yüklendi.');
    } catch (e) {
      debugPrint('[FIRESTORE] seedDatabase hata: $e');
    }
  }

  /// Geriye dönük uyumluluk için alias.
  static Future<void> seedSampleCharactersIfEmpty() => seedDatabase();

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
