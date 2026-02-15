import 'package:flutter/material.dart';

class VoiceTranslatorScreen extends StatefulWidget {
  const VoiceTranslatorScreen({Key? key}) : super(key: key);

  @override
  State<VoiceTranslatorScreen> createState() => _VoiceTranslatorScreenState();
}

class _VoiceTranslatorScreenState extends State<VoiceTranslatorScreen> {
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Translator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() => isListening = !isListening),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isListening ? [Colors.red, Colors.orange] : [Colors.blue, Colors.purple],
                  ),
                ),
                child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 70, color: Colors.white),
              ),
            ),
            SizedBox(height: 24),
            Text(isListening ? 'Listening...' : 'Tap to speak', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
