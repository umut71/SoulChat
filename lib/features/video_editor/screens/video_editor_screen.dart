import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  bool _isPlaying = false;
  double _currentPosition = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Video Editor'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Export', style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildVideoPreview()),
          _buildTimelineControls(),
          _buildTimeline(),
          _buildEditingTools(),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: FaIcon(
              _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
              size: 48,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => _isPlaying = !_isPlaying);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.scissors, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.copy, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rotateRight, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Timeline track
          Positioned.fill(
            child: Row(
              children: List.generate(
                10,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Playhead
          Positioned(
            left: _currentPosition * MediaQuery.of(context).size.width - 32,
            child: Container(
              width: 2,
              height: 100,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditingTools() {
    final tools = [
      ('Trim', FontAwesomeIcons.scissors),
      ('Split', FontAwesomeIcons.divide),
      ('Speed', FontAwesomeIcons.gauge),
      ('Music', FontAwesomeIcons.music),
      ('Text', FontAwesomeIcons.font),
      ('Filter', FontAwesomeIcons.wand),
      ('Transition', FontAwesomeIcons.shuffle),
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tools.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final tool = tools[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(tool.$2, color: Colors.white, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    tool.$1,
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
}
