import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soulchat/core/services/gemini_chat_service.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/shared/providers/soulcoin_provider.dart';

const int _rewardPerCorrect = 25;

/// Ücretsiz mod: API yokken kullanılan yerel soru havuzu.
final _localQuestions = [
  ('Türkiye\'nin başkenti neresidir?', ['A) İstanbul', 'B) Ankara', 'C) İzmir', 'D) Bursa'], 'B'),
  ('Güneş sisteminde kaç gezegen vardır?', ['A) 7', 'B) 8', 'C) 9', 'D) 10'], 'B'),
  ('İnsan vücudunda kaç kemik vardır?', ['A) 186', 'B) 206', 'C) 226', 'D) 246'], 'B'),
  ('Dünyanın en uzun nehri hangisidir?', ['A) Amazon', 'B) Nil', 'C) Mississippi', 'D) Yangtze'], 'B'),
  ('Hangi gezegen Kırmızı Gezegen olarak bilinir?', ['A) Venüs', 'B) Mars', 'C) Jüpiter', 'D) Satürn'], 'B'),
  ('Türkiye\'nin en büyük gölü hangisidir?', ['A) Tuz Gölü', 'B) Van Gölü', 'C) Eğirdir', 'D) Beyşehir'], 'B'),
  ('Bir yılda kaç ay vardır?', ['A) 10', 'B) 11', 'C) 12', 'D) 13'], 'C'),
  ('Suyun kimyasal formülü nedir?', ['A) CO2', 'B) H2O', 'C) O2', 'D) NaCl'], 'B'),
];

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool _loading = false;
  String _question = '';
  List<String> _options = [];
  String _correct = '';
  int _score = 0;

  Future<void> _loadQuestion([String? category]) async {
    setState(() {
      _loading = true;
      _question = '';
      _options = [];
      _correct = '';
    });
    try {
      final prompt = category != null
          ? 'Generate one multiple choice trivia question in the category "$category". '
            'Reply with only: Question: ... then A) ... B) ... C) ... D) ... then Answer: A or B or C or D.'
          : 'Generate one multiple choice general knowledge trivia question. '
            'Reply with only: Question: ... then A) ... B) ... C) ... D) ... then Answer: A or B or C or D.';
      final answer = await GeminiChatService().sendMessage(prompt);
      final q = answer.replaceAll(RegExp(r'\\n'), '\n').trim();
      String question = '';
      final options = <String>[];
      String correct = 'A';
      final lines = q.split('\n');
      for (final line in lines) {
        final l = line.trim();
        if (l.toUpperCase().startsWith('QUESTION:')) {
          question = l.replaceFirst(RegExp(r'^question:\s*', caseSensitive: false), '').trim();
        } else if (RegExp(r'^[A-D]\)').hasMatch(l)) {
          options.add(l);
        } else if (l.toUpperCase().startsWith('ANSWER:')) {
          final m = RegExp(r'[A-D]').firstMatch(l);
          if (m != null) correct = m.group(0)!;
        }
      }
      if (question.isEmpty || options.length < 2) {
        final local = _localQuestions[DateTime.now().millisecond % _localQuestions.length];
        question = local.$1;
        options.clear();
        options.addAll(local.$2);
        correct = local.$3;
      } else if (question.isEmpty && q.isNotEmpty) {
        question = q.length > 200 ? q.substring(0, 200) : q;
      }
      if (options.length < 2) {
        options.addAll(['A) True', 'B) False']);
      }
      setState(() {
        _question = question.isEmpty ? 'Soru yükleniyor...' : question;
        _options = options;
        _correct = correct.toUpperCase();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _question = 'Soru alınamadı. Tekrar dene.';
        _options = ['A) Tekrar dene', 'B) Çık'];
        _correct = 'A';
      });
    }
  }

  void _onAnswer(String letter) {
    if (_correct.isEmpty) return;
    final isCorrect = letter.toUpperCase() == _correct;
    if (isCorrect) {
      ref.read(soulCoinProvider.notifier).add(_rewardPerCorrect);
      setState(() => _score += _rewardPerCorrect);
      FirestoreService.saveGameScore('quiz', _score + _rewardPerCorrect, extra: {'reward': _rewardPerCorrect});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doğru! +$_rewardPerCorrect SoulCoin')),
      );
      _loadQuestion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yanlış! Doğru cevap: $_correct')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Genel Kültür', 'icon': Icons.lightbulb, 'color': Colors.blue},
      {'name': 'Bilim', 'icon': Icons.science, 'color': Colors.green},
      {'name': 'Tarih', 'icon': Icons.history_edu, 'color': Colors.orange},
      {'name': 'Coğrafya', 'icon': Icons.public, 'color': Colors.teal},
      {'name': 'Spor', 'icon': Icons.sports_soccer, 'color': Colors.red},
      {'name': 'Sinema', 'icon': Icons.movie, 'color': Colors.purple},
    ];
    final balance = ref.watch(soulCoinProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Bilgi Yarışması'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: Text('$balance SC', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          IconButton(icon: const Icon(Icons.leaderboard), onPressed: () => context.push('/leaderboard')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_question.isEmpty && !_loading) ...[
              const Text('Kategori seç veya genel soru başlat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final c = categories[index];
                  return Card(
                    child: InkWell(
                      onTap: () => _loadQuestion(c['name'] as String),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(c['icon'] as IconData, size: 40, color: c['color'] as Color),
                            const SizedBox(height: 8),
                            Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : () => _loadQuestion(),
                  icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.play_arrow),
                  label: Text(_loading ? 'Soru geliyor...' : 'Rastgele soru başlat (+$_rewardPerCorrect SC)'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ),
            ] else if (_loading) ...[
              const Center(child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              )),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(_question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(_options.length, (i) {
                final opt = _options[i];
                final letter = opt.isNotEmpty ? opt[0].toUpperCase() : '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _onAnswer(letter),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(opt),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => setState(() => _question = ''),
                icon: const Icon(Icons.refresh),
                label: const Text('Yeni kategori / çık'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
