/// Yüksek kaliteli görsel URL'leri: Unsplash featured + ui-avatars.
/// Tüm karakter ve kategori resimleri CachedNetworkImage ile kullanılır.

class AppAssets {
  AppAssets._();

  static const _unsplashBase = 'https://images.unsplash.com';
  /// Dinamik, yüksek kaliteli Unsplash featured (kategori anahtar kelimesi)
  static String unsplashFeatured(String keyword, {int width = 800, int height = 600}) {
    final q = keyword.trim().isEmpty ? 'nature' : keyword.replaceAll(' ', '%20');
    return 'https://source.unsplash.com/featured/${width}x$height/?$q';
  }

  /// Profil / kullanıcı avatarı
  static String avatarUrl(String nameOrId, {int size = 128, String? backgroundColor}) {
    final name = nameOrId.trim().isEmpty ? 'User' : nameOrId.replaceAll(' ', '%20');
    final bg = backgroundColor ?? '7C4DFF';
    return 'https://ui-avatars.com/api/?name=$name&size=$size&background=$bg&color=fff';
  }

  /// Kategori görseli – Unsplash featured ile dinamik
  static String categoryImage(String categoryKey, {int width = 400, int height = 300}) {
    final keyword = _categoryToKeyword(categoryKey);
    return unsplashFeatured(keyword, width: width, height: height);
  }

  static String _categoryToKeyword(String key) {
    final k = key.toLowerCase();
    if (k.contains('oyun') || k.contains('game')) return 'gaming';
    if (k.contains('canlı') || k.contains('live') || k.contains('stream')) return 'streaming';
    if (k.contains('ses') || k.contains('voice')) return 'music';
    if (k.contains('kripto') || k.contains('crypto')) return 'crypto';
    if (k.contains('market')) return 'shopping';
    if (k.contains('chat') || k.contains('sohbet')) return 'friends';
    if (k.contains('quiz') || k.contains('bilgi')) return 'education';
    return key.replaceAll(RegExp(r'[^a-z0-9]'), '').isEmpty ? 'abstract' : key;
  }

  /// Oyun / karakter görseli – yüksek kalite
  static String gameImage(int index, {int width = 400, int height = 400}) {
    const keywords = ['gaming', 'fun', 'casino', 'arcade', 'sport', 'adventure'];
    return unsplashFeatured(keywords[index % keywords.length], width: width, height: height);
  }

  /// Canlı yayın thumbnail
  static String liveStreamThumb(int index, {int width = 320, int height = 180}) {
    const keywords = ['streaming', 'concert', 'live', 'studio', 'broadcast'];
    return unsplashFeatured(keywords[index % keywords.length], width: width, height: height);
  }

  /// Genel placeholder
  static String placeholderImage({int width = 400, int height = 400, String keyword = 'abstract'}) {
    return unsplashFeatured(keyword, width: width, height: height);
  }
}
