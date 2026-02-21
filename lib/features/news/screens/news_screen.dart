import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
        actions: [IconButton(icon: const FaIcon(FontAwesomeIcons.filter), onPressed: () {})],
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.primaries[index % Colors.primaries.length], Colors.primaries[(index + 1) % Colors.primaries.length]]),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Breaking News ${index + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Güncel gelişmeler ve öne çıkan haberler burada. Detaylar için okuyun.'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.clock, size: 12),
                        const SizedBox(width: 4),
                        Text('${index + 1}h ago'),
                        const Spacer(),
                        TextButton.icon(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.share, size: 14), label: const Text('Share')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
