import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soulchat/core/constants/app_assets.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/features/live_streaming/screens/live_room_screen.dart';
import 'package:soulchat/shared/widgets/character_avatar.dart';

class LiveStreamingScreen extends StatelessWidget {
  const LiveStreamingScreen({super.key});

  Widget _buildEmptyLiveCTA(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: AppTheme.primaryDark.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LiveRoomScreen(channelId: 'soul_live_host', title: 'Yayınınız'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.live_tv, size: 48, color: Colors.white70),
              const SizedBox(height: 12),
              const Text(
                'Aktif yayın yok, ilk yayını sen başlat!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Yayın Başlat butonuna basarak canlı yayın açabilirsin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int liveCount = 10;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Yayın'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: liveCount == 0 ? 1 : liveCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildEmptyLiveCTA(context);
          final i = index - 1;
          final channelId = 'soul_live_${i + 1}';
          final title = 'Yayın ${i + 1}';
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: AppAssets.liveStreamThumb(i),
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppTheme.primaryDark,
                          child: const Center(child: FaIcon(FontAwesomeIcons.video, size: 48, color: Colors.white54)),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppTheme.primaryDark,
                          child: const Center(child: FaIcon(FontAwesomeIcons.video, size: 48, color: Colors.white54)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 8),
                            SizedBox(width: 6),
                            Text('CANLI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CharacterAvatar(
                            imageUrl: AppAssets.avatarUrl('Streamer${i + 1}'),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text('Yayıncı ${i + 1}'),
                          const Spacer(),
                          const Icon(Icons.visibility, size: 16),
                          const SizedBox(width: 4),
                          Text('${(i + 1) * 123}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LiveRoomScreen(channelId: channelId, title: title),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text('Yayına Katıl'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LiveRoomScreen(channelId: 'soul_live_host', title: 'Yayınınız'),
            ),
          );
        },
        icon: const FaIcon(FontAwesomeIcons.video),
        label: const Text('Yayın Başlat'),
      ),
    );
  }
}
