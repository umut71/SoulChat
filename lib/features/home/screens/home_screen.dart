import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/core/constants/app_assets.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/core/utils/safe_nav.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';
import 'package:soulchat/shared/widgets/glass_card.dart';
import 'package:soulchat/shared/widgets/gradient_background.dart';
import 'package:soulchat/shared/widgets/character_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(soulCoinProvider);
    final offline = GoRouterState.of(context).uri.queryParameters['offline'] == '1';
    return Scaffold(
      body: GradientBackground(
        fullScreen: true,
        colors: GradientBackground.deepSpaceGradient,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  const Icon(Icons.bolt, color: AppTheme.goldColor),
                  const SizedBox(width: 8),
                  Text(
                    'SoulChat: AI Universe',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/marketplace');
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.goldColor.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(FontAwesomeIcons.coins, color: AppTheme.goldColor, size: 18),
                              const SizedBox(width: 4),
                              Text('$balance', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.bell, color: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/notifications');
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.gear, color: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/settings');
                  },
                ),
              ],
            ),
            if (offline)
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Çevrimdışı Mod', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Karakter Ara...',
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _CategoryChip(label: 'Popüler', selected: true),
                          const SizedBox(width: 8),
                          _CategoryChip(label: 'Romantik', selected: false),
                          const SizedBox(width: 8),
                          _CategoryChip(label: 'Bilge', selected: false),
                          const SizedBox(width: 8),
                          _CategoryChip(label: 'Eğlence', selected: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: FirestoreService.getCharacters().timeout(
                          const Duration(seconds: 5),
                          onTimeout: () => Future.value(FirestoreService.getCharactersOffline()),
                        ),
                        builder: (context, snap) {
                          final crossCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;
                          if (!snap.hasData) {
                            return SizedBox(
                              height: 120,
                              child: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                            );
                          }
                          final list = snap.data!.isEmpty
                              ? FirestoreService.getCharactersOffline()
                              : snap.data!;
                          final itemHeight = 132.0;
                          final rows = (list.length / crossCount).ceil();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Karakterler',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: rows * itemHeight + (rows - 1) * 12,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossCount,
                                    childAspectRatio: 0.72,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: list.length,
                                  itemBuilder: (context, i) {
                                    final item = list[i];
                                    return _CharacterGridCard(item: item);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(child: _buildWelcomeCard(context, ref)),
                    const SizedBox(height: 24),
                    FadeInUp(delay: const Duration(milliseconds: 150), child: _buildAllFeaturesCard(context)),
                    const SizedBox(height: 16),
                    FadeInUp(delay: const Duration(milliseconds: 200), child: _buildQuickActions(context)),
                    const SizedBox(height: 24),
                    FadeInUp(delay: const Duration(milliseconds: 400), child: _buildSectionTitle(context, 'Canlı Yayın', Icons.stream, '/live')),
                    const SizedBox(height: 12),
                    FadeInUp(delay: const Duration(milliseconds: 500), child: _buildLiveStreams(context)),
                    const SizedBox(height: 24),
                    FadeInUp(delay: const Duration(milliseconds: 600), child: _buildSectionTitle(context, 'Oyunlar', Icons.games, '/games')),
                    const SizedBox(height: 12),
                    FadeInUp(delay: const Duration(milliseconds: 700), child: _buildTrendingGames(context)),
                    const SizedBox(height: 24),
                    FadeInUp(delay: const Duration(milliseconds: 800), child: _buildSectionTitle(context, 'Sesli Odalar', Icons.mic, '/voice-chat')),
                    const SizedBox(height: 12),
                    FadeInUp(delay: const Duration(milliseconds: 900), child: _buildVoiceRooms(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(soulCoinProvider);
    return GlassCard(
      borderRadius: 20,
      blur: 12,
      padding: const EdgeInsets.all(20),
      borderColor: Colors.white24,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.6),
              AppTheme.secondaryColor.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hoş geldin!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bağlan, oyna, keşfet.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('$balance', 'SoulCoin', FontAwesomeIcons.coins),
              const SizedBox(width: 12),
              _buildStatChip('Seviye 15', 'İlerleme', FontAwesomeIcons.trophy),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildStatChip(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 76, child: _buildActionButton(context, 'Canlı', FontAwesomeIcons.video, AppTheme.neonPink, '/live')),
          const SizedBox(width: 12),
          SizedBox(width: 76, child: _buildActionButton(context, 'Ses', FontAwesomeIcons.microphone, AppTheme.secondaryColor, '/voice-chat')),
          const SizedBox(width: 12),
          SizedBox(width: 76, child: _buildActionButton(context, 'Oyunlar', FontAwesomeIcons.gamepad, AppTheme.primaryColor, '/games')),
          const SizedBox(width: 12),
          SizedBox(width: 76, child: _buildActionButton(context, 'Kripto', FontAwesomeIcons.bitcoin, AppTheme.goldColor, '/wallet')),
          const SizedBox(width: 12),
          SizedBox(width: 76, child: _buildActionButton(context, 'Market', FontAwesomeIcons.cartShopping, AppTheme.accentColor, '/marketplace')),
        ],
      ),
    );
  }

  Widget _buildAllFeaturesCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showDeepAgentThenNavigate(context, '/all-features', featureName: 'Tüm Özellikler');
      },
      child: GlassCard(
        borderRadius: 16,
        blur: 10,
        padding: const EdgeInsets.all(16),
        borderColor: Colors.white24,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.7),
                AppTheme.secondaryColor.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
          children: [
            const Icon(Icons.apps, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tüm Özellikler',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '203 ekranı keşfet',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    ),
    );
  }

  static Future<void> _showDeepAgentThenNavigate(BuildContext context, String route, {String? featureName}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(height: 16),
              const Text('Hazırlanıyor...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    if (!context.mounted) return;
    debugPrint('[GEMINI_DEBUG] Sayfa açılıyor... ($route)');
    SafeNav.push(context, route);
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showDeepAgentThenNavigate(context, route, featureName: label);
      },
      child: GlassCard(
        borderRadius: 16,
        blur: 8,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon, String seeAllRoute) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.secondaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _showDeepAgentThenNavigate(context, seeAllRoute, featureName: title);
          },
          child: const Text('Tümü', style: TextStyle(color: AppTheme.secondaryColor)),
        ),
      ],
    );
  }

  Widget _buildLiveStreams(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showDeepAgentThenNavigate(context, '/live', featureName: 'Canlı Yayın');
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              child: GlassCard(
                borderRadius: 16,
                blur: 8,
                padding: EdgeInsets.zero,
                borderColor: Colors.white24,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: AppAssets.liveStreamThumb(index),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppTheme.darkCard, child: const Center(child: CircularProgressIndicator())),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.primaryDark,
                        child: const Icon(Icons.videocam, color: Colors.white54, size: 48),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 8),
                            SizedBox(width: 4),
                            Text('CANLI', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black87],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Yayıncı ${index + 1}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.visibility, color: Colors.white70, size: 12),
                                const SizedBox(width: 4),
                                Text('${(index + 1) * 123}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingGames(BuildContext context) {
    const games = ['Çarkıfelek', 'Yazı-Tura', 'AI Quiz', 'Turnuva', 'Liderlik'];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showDeepAgentThenNavigate(context, '/games', featureName: 'Oyunlar');
            },
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 12),
              child: GlassCard(
                borderRadius: 16,
                blur: 8,
                padding: EdgeInsets.zero,
                borderColor: Colors.white24,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: AppAssets.gameImage(index),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppTheme.darkCard, child: const Center(child: CircularProgressIndicator())),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.primaryDark,
                        child: const FaIcon(FontAwesomeIcons.gamepad, color: Colors.white54, size: 32),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        games[index],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoiceRooms(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showDeepAgentThenNavigate(context, '/voice-chat', featureName: 'Sesli Odalar');
            },
            child: Container(
              width: 250,
              margin: const EdgeInsets.only(right: 12),
              child: GlassCard(
                borderRadius: 16,
                blur: 10,
                padding: const EdgeInsets.all(16),
                borderColor: Colors.white24,
                child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                    child: const FaIcon(FontAwesomeIcons.microphone, color: AppTheme.secondaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sesli Oda ${index + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '${(index + 1) * 5} kişi konuşuyor',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontSize: 13)),
      selected: selected,
      onSelected: (_) {},
      backgroundColor: Colors.white.withOpacity(0.08),
      selectedColor: AppTheme.primaryColor.withOpacity(0.8),
      side: BorderSide(color: selected ? AppTheme.primaryColor : Colors.white24),
    );
  }
}

class _CharacterGridCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _CharacterGridCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final name = (item['name'] ?? item['title'])?.toString() ?? 'AI';
    final desc = (item['description'] ?? item['bio'])?.toString() ?? '';
    final avatarUrl = (item['avatarUrl'] ?? item['image'])?.toString();
    return GlassCard(
      borderRadius: 12,
      blur: 8,
      padding: const EdgeInsets.all(10),
      borderColor: Colors.white24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CharacterAvatar(imageUrl: avatarUrl, size: 48),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (desc.isNotEmpty)
            Text(
              desc,
              style: TextStyle(color: Colors.white70, fontSize: 10),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
