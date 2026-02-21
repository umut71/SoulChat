import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';

const List<int> _prizes = [50, 100, 200, 500, 1000, 2000, 5000, 10000];
const int _spinCost = 0;
const int _fullRotation = 5;

class SpinWheelScreen extends ConsumerStatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  ConsumerState<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends ConsumerState<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _canSpin = true;
  int _winPrizeIndex = 0;
  double _endAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final won = _prizes[_winPrizeIndex];
        ref.read(soulCoinProvider.notifier).add(won);
        FirestoreService.saveGameScore('spin_wheel', won);
        setState(() => _canSpin = true);
        _showResult(won);
      }
    });
  }

  void _showResult(int won) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kazandınız!'),
        content: Text('+$won SoulCoin cüzdanınıza eklendi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _spin() {
    if (!_canSpin) return;
    setState(() => _canSpin = false);
    final random = Random();
    _winPrizeIndex = random.nextInt(_prizes.length);
    final segmentAngle = 2 * 3.14159 / _prizes.length;
    _endAngle = _fullRotation * 2 * 3.14159 + (_winPrizeIndex + 0.5) * segmentAngle;
    _animation = Tween<double>(begin: 0, end: _endAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0);
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
        title: const Text('Çarkıfelek'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '$balance SC',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Günlük Çark',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'En fazla 10.000 SoulCoin kazan!',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: _WheelPainter(prizes: _prizes),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_drop_down, size: 48, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSpin ? _spin : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text(_canSpin ? 'ÇEVİR!' : 'Çevriliyor...'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<int> prizes;
  _WheelPainter({required this.prizes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweep = 2 * 3.14159 / prizes.length;
    final colors = [
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.teal,
      Colors.amber,
      Colors.deepOrange,
    ];
    for (var i = 0; i < prizes.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2 + i * sweep,
        sweep,
        true,
        paint,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[i] >= 1000
              ? '${prizes[i] ~/ 1000}K'
              : prizes[i].toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final angle = -3.14159 / 2 + (i + 0.5) * sweep;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.translate(radius * 0.55, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
