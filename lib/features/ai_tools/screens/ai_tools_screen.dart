import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/core/services/gemini_chat_service.dart';

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
            FontAwesomeIcons.wandMagicSparkles,
            Colors.purple,
            () => _showImageGeneratorDialog(context),
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

  static void _showImageGeneratorDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Image Generator (Gemini)'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Describe the image to generate...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final prompt = controller.text.trim();
              if (prompt.isEmpty) return;
              Navigator.pop(ctx);
              final scaffoldContext = context;
              showDialog(
                context: scaffoldContext,
                barrierDismissible: false,
                builder: (c) => const Center(child: CircularProgressIndicator()),
              );
              try {
                final url = await GeminiChatService().generateImage(prompt);
                if (!scaffoldContext.mounted) return;
                Navigator.pop(scaffoldContext);
                await showDialog(
                  context: scaffoldContext,
                  builder: (c) => AlertDialog(
                    title: const Text('Görsel'),
                    content: url.startsWith('http') || url.startsWith('data:')
                        ? CachedNetworkImage(imageUrl: url, fit: BoxFit.contain)
                        : Text(url),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                if (!scaffoldContext.mounted) return;
                Navigator.pop(scaffoldContext);
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Generate'),
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
