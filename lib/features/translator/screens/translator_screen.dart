import 'package:flutter/material.dart';
import 'package:soulchat/core/services/google_cloud_service.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final _inputController = TextEditingController();
  String _result = '';
  bool _loading = false;
  String _targetLangCode = 'tr';
  String _sourceLangCode = 'en';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final translated = await GoogleCloudService.translate(
        text,
        target: _targetLangCode,
        source: _sourceLangCode,
      );
      setState(() {
        _result = translated;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translator - 90+ Languages')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _inputController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Enter text to translate...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _sourceLangCode,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'tr', child: Text('Turkish')),
                      DropdownMenuItem(value: 'de', child: Text('German')),
                      DropdownMenuItem(value: 'fr', child: Text('French')),
                      DropdownMenuItem(value: 'es', child: Text('Spanish')),
                    ],
                    onChanged: (v) => setState(() => _sourceLangCode = v ?? 'en'),
                  ),
                ),
                const Icon(Icons.arrow_forward),
                Expanded(
                  child: DropdownButton<String>(
                    value: _targetLangCode,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'tr', child: Text('Turkish')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'de', child: Text('German')),
                      DropdownMenuItem(value: 'fr', child: Text('French')),
                      DropdownMenuItem(value: 'es', child: Text('Spanish')),
                    ],
                    onChanged: (v) => setState(() => _targetLangCode = v ?? 'tr'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _translate,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.translate),
              label: Text(_loading ? 'Translating...' : 'Translate'),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(_result, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
