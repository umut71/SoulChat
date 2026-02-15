import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MusicStudioScreen extends StatefulWidget {
  const MusicStudioScreen({super.key});

  @override
  State<MusicStudioScreen> createState() => _MusicStudioScreenState();
}

class _MusicStudioScreenState extends State<MusicStudioScreen> {
  bool _isRecording = false;
  bool _isPlaying = false;
  double _tempo = 120;
  String _selectedInstrument = 'Piano';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Music Studio'),
        actions: [
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
      body: Column(
        children: [
          _buildWaveformDisplay(),
          _buildControls(),
          _buildInstrumentPicker(),
          Expanded(child: _buildPianoRoll()),
          _buildToolbar(),
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
              _isRecording ? FontAwesomeIcons.stop : FontAwesomeIcons.record,
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
