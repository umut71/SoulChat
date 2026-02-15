import 'package:flutter/material.dart';

class MusicRecordingScreen extends StatefulWidget {
  const MusicRecordingScreen({Key? key}) : super(key: key);

  @override
  State<MusicRecordingScreen> createState() => _MusicRecordingScreenState();
}

class _MusicRecordingScreenState extends State<MusicRecordingScreen> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Recording Studio')),
      body: Column(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Waveform Display', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: Icon(Icons.stop, size: 40), onPressed: () {}),
              FloatingActionButton.large(
                onPressed: () => setState(() => isRecording = !isRecording),
                backgroundColor: isRecording ? Colors.red : Colors.blue,
                child: Icon(isRecording ? Icons.pause : Icons.fiber_manual_record, size: 40),
              ),
              IconButton(icon: Icon(Icons.save, size: 40), onPressed: () {}),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
