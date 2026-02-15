import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AIToolsScreen extends StatelessWidget {
  const AIToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tools'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.circleInfo),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildAITool(
            context,
            'AI Chatbot',
            'Chat with intelligent AI',
            FontAwesomeIcons.robot,
            Colors.blue,
            () {},
          ),
          _buildAITool(
            context,
            'Image Generator',
            'Create AI images',
            FontAwesomeIcons.wand,
            Colors.purple,
            () {},
          ),
          _buildAITool(
            context,
            'Voice Cloning',
            'Clone any voice',
            FontAwesomeIcons.microphone,
            Colors.green,
            () {},
          ),
          _buildAITool(
            context,
            'Text to Speech',
            'Convert text to voice',
            FontAwesomeIcons.volumeHigh,
            Colors.orange,
            () {},
          ),
          _buildAITool(
            context,
            'Translation',
            'AI powered translation',
            FontAwesomeIcons.language,
            Colors.red,
            () {},
          ),
          _buildAITool(
            context,
            'Code Assistant',
            'AI coding help',
            FontAwesomeIcons.code,
            Colors.teal,
            () {},
          ),
          _buildAITool(
            context,
            'Content Writer',
            'Generate content',
            FontAwesomeIcons.pen,
            Colors.pink,
            () {},
          ),
          _buildAITool(
            context,
            'Video Summary',
            'Summarize videos',
            FontAwesomeIcons.video,
            Colors.indigo,
            () {},
          ),
          _buildAITool(
            context,
            'Background Remover',
            'Remove backgrounds',
            FontAwesomeIcons.scissors,
            Colors.amber,
            () {},
          ),
          _buildAITool(
            context,
            'Face Swap',
            'Swap faces in photos',
            FontAwesomeIcons.faceLaugh,
            Colors.cyan,
            () {},
          ),
          _buildAITool(
            context,
            'Music Generator',
            'Create AI music',
            FontAwesomeIcons.music,
            Colors.deepPurple,
            () {},
          ),
          _buildAITool(
            context,
            'Lyrics Writer',
            'Generate song lyrics',
            FontAwesomeIcons.scroll,
            Colors.lime,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAITool(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
