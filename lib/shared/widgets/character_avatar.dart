import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soulchat/core/theme/app_theme.dart';

/// Karakter/AI avatarı: CachedNetworkImage ile yükler; hata veya boş URL'de şık AI Avatar ikonu gösterir.
class CharacterAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;

  const CharacterAvatar({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppTheme.primaryColor.withOpacity(0.3);
    final effectiveUrl = imageUrl?.trim();
    if (effectiveUrl == null || effectiveUrl.isEmpty) {
      return _buildFallback(bg);
    }
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: effectiveUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          placeholder: (_, __) => Container(
            color: bg,
            child: Center(
              child: SizedBox(
                width: size * 0.4,
                height: size * 0.4,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (_, __, ___) => _buildFallback(bg),
        ),
      ),
    );
  }

  Widget _buildFallback(Color bg) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.smart_toy,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
}
