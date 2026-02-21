import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulchat/core/constants/app_assets.dart';
import 'package:soulchat/core/services/firebase_auth_service.dart';
import 'package:soulchat/shared/providers/auth_provider.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';
import 'package:soulchat/shared/widgets/character_avatar.dart';

const String _kProfileAvatarIndex = 'profile_avatar_index';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _avatarIndex = 0;
  static const int _avatarCount = 8;

  @override
  void initState() {
    super.initState();
    _loadAvatarIndex();
  }

  Future<void> _loadAvatarIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _avatarIndex = prefs.getInt(_kProfileAvatarIndex) ?? 0);
  }

  Future<void> _saveAvatarIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kProfileAvatarIndex, index);
    setState(() => _avatarIndex = index);
  }

  String get _avatarUrl => AppAssets.avatarUrl('User$_avatarIndex', size: 128);

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    final nameController = TextEditingController(text: user?.displayName ?? user?.email ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İsim Düzenle'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Görünen isim',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              await ref.read(firebaseAuthServiceProvider).updateDisplayName(name);
              ref.invalidate(authStateProvider);
              if (context.mounted) Navigator.pop(ctx);
              if (context.mounted) setState(() {});
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Avatar Seç', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _avatarCount,
                itemBuilder: (context, i) {
                  final selected = i == _avatarIndex;
                  return InkWell(
                    onTap: () {
                      _saveAvatarIndex(i);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected ? Theme.of(context).primaryColor : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CharacterAvatar(
                        imageUrl: AppAssets.avatarUrl('User$i', size: 64),
                        size: 64,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final balance = ref.watch(soulCoinProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.gear),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF00D9C0)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showAvatarPicker(context),
                    child: Stack(
                      children: [
                        CharacterAvatar(imageUrl: _avatarUrl, size: 100),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD700),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _showEditNameDialog(context, ref),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.displayName ?? user?.email ?? 'Misafir',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.edit, size: 18, color: Colors.white70),
                      ],
                    ),
                  ),
                  Text(
                    user?.email ?? 'Giriş yapmadınız',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _showEditNameDialog(context, ref),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('İsim Düzenle'),
                    style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('$balance', 'SoulCoin'),
                      _buildStatColumn('15', 'Seviye'),
                      _buildStatColumn('0', 'Arkadaş'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(Icons.person, 'Profili Düzenle', () => context.push('/settings')),
            _buildMenuItem(Icons.photo_camera, 'Avatar Seç', () => _showAvatarPicker(context)),
            _buildMenuItem(FontAwesomeIcons.trophy, 'Başarımlar', () => context.push('/achievements')),
            _buildMenuItem(FontAwesomeIcons.chartLine, 'İstatistikler', () => context.push('/achievements')),
            _buildMenuItem(FontAwesomeIcons.userGroup, 'Arkadaşlar', () => context.push('/friends')),
            _buildMenuItem(FontAwesomeIcons.clock, 'Aktivite', () => context.push('/notifications')),
            _buildMenuItem(FontAwesomeIcons.shield, 'Gizlilik', () => context.push('/settings')),
            if (user != null)
              _buildMenuItem(Icons.logout, 'Çıkış yap', () async {
                await ref.read(firebaseAuthServiceProvider).signOut();
                if (context.mounted) context.go('/login');
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: FaIcon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
