import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({super.key});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  double _brightness = 0;
  double _contrast = 0;
  double _saturation = 0;
  String _selectedTool = 'adjust';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Image Editor'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save', style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildImageCanvas()),
          _buildToolSelector(),
          _buildToolOptions(),
        ],
      ),
    );
  }

  Widget _buildImageCanvas() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.blue.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.image, size: 48, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Your image will appear here',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolSelector() {
    final tools = [
      ('adjust', FontAwesomeIcons.sliders, 'Adjust'),
      ('filter', FontAwesomeIcons.wand, 'Filters'),
      ('crop', FontAwesomeIcons.crop, 'Crop'),
      ('text', FontAwesomeIcons.font, 'Text'),
      ('sticker', FontAwesomeIcons.faceSmile, 'Stickers'),
      ('draw', FontAwesomeIcons.paintbrush, 'Draw'),
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tools.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final tool = tools[index];
          final isSelected = _selectedTool == tool.$1;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTool = tool.$1;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(tool.$2, color: Colors.white, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    tool.$3,
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

  Widget _buildToolOptions() {
    if (_selectedTool == 'adjust') {
      return _buildAdjustOptions();
    } else if (_selectedTool == 'filter') {
      return _buildFilterOptions();
    }
    return const SizedBox(height: 100);
  }

  Widget _buildAdjustOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSlider('Brightness', _brightness, (value) {
            setState(() => _brightness = value);
          }),
          _buildSlider('Contrast', _contrast, (value) {
            setState(() => _contrast = value);
          }),
          _buildSlider('Saturation', _saturation, (value) {
            setState(() => _saturation = value);
          }),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text(value.toStringAsFixed(1), style: const TextStyle(color: Colors.white70)),
          ],
        ),
        Slider(
          value: value,
          min: -100,
          max: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFilterOptions() {
    final filters = ['Original', 'Vintage', 'B&W', 'Warm', 'Cool', 'Dramatic'];
    
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.primaries[index % Colors.primaries.length],
                    Colors.primaries[(index + 1) % Colors.primaries.length],
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                filters[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
