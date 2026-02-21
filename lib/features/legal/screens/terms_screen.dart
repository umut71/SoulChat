import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanım Koşulları')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SoulChat: AI Universe – Kullanım Koşulları',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'SoulChat: AI Universe bir AI sosyal oyun platformudur. Uygulamayı kullanarak aşağıdaki koşulları kabul etmiş sayılırsınız.\n\n'
              '• SoulCoin uygulama içi oyun puanıdır; gerçek para veya kripto para değildir.\n'
              '• Kripto bölümü sadece bilgi amaçlı piyasa takibidir; işlem yapılamaz.\n'
              '• Canlı yayın ve sesli odalar belirli cihazlarda kullanılabilir.\n'
              '• Kişisel verileriniz Gizlilik Sözleşmesi kapsamında işlenir.\n\n'
              'Güncel metin için uygulama içi destek veya web sitemiz üzerinden ulaşabilirsiniz.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
