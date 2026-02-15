import 'package:flutter/material.dart';

class VPNScreen extends StatefulWidget {
  const VPNScreen({Key? key}) : super(key: key);

  @override
  State<VPNScreen> createState() => _VPNScreenState();
}

class _VPNScreenState extends State<VPNScreen> {
  bool _isConnected = false;
  String _selectedCountry = 'United States';
  
  final List<Map<String, String>> servers = [
    {'country': 'United States', 'flag': '🇺🇸', 'ping': '45ms'},
    {'country': 'United Kingdom', 'flag': '🇬🇧', 'ping': '78ms'},
    {'country': 'Germany', 'flag': '🇩🇪', 'ping': '65ms'},
    {'country': 'Japan', 'flag': '🇯🇵', 'ping': '120ms'},
    {'country': 'Singapore', 'flag': '🇸🇬', 'ping': '98ms'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VPN Service')),
      body: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isConnected 
                  ? [Colors.green.shade700, Colors.green.shade900]
                  : [Colors.grey.shade700, Colors.grey.shade900],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isConnected = !_isConnected),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: _isConnected ? Colors.green : Colors.grey,
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isConnected ? Icons.shield : Icons.shield_outlined,
                        size: 60,
                        color: _isConnected ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isConnected ? 'CONNECTED' : 'DISCONNECTED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isConnected ? _selectedCountry : 'Tap to connect',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(server['flag']!, style: const TextStyle(fontSize: 32)),
                    title: Text(server['country']!),
                    subtitle: Text('Ping: ${server['ping']}'),
                    trailing: Radio<String>(
                      value: server['country']!,
                      groupValue: _selectedCountry,
                      onChanged: (value) => setState(() => _selectedCountry = value!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
