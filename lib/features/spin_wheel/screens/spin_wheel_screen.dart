import 'package:flutter/material.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({Key? key}) : super(key: key);

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen> {
  bool isSpinning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spin & Win')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Daily Spin', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Win up to 10,000 SoulCoins!', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 40),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.orange, Colors.red, Colors.purple, Colors.blue, Colors.green, Colors.yellow]),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5)],
              ),
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Stack(
                    children: [
                      Center(child: Text('WHEEL', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey.shade300))),
                      ...List.generate(8, (index) {
                        final prizes = ['100', '500', '1K', '2K', '5K', '10K', '50', '200'];
                        return Positioned(
                          top: 140 - 100 * (index % 2 == 0 ? 1 : 0.7),
                          left: 140 + 100 * (index % 2 == 0 ? 0.7 : 1) * (index < 4 ? 1 : -1),
                          child: Text(prizes[index], style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: isSpinning ? null : () => setState(() => isSpinning = true),
              child: Text(isSpinning ? 'Spinning...' : 'SPIN NOW!'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text('Next spin available in: 23:45:12', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
