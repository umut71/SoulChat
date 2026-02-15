import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isSpeakerOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video (full screen)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple.shade900, Colors.blue.shade900],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 120, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Connecting...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          // Local video (small preview)
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.grey.shade700,
                  child: const Center(
                    child: Icon(Icons.person, size: 60, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),
          // Controls at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  color: _isMuted ? Colors.red : Colors.white,
                  onTap: () => setState(() => _isMuted = !_isMuted),
                ),
                _buildControlButton(
                  icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
                  color: _isVideoOff ? Colors.red : Colors.white,
                  onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                ),
                _buildControlButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onTap: () => Navigator.pop(context),
                  size: 70,
                ),
                _buildControlButton(
                  icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                ),
                _buildControlButton(
                  icon: Icons.switch_camera,
                  color: Colors.white,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color == Colors.red ? Colors.red : Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color == Colors.white ? Colors.white : Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
