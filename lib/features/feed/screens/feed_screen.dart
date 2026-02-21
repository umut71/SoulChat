import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulchat/core/services/firestore_service.dart';
import 'package:soulchat/core/theme/app_theme.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  static void _playTapSound() => SystemSound.play(SystemSoundType.click);

  Future<void> _addPost(BuildContext context) async {
    _playTapSound();
    final textController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Akışa paylaş'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'AI ile yaşadığın anı paylaş...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, textController.text.trim()),
            child: const Text('Paylaş'),
          ),
        ],
      ),
    );
    if (result == null) return;
    if (FirebaseAuth.instance.currentUser == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paylaşım için giriş yapın')));
      }
      return;
    }
    await FirestoreService.addFeedPost(result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paylaşım eklendi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Akış'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addPost(context),
        icon: const Icon(Icons.add),
        label: const Text('Paylaş'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirestoreService.feedStream(limit: 50),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Akış yüklenemedi: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz paylaşım yok',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI Asistan\'daki anlarınızı burada paylaşabilirsiniz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index].data();
              final id = docs[index].id;
              final userName = d['userName'] as String? ?? 'Anonim';
              final text = d['text'] as String? ?? '';
              final imageUrl = d['imageUrl'] as String?;
              final likes = (d['likes'] is int) ? d['likes'] as int : 0;
              final createdAt = d['createdAt'] as Timestamp?;
              final timeStr = createdAt != null
                  ? _formatTime(createdAt.toDate())
                  : '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: _playTapSound,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.secondaryColor.withOpacity(0.3),
                              child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if (timeStr.isNotEmpty) Text(timeStr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (text.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(text, style: const TextStyle(fontSize: 15)),
                        ],
                        if (imageUrl != null && imageUrl.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageUrl.startsWith('http')
                                ? CachedNetworkImage(imageUrl: imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Icon(Icons.smart_toy, size: 80, color: Colors.grey))
                                : const Icon(Icons.image, size: 80),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.favorite_border, size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Text('$likes', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static String _formatTime(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return '${d.day}.${d.month}.${d.year}';
  }
}
