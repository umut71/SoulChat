import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Istanbul', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Tuesday, March 15', style: TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              const FaIcon(FontAwesomeIcons.cloudSun, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text('22°C', style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const Text('Partly Cloudy', style: TextStyle(color: Colors.white70, fontSize: 20), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeatherStat('Wind', '12 km/h', FontAwesomeIcons.wind),
                  _buildWeatherStat('Humidity', '65%', FontAwesomeIcons.droplet),
                  _buildWeatherStat('Pressure', '1013 hPa', FontAwesomeIcons.gauge),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text('7-Day Forecast', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ...List.generate(7, (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index], style: const TextStyle(color: Colors.white)),
                          const FaIcon(FontAwesomeIcons.cloudSun, color: Colors.white, size: 20),
                          Text('${22 + index}°C', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value, IconData icon) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
