import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/shared/widgets/character_avatar.dart';
import 'package:soulchat/shared/widgets/character_profile_sheet.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => showCharacterProfileSheet(
            context,
            name: 'User $chatId',
            biography: 'Bu kullanıcı ile sohbet ediyorsunuz. Mesajlaşma geçmişi burada görüntülenir.',
            interests: const ['Sohbet', 'Paylaşım'],
            voiceTone: 'Arkadaş canlısı',
          ),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CharacterAvatar(size: 32),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User $chatId', style: const TextStyle(fontSize: 16)),
                  const Text('Online', style: TextStyle(fontSize: 12, color: Colors.green)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(icon: const FaIcon(FontAwesomeIcons.video), onPressed: () {}),
          IconButton(icon: const FaIcon(FontAwesomeIcons.phone), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: 20,
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0;
                final time = '${(index % 12) + 10}:${(index % 60).toString().padLeft(2, '0')}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: _GlassBubble(
                      isUser: isMe,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Message ${index + 1}',
                            style: TextStyle(color: isMe ? Colors.white : AppTheme.offWhite, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(time, style: TextStyle(fontSize: 10, color: (isMe ? Colors.white : AppTheme.offWhite).withOpacity(0.7))),
                              if (isMe) ...[
                                const SizedBox(width: 4),
                                Icon(Icons.done_all, size: 12, color: Colors.white.withOpacity(0.8)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                IconButton(icon: const FaIcon(FontAwesomeIcons.circlePlus), onPressed: () {}),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                IconButton(icon: const FaIcon(FontAwesomeIcons.microphone), onPressed: () {}),
                IconButton(icon: const FaIcon(FontAwesomeIcons.paperPlane), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBubble extends StatelessWidget {
  final bool isUser;
  final Widget child;

  const _GlassBubble({required this.isUser, required this.child});

  @override
  Widget build(BuildContext context) {
    const neonPurple = Color(0xFF7C4DFF);
    const deepBlue = Color(0xFF16213E);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isUser ? neonPurple.withOpacity(0.85) : deepBlue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
