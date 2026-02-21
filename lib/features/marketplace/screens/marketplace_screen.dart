import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:soulchat/core/theme/app_theme.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';
import 'package:soulchat/shared/providers/vip_provider.dart';

// SoulCoin paketleri – TL fiyatlandırma
const _coinPackages = [
  {
    'id': 'coin_100',
    'name': 'Başlangıç Paketi',
    'coins': 100,
    'price': '₺49,99',
    'badge': null,
    'color': Color(0xFF5E35B1),
    'icon': FontAwesomeIcons.coins,
    'discount': null,
  },
  {
    'id': 'coin_500',
    'name': 'Avantaj Paketi',
    'coins': 500,
    'price': '₺199,99',
    'badge': 'EN POPÜLER',
    'color': Color(0xFF7C4DFF),
    'icon': FontAwesomeIcons.star,
    'discount': '%20 İndirim',
  },
  {
    'id': 'coin_1000',
    'name': 'Mega Paket',
    'coins': 1000,
    'price': '₺349,99',
    'badge': 'EN AVANTAJLI',
    'color': Color(0xFFFFD700),
    'icon': FontAwesomeIcons.crown,
    'discount': '%30 İndirim',
  },
];

// SC ile satın alınan dijital içerikler
const _digitalItems = [
  {'name': 'Tema: Gece', 'price': 50, 'icon': FontAwesomeIcons.moon},
  {'name': 'Tema: Güneş', 'price': 50, 'icon': FontAwesomeIcons.sun},
  {'name': 'Özel Avatar', 'price': 100, 'icon': FontAwesomeIcons.userAstronaut},
  {'name': 'Premium Sohbet', 'price': 150, 'icon': FontAwesomeIcons.crown},
  {'name': '5x Görsel Paketi', 'price': 25, 'icon': FontAwesomeIcons.images},
  {'name': 'Sınırsız Öneri', 'price': 200, 'icon': FontAwesomeIcons.wandMagicSparkles},
];

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  static void _click() => SystemSound.play(SystemSoundType.click);

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(soulCoinProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.coins, size: 16, color: Color(0xFFFFD700)),
                  const SizedBox(width: 4),
                  Text('$balance SC', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.bagShopping, size: 16), text: 'SoulCoin Al'),
            Tab(icon: FaIcon(FontAwesomeIcons.store, size: 16), text: 'Dijital Ürünler'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tab,
          children: [
            _StoreTab(balance: balance),
            _DigitalTab(balance: balance),
          ],
        ),
      ),
    );
  }
}

class _StoreTab extends ConsumerWidget {
  final int balance;
  const _StoreTab({required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İlk alım kampanya banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.tag, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('İlk Alıma Özel', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('%20 İndirim', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Tüm SoulCoin paketlerinde geçerli!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('SoulCoin Paketleri', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Daha fazla AI mesajı, oyun ve içerik için SoulCoin satın al.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          ...(_coinPackages.map((pkg) => _CoinPackageCard(pkg: pkg, ref: ref))),
          const SizedBox(height: 16),
          // VIP Abonelik
          _VipCard(),
          const SizedBox(height: 16),
          _StoreNotice(context),
        ],
      ),
    );
  }
}

class _CoinPackageCard extends ConsumerWidget {
  final Map pkg;
  final WidgetRef ref;
  const _CoinPackageCard({required this.pkg, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPopular = pkg['badge'] != null;
    final badgeText = pkg['badge'] as String?;
    final color = pkg['color'] as Color;
    final isGold = color == const Color(0xFFFFD700);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isGold
              ? [const Color(0xFFFFD700), const Color(0xFFFFA000)]
              : [color.withOpacity(0.9), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: isPopular ? Border.all(color: Colors.white54, width: 1.5) : null,
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: FaIcon(pkg['icon'] as IconData, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            // Sol bilgi – esnek
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badgeText != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Text(badgeText, style: TextStyle(color: color == const Color(0xFFFFD700) ? const Color(0xFFFFA000) : color, fontWeight: FontWeight.bold, fontSize: 9)),
                    ),
                    const SizedBox(height: 3),
                  ],
                  Text(pkg['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.coins, size: 11, color: Colors.white70),
                      Text('${pkg['coins']} SC', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      if (pkg['discount'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                          child: Text(pkg['discount'] as String, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Sağ fiyat + buton – sabit genişlik
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(pkg['price'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 5),
                SizedBox(
                  width: 76,
                  child: ElevatedButton(
                    onPressed: () {
                      SystemSound.play(SystemSoundType.click);
                      _showPurchaseDialog(context, ref, pkg);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isGold ? const Color(0xFFFFA000) : color,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Satın Al', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref, Map pkg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle),
              child: const FaIcon(FontAwesomeIcons.lock, color: Colors.green, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Satın Alım Onayı'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  FaIcon(pkg['icon'] as IconData, color: pkg['color'] as Color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pkg['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('${pkg['price']} • ${pkg['coins']} SoulCoin', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Hesabına eklenecek. Google Play güvencesi ile güvenli ödeme.', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _paymentBadge('Visa'),
                const SizedBox(width: 8),
                _paymentBadge('Mastercard'),
                const SizedBox(width: 8),
                _paymentBadge('Google Pay'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(soulCoinProvider.notifier).add(pkg['coins'] as int);
              _showConfettiOverlay(context, pkg['coins'] as int);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${pkg['coins']} SoulCoin hesabına eklendi!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }

  void _showConfettiOverlay(BuildContext context, int coins) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => PopScope(
        canPop: true,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_touohxv0.json',
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
              Text(
                '+$coins SoulCoin',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Harika!'),
              ),
            ],
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) Navigator.of(context, rootNavigator: true).maybePop();
    });
  }

  Widget _paymentBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
  );
}

class _VipCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vip = ref.watch(vipProvider);
    final isFirstTime = !vip.hasPurchasedBefore;
    final isVip = vip.isVip;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isVip
            ? const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)])
            : const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isVip ? Colors.transparent : (isFirstTime ? Colors.green.shade400 : const Color(0xFFFFD700)), width: 1.5),
        boxShadow: isFirstTime && !isVip
            ? [BoxShadow(color: Colors.green.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: isVip
            ? Row(children: const [
                FaIcon(FontAwesomeIcons.crown, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('✨ VIP Üyesin!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Tüm özellikler açık. Sınırsız AI, 2x coin!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ])),
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const FaIcon(FontAwesomeIcons.crown, color: Color(0xFFFFD700), size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('VIP Aylık Abonelik', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: isFirstTime
                          ? Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                              const Text('₺399,99', style: TextStyle(color: Colors.grey, fontSize: 11, decoration: TextDecoration.lineThrough)),
                              const Text('₺149,99/ay', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                            ])
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(8)),
                              child: const Text('₺399,99/ay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                    ),
                  ]),
                  if (isFirstTime) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                      child: const Text('🔥 İLK AYA ÖZEL – FIRSATI KAÇIRMA!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ...[
                    'Sınırsız AI Sohbet ve Analiz',
                    '2x SoulCoin Kazanımı',
                    'Özel VIP Rozetleri',
                    '1080p Canlı Yayın',
                  ].map((f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      const FaIcon(FontAwesomeIcons.circleCheck, color: Color(0xFFFFD700), size: 13),
                      const SizedBox(width: 8),
                      Text(f, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                  )),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/premium'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFirstTime ? Colors.green : const Color(0xFFFFD700),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isFirstTime ? 'VIP Ol – ₺149,99/ay (İlk Ay)' : 'VIP Ol – ₺399,99/ay',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Center(child: Text('İstediğin zaman iptal edebilirsin', style: TextStyle(color: Colors.grey, fontSize: 10))),
                ],
              ),
      ),
    );
  }
}

class _DigitalTab extends ConsumerWidget {
  final int balance;
  const _DigitalTab({required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.coins, color: Color(0xFFFFD700), size: 18),
                const SizedBox(width: 8),
                Text('Bakiyen: $balance SoulCoin', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('SC Satın Al'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Dijital İçerikler', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text('AI mesaj hakkı, tema, avatar – gerçek para ile alım yok.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.78,
            ),
            itemCount: _digitalItems.length,
            itemBuilder: (context, index) {
              final item = _digitalItems[index];
              final name = item['name'] as String;
              final price = item['price'] as int;
              final icon = item['icon'] as IconData;
              final canBuy = balance >= price;
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.primaries[index % Colors.primaries.length],
                        child: Center(child: FaIcon(icon, size: 40, color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.coins, size: 11, color: Color(0xFFFFD700)),
                                  const SizedBox(width: 3),
                                  Text('$price SC', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                              FilledButton(
                                onPressed: canBuy
                                    ? () async {
                                        SystemSound.play(SystemSoundType.click);
                                        final ok = await ref.read(soulCoinProvider.notifier).spend(price);
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(ok ? '$name kullanıma açıldı!' : 'Yetersiz SoulCoin'),
                                          backgroundColor: ok ? Colors.green : Colors.red,
                                        ));
                                      }
                                    : null,
                                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                                child: const Text('Al', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _StoreNotice(context),
        ],
      ),
    );
  }
}

Widget _StoreNotice(BuildContext context) => Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
    borderRadius: BorderRadius.circular(12),
  ),
  child: const Text(
    'Marketteki ürünler dijital içeriktir (AI mesaj hakkı, tema, oyun hakkı vb.). SoulCoin uygulama içi oyun puanıdır; gerçek kripto para veya yasal ödeme aracı değildir. Ödeme işlemleri Google Play güvencesi altındadır.',
    style: TextStyle(fontSize: 11, color: Colors.grey),
    textAlign: TextAlign.center,
  ),
);
