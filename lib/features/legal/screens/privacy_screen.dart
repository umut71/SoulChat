import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik Sözleşmesi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SoulChat: AI Universe – Gizlilik Sözleşmesi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'SoulChat: AI Universe olarak gizliliğinize saygı gösteriyoruz.\n\n'
              '• Hesap ve sohbet verileriniz güvenli şekilde saklanır.\n'
              '• Verileriniz yalnızca hizmet kalitesi ve kişiselleştirme amacıyla kullanılır.\n'
              '• Üçüncü taraflarla kişisel veri paylaşımı yapılmaz; yasal zorunluluklar hariç.\n'
              '• SoulCoin ve oyun verileri sunucularımızda tutulur.\n\n'
              'Detaylı bilgi için destek ekibi ile iletişime geçebilirsiniz.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
