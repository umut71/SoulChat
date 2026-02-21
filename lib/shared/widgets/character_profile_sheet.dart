import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/shared/widgets/character_avatar.dart';

/// Karakter ismine tıklandığında açılan şık bottom sheet: Biyografi, İlgi Alanları, Ses Tonu.
void showCharacterProfileSheet(
  BuildContext context, {
  required String name,
  String? avatarUrl,
  String biography = '',
  List<String> interests = const ['Sohbet', 'Yaratıcılık', 'Öğrenme'],
  String voiceTone = 'Samimi ve doğal',
}) {
  HapticFeedback.lightImpact();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkSurface.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CharacterAvatar(imageUrl: avatarUrl, size: 64),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.offWhite,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            voiceTone,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.secondaryColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionTitle(icon: Icons.person_outline, label: 'Biyografi'),
                const SizedBox(height: 8),
                Text(
                  biography.isNotEmpty ? biography : 'AI asistan ile sohbet ederek kişiselleştirilmiş deneyim yaşayın.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppTheme.offWhite.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                _SectionTitle(icon: Icons.favorite_border, label: 'İlgi Alanları'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interests
                      .map((e) => Chip(
                            label: Text(e, style: const TextStyle(fontSize: 13)),
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                            side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.5)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                _SectionTitle(icon: Icons.record_voice_over_outlined, label: 'Ses Tonu'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.graphic_eq, color: AppTheme.secondaryColor, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        voiceTone,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.offWhite.withOpacity(0.95),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.offWhite,
          ),
        ),
      ],
    );
  }
}
