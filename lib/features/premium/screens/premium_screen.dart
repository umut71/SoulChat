import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';
import 'package:soulchat/shared/providers/vip_provider.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _processingPlan = false;

  // Dinamik fiyatlandırma sabitleri
  static const double _firstTimePriceMonthly = 149.99;
  static const double _regularPriceMonthly = 399.99;
  static const double _priceYearly = 999.99;
  static const double _priceLifetime = 2499.99;

  @override
  Widget build(BuildContext context) {
    final vip = ref.watch(vipProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: vip.loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(vip),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (vip.isVip) _buildVipActiveCard(context),
                        if (!vip.isVip) _buildDynamicOfferBanner(context, vip),
                        const SizedBox(height: 20),
                        _buildFeaturesList(),
                        const SizedBox(height: 24),
                        _buildPricingCards(context, vip),
                        const SizedBox(height: 24),
                        _buildFAQ(),
                        const SizedBox(height: 16),
                        const Text(
                          'Tüm ödemeler Google Play güvencesi altındadır. İstediğin zaman iptal edebilirsin. Abonelik otomatik yenilenir.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  SliverAppBar _buildAppBar(VipState vip) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(vip.isVip ? '✨ VIP Üyesin!' : 'SoulChat VIP'),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: vip.isVip
                  ? [const Color(0xFFFFD700), const Color(0xFFFFA000)]
                  : [const Color(0xFF7C4DFF), const Color(0xFF00E5FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                FaIcon(
                  vip.isVip ? FontAwesomeIcons.solidStar : FontAwesomeIcons.crown,
                  size: 60, color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  vip.isVip ? 'Galaksinin VIP Üyesisin!' : 'Galaksinin En Güçlü Özelliklerine Eriş',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVipActiveCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.crown, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VIP Üyeliğin Aktif!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Tüm premium özellikler açık. Sınırsız AI, 2x coin ve daha fazlası!', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// İlk alım yapacak kullanıcıya özel fırsat banner'ı
  Widget _buildDynamicOfferBanner(BuildContext context, VipState vip) {
    final isFirstTime = !vip.hasPurchasedBefore;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isFirstTime
            ? const LinearGradient(colors: [Color(0xFF00C853), Color(0xFF1B5E20)], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFF311B92)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: (isFirstTime ? Colors.green : const Color(0xFF7C4DFF)).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          FaIcon(isFirstTime ? FontAwesomeIcons.fire : FontAwesomeIcons.bolt, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: isFirstTime
                ? const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('İlk Alıma Özel Fırsat!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('Bu fırsatı kaçırma – sadece ilk aya geçerli.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ])
                : const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('VIP ile Sınırsız Güç!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('Tüm AI özelliklerine tam erişim aç.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    const features = [
      ('Sınırsız AI Sohbet', 'Gemini ile limitsiz konuş', FontAwesomeIcons.robot),
      ('Reklamsız Deneyim', 'Hiç reklam görmeden kullan', FontAwesomeIcons.ban),
      ('2x SoulCoin Kazanımı', 'Her işlemde 2 kat puan kazan', FontAwesomeIcons.coins),
      ('Özel VIP Rozetleri', 'Profilinde VIP statüsünü göster', FontAwesomeIcons.certificate),
      ('1080p Canlı Yayın', 'Yüksek kalitede yayın yap', FontAwesomeIcons.video),
      ('Tüm Temalar Açık', 'Premium temalara tam erişim', FontAwesomeIcons.palette),
      ('Sınırsız Görsel Üretim', 'İstediğin kadar AI görsel üret', FontAwesomeIcons.image),
      ('7/24 VIP Destek', 'Öncelikli destek hattı', FontAwesomeIcons.headset),
    ];

    return Card(
      color: const Color(0xFF12172D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('VIP Ayrıcalıkları', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: const Color(0xFFFFD700).withOpacity(0.15), shape: BoxShape.circle),
                    child: FaIcon(f.$3, color: const Color(0xFFFFD700), size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(f.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(f.$2, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                    ]),
                  ),
                  const FaIcon(FontAwesomeIcons.circleCheck, color: Color(0xFFFFD700), size: 14),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCards(BuildContext context, VipState vip) {
    final isFirstTime = !vip.hasPurchasedBefore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paket Seç', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Aylık – DİNAMİK fiyat
        _MonthlyCard(
          isFirstTime: isFirstTime,
          firstTimePrice: _firstTimePriceMonthly,
          regularPrice: _regularPriceMonthly,
          onBuy: () => _onPurchase(context, 'monthly', isFirstTime ? 'İlk Ay Özel' : 'Aylık',
              isFirstTime ? _firstTimePriceMonthly : _regularPriceMonthly, 30),
          recommended: true,
        ),
        const SizedBox(height: 12),
        _PlanCard(
          title: 'Yıllık',
          price: '₺${_priceYearly.toStringAsFixed(2).replaceAll('.', ',')}',
          subtitle: 'yıllık ödeme',
          savings: '₺${(_regularPriceMonthly * 12 - _priceYearly).toStringAsFixed(0)} tasarruf',
          recommended: false,
          badgeText: 'EN AVANTAJLI',
          onBuy: () => _onPurchase(context, 'yearly', 'Yıllık', _priceYearly, 365),
        ),
        const SizedBox(height: 12),
        _PlanCard(
          title: 'Ömür Boyu',
          price: '₺${_priceLifetime.toStringAsFixed(2).replaceAll('.', ',')}',
          subtitle: 'tek seferlik ödeme',
          savings: null,
          recommended: false,
          badgeText: null,
          onBuy: () => _onPurchase(context, 'lifetime', 'Ömür Boyu', _priceLifetime, null),
        ),
      ],
    );
  }

  Future<void> _onPurchase(BuildContext context, String planId, String planName, double price, int? durationDays) async {
    if (_processingPlan) return;
    SystemSound.play(SystemSoundType.click);

    // Onay diyaloğu
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const FaIcon(FontAwesomeIcons.lock, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          const Text('Güvenli Ödeme'),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$planName Paketi', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('₺${price.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF7C4DFF))),
          const SizedBox(height: 8),
          Text(durationDays != null ? '$durationDays günlük VIP erişim açılacak.' : 'Ömür boyu VIP erişim açılacak.', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          const Text('+ 50 SoulCoin aktivasyon bonusu!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(spacing: 6, children: [
            _payBadge('Visa'), _payBadge('Mastercard'), _payBadge('Google Pay'),
          ]),
          const SizedBox(height: 8),
          const Text('* Google Play üzerinden güvenli ödeme.', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Onayla')),
        ],
      ),
    );

    if (confirm != true || !mounted) return;
    setState(() => _processingPlan = true);

    try {
      await ref.read(vipProvider.notifier).activatePlan(
        planId: planId,
        bonusCoins: 50,
        duration: durationDays != null ? Duration(days: durationDays) : null,
      );
      await ref.read(soulCoinProvider.notifier).add(50);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const FaIcon(FontAwesomeIcons.crown, color: Color(0xFFFFD700), size: 16),
            const SizedBox(width: 8),
            Text('VIP Aktif! $planName paketi başladı. +50 SC bonus!'),
          ]),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _processingPlan = false);
    }
  }

  Widget _payBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
    child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
  );

  Widget _buildFAQ() {
    final faqs = [
      ('İlk ay özel fiyatı sadece bir kez mi geçerli?', 'Evet. İlk alımına özel ₺149,99 sunulmaktadır; yenilemeler ₺399,99 üzerinden gerçekleşir.'),
      ('İstediğim zaman iptal edebilir miyim?', 'Evet, Google Play üzerinden istediğiniz zaman iptal edebilirsiniz.'),
      ('Ücretsiz deneme var mı?', 'Yeni kullanıcılar 7 gün ücretsiz VIP deneme hakkından yararlanabilir.'),
      ('VIP olduktan sonra SoulCoin bakiyem artar mı?', 'Evet. VIP ile tüm işlemlerde 2x SoulCoin kazanırsın. Ayrıca 50 SC aktivasyon bonusu verilir.'),
      ('Yıllık pakette ne kadar tasarruf ederim?', 'Aylık ₺399,99 × 12 = ₺4.799,88 yerine ₺999,99 ödersiniz; yaklaşık ₺3.800 tasarruf.'),
    ];

    return Card(
      color: const Color(0xFF12172D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Sık Sorulan Sorular', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq.$1, style: const TextStyle(color: Colors.white, fontSize: 12)),
            iconColor: const Color(0xFFFFD700),
            collapsedIconColor: Colors.grey,
            children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: Text(faq.$2, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)))],
          )),
        ],
      ),
    );
  }
}

// --- Alt widget'lar ---

class _MonthlyCard extends StatelessWidget {
  final bool isFirstTime;
  final double firstTimePrice;
  final double regularPrice;
  final VoidCallback onBuy;
  final bool recommended;

  const _MonthlyCard({
    required this.isFirstTime,
    required this.firstTimePrice,
    required this.regularPrice,
    required this.onBuy,
    required this.recommended,
  });

  String _fmt(double v) => '₺${v.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isFirstTime
            ? const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)])
            : const LinearGradient(colors: [Color(0xFF12172D), Color(0xFF1A2142)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isFirstTime ? Colors.green.shade400 : Colors.grey.shade700, width: 1.5),
        boxShadow: isFirstTime
            ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Etiket
            if (isFirstTime)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                child: const Text('🔥 FIRSATI KAÇIRMA! – SADECE İLK AY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF7C4DFF), borderRadius: BorderRadius.circular(20)),
                child: const Text('AYLIK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            const SizedBox(height: 12),
            const Text('Aylık Abonelik', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (isFirstTime) ...[
              // Üzeri çizili normal fiyat + indirimli fiyat
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  _fmt(regularPrice),
                  style: const TextStyle(color: Colors.grey, fontSize: 16, decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(width: 10),
                Text(_fmt(firstTimePrice), style: const TextStyle(color: Colors.greenAccent, fontSize: 30, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 4),
              const Text('İlk aya özel fiyat!', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
            ] else ...[
              Text(_fmt(regularPrice), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('aylık ödeme', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFirstTime ? Colors.greenAccent : const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const FaIcon(FontAwesomeIcons.lock, size: 13),
                  const SizedBox(width: 8),
                  Text(
                    isFirstTime ? 'Güvenli Satın Al – ${_fmt(firstTimePrice)}/ay' : 'Güvenli Satın Al – ${_fmt(regularPrice)}/ay',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final String? savings;
  final bool recommended;
  final String? badgeText;
  final VoidCallback onBuy;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.savings,
    required this.recommended,
    required this.badgeText,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF12172D), Color(0xFF1A2142)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: recommended ? const Color(0xFFFFD700) : Colors.grey.shade700, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(12)),
                child: Text(badgeText!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(height: 10),
            ],
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            if (savings != null) ...[
              const SizedBox(height: 4),
              Text(savings!, style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const FaIcon(FontAwesomeIcons.lock, size: 13),
                  const SizedBox(width: 8),
                  Text('Güvenli Satın Al – $price', style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
