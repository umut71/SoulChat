import 'package:flutter/material.dart';

class FlashlightCompassScreen extends StatefulWidget {
  const FlashlightCompassScreen({Key? key}) : super(key: key);

  @override
  State<FlashlightCompassScreen> createState() => _FlashlightCompassScreenState();
}

class _FlashlightCompassScreenState extends State<FlashlightCompassScreen> {
  bool flashlightOn = false;
  double brightness = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashlight & Compass')),
      body: Column(
        children: [
          // Flashlight section
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: flashlightOn ? Colors.yellow.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => flashlightOn = !flashlightOn),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: flashlightOn ? Colors.yellow : Colors.grey,
                          shape: BoxShape.circle,
                          boxShadow: flashlightOn
                              ? [BoxShadow(color: Colors.yellow, blurRadius: 30, spreadRadius: 10)]
                              : [],
                        ),
                        child: Icon(
                          flashlightOn ? Icons.flashlight_on : Icons.flashlight_off,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(flashlightOn ? 'ON' : 'OFF', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Icon(Icons.brightness_low),
                          Expanded(
                            child: Slider(
                              value: brightness,
                              min: 0,
                              max: 100,
                              onChanged: (value) => setState(() => brightness = value),
                            ),
                          ),
                          Icon(Icons.brightness_high),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Compass section
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade700]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(top: 10, child: Text('N', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold))),
                          Positioned(bottom: 10, child: Text('S', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                          Positioned(left: 10, child: Text('W', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                          Positioned(right: 10, child: Text('E', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                          Icon(Icons.navigation, size: 60, color: Colors.red),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('0°', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                    Text('North', style: TextStyle(color: Colors.white70, fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
