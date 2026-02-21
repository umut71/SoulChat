import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/shared/widgets/character_avatar.dart';
import 'package:soulchat/core/constants/app_assets.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.userPlus),
            onPressed: () => context.push('/friends'),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CharacterAvatar(
              imageUrl: AppAssets.avatarUrl('AI'),
              size: 48,
            ),
            title: const Text('AI Asistan'),
            subtitle: const Text('Gemini ile sohbet & görsel üret'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              debugPrint('[GEMINI_DEBUG] Sayfa açılıyor...');
              context.push('/ai-companion');
            },
          ),
          ...List.generate(9, (index) {
            final i = index + 1;
            return ListTile(
              leading: CharacterAvatar(
                imageUrl: AppAssets.avatarUrl('User$i'),
                size: 48,
              ),
              title: Text('Kullanıcı $i'),
              subtitle: const Text('Son mesaj...'),
              trailing: const Text('12:30'),
              onTap: () => context.push('/chat/$i'),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('[GEMINI_DEBUG] Sayfa açılıyor...');
          context.push('/ai-companion');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
