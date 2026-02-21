import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/core/constants/soulcoin_costs.dart';
import 'package:soulchat/core/services/music_studio_service.dart';
import 'package:soulchat/core/services/system_architect_service.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';

class MusicStudioScreen extends ConsumerStatefulWidget {
  const MusicStudioScreen({super.key});

  @override
  ConsumerState<MusicStudioScreen> createState() => _MusicStudioScreenState();
}

class _MusicStudioScreenState extends ConsumerState<MusicStudioScreen> {
  bool _isRecording = false;
  bool _isPlaying = false;
  double _tempo = 120;
  String _selectedInstrument = 'Piano';
  final _themeController = TextEditingController();
  bool _generating = false;
  MusicStudioResult? _lastResult;

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  Future<void> _generateFromTheme() async {
    final theme = _themeController.text.trim();
    if (theme.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir tema veya duygu yazın.')),
      );
      return;
    }
    if (!ref.read(soulCoinProvider.notifier).canSpend(SoulCoinCosts.songGeneration)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şarkı oluşturmak için ${SoulCoinCosts.songGeneration} SoulCoin gerekir')),
      );
      return;
    }
    final ok = await ref.read(soulCoinProvider.notifier).spend(SoulCoinCosts.songGeneration);
    if (!ok) return;
    setState(() => _generating = true);
    try {
      final result = await MusicStudioService.generateFromTheme(theme);
      if (!mounted) return;
      setState(() {
        _lastResult = result;
        _generating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    } catch (e, st) {
      ref.read(soulCoinProvider.notifier).add(SoulCoinCosts.songGeneration);
      if (!mounted) return;
      setState(() => _generating = false);
      await SystemArchitectService.handleErrorAndNotify(
        context,
        module: 'Müzik',
        error: e,
        stackTrace: st?.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(soulCoinProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Müzik Stüdyosu'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: Text('$balance SC', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.floppyDisk),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildThemeGenerateCard(),
            _buildWaveformDisplay(),
          _buildControls(),
          _buildInstrumentPicker(),
          SizedBox(height: 200, child: _buildPianoRoll()),
          _buildToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeGenerateCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Temaya göre şarkı oluştur',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _themeController,
            decoration: InputDecoration(
              hintText: 'Örn: Yaz akşamı, hüzünlü piyano...',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A2E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _generating ? null : _generateFromTheme,
              icon: _generating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.music_note),
              label: Text(_generating ? 'Oluşturuluyor...' : 'Şarkı oluştur (${SoulCoinCosts.songGeneration} SC)'),
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
            ),
          ),
          if (_lastResult != null) ...[
            const SizedBox(height: 12),
            Text(_lastResult!.message, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _buildWaveformDisplay() {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF)),
      ),
      child: CustomPaint(
        painter: WaveformPainter(),
        child: const Center(
          child: Text(
            '00:00 / 00:00',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: FaIcon(
              _isRecording ? FontAwesomeIcons.stop : FontAwesomeIcons.circleDot,
              color: _isRecording ? Colors.red : Colors.white,
            ),
            iconSize: 32,
            onPressed: () {
              setState(() {
                _isRecording = !_isRecording;
              });
            },
          ),
          IconButton(
            icon: FaIcon(
              _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
              color: Colors.white,
            ),
            iconSize: 32,
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.backward, color: Colors.white),
            iconSize: 32,
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.forward, color: Colors.white),
            iconSize: 32,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumentPicker() {
    final instruments = ['Piano', 'Guitar', 'Drums', 'Bass', 'Synth', 'Violin'];
    
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: instruments.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final instrument = instruments[index];
          final isSelected = _selectedInstrument == instrument;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedInstrument = instrument;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF6C63FF) : Colors.grey.shade700,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getInstrumentIcon(instrument),
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    instrument,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPianoRoll() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: 49,
        itemBuilder: (context, index) {
          final row = index ~/ 7;
          final isBlackKey = [1, 3, 5, 6, 8].contains(index % 7);
          
          return GestureDetector(
            onTap: () {
              // Play note
            },
            child: Container(
              decoration: BoxDecoration(
                color: isBlackKey ? Colors.grey.shade800 : Colors.white,
                border: Border.all(color: Colors.grey.shade600),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(top: BorderSide(color: Color(0xFF6C63FF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tempo', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('${_tempo.toInt()} BPM', style: const TextStyle(color: Colors.white)),
            ],
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.sliders, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.music, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.waveSquare, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  IconData _getInstrumentIcon(String instrument) {
    switch (instrument) {
      case 'Piano':
        return FontAwesomeIcons.music;
      case 'Guitar':
        return FontAwesomeIcons.guitar;
      case 'Drums':
        return FontAwesomeIcons.drum;
      case 'Bass':
        return FontAwesomeIcons.music;
      case 'Synth':
        return FontAwesomeIcons.waveSquare;
      case 'Violin':
        return FontAwesomeIcons.music;
      default:
        return FontAwesomeIcons.music;
    }
  }
}

class WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (var i = 0; i < size.width; i += 5) {
      final y = size.height / 2 + (i % 20 - 10);
      path.lineTo(i.toDouble(), y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
