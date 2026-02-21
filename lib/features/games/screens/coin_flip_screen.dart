import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';

class CoinFlipScreen extends ConsumerStatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  ConsumerState<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends ConsumerState<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  static const int _betAmount = 10;
  static const int _winAmount = 20;
  late AnimationController _controller;
  bool _flipping = false;
  bool? _lastResult;
  String _lastSide = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.addStatusListener((_) {});
  }

  void _showResult(int won) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(won > 0 ? 'Kazandınız!' : 'Kaybettiniz'),
        content: Text(
          won > 0
              ? 'Yazı! +$won SoulCoin'
              : 'Tura. Bir daha deneyin!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _flip() async {
    final notifier = ref.read(soulCoinProvider.notifier);
    if (!notifier.canSpend(_betAmount) || _flipping) return;
    final ok = await notifier.spend(_betAmount);
    if (!ok) return;
    setState(() {
      _flipping = true;
      _lastResult = Random().nextBool();
    });
    _controller.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _controller.stop();
    setState(() {
      _flipping = false;
      _lastSide = _lastResult == true ? 'YAZI' : 'TURA';
    });
    final won = _lastResult == true ? _winAmount : 0;
    if (won > 0) {
      ref.read(soulCoinProvider.notifier).add(won);
      FirestoreService.saveGameScore('coin_flip', won);
    }
    _showResult(won);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(soulCoinProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yazı-Tura'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text('$balance SC', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bahis: $_betAmount SC • Kazanırsan: $_winAmount SC',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateX(_controller.value * 3.14159 * 4),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.shade700,
                        boxShadow: [
                          BoxShadow(color: Colors.brown.shade300, blurRadius: 12, spreadRadius: 2),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _flipping ? '?' : (_lastSide.isEmpty ? '?' : _lastSide),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _flipping ? null : () => _flip(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text(_flipping ? 'Atılıyor...' : 'PARA AT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
