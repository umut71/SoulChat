import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';

final _gameItems = [
  {'title': 'Çarkıfelek', 'subtitle': 'Günlük çevir, SoulCoin kazan', 'route': '/spin-wheel', 'icon': FontAwesomeIcons.dharmachakra, 'color': Colors.orange},
  {'title': 'Yazı-Tura', 'subtitle': '10 SC bahis, 20 SC kazan', 'route': '/coin-flip', 'icon': FontAwesomeIcons.coins, 'color': Colors.amber},
  {'title': 'AI Bilgi Yarışması', 'subtitle': 'Soru cevapla, ödül kazan', 'route': '/quiz', 'icon': FontAwesomeIcons.brain, 'color': Colors.purple},
  {'title': 'Liderlik', 'subtitle': 'Sıralamayı gör', 'route': '/leaderboard', 'icon': FontAwesomeIcons.trophy, 'color': Colors.blue},
  {'title': 'Turnuvalar', 'subtitle': 'Turnuvalara katıl', 'route': '/tournaments', 'icon': FontAwesomeIcons.medal, 'color': Colors.green},
  {'title': 'Başarım', 'subtitle': 'Rozetler', 'route': '/achievements', 'icon': FontAwesomeIcons.star, 'color': Colors.deepOrange},
];

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(soulCoinProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oyunlar'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.coins, color: Colors.amber, size: 20),
                  const SizedBox(width: 6),
                  Text('$balance', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trophy),
            onPressed: () => context.push('/leaderboard'),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _gameItems.length,
        itemBuilder: (context, index) {
          final g = _gameItems[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () => context.push(g['route'] as String),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (g['color'] as Color).withOpacity(0.9),
                      (g['color'] as Color),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(g['icon'] as IconData, size: 40, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      g['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g['subtitle'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
