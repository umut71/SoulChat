import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool showOnlineIndicator;
  final bool isOnline;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = imageUrl?.trim();
    final bgColor = Theme.of(context).primaryColor;
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          child: effectiveUrl == null || effectiveUrl.isEmpty
              ? Icon(Icons.person, size: radius, color: Colors.white)
              : ClipOval(
                  child: SizedBox(
                    width: radius * 2,
                    height: radius * 2,
                    child: CachedNetworkImage(
                      imageUrl: effectiveUrl,
                      fit: BoxFit.cover,
                      width: radius * 2,
                      height: radius * 2,
                      placeholder: (_, __) => Center(
                        child: SizedBox(
                          width: radius * 0.6,
                          height: radius * 0.6,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.smart_toy,
                        size: radius,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
        if (showOnlineIndicator)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.4,
              height: radius * 0.4,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
