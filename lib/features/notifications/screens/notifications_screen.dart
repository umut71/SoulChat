import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // Mark all as read
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          final types = ['message', 'friend', 'like', 'comment', 'reward', 'game'];
          final type = types[index % types.length];
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getColorForType(type),
              child: Icon(_getIconForType(type), color: Colors.white, size: 20),
            ),
            title: Text(_getTitleForType(type, index)),
            subtitle: Text(_getSubtitleForType(type)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${index + 1}m ago',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (index < 3)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () {
              // Handle notification tap
            },
          );
        },
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'message':
        return Colors.blue;
      case 'friend':
        return Colors.green;
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.purple;
      case 'reward':
        return Colors.orange;
      case 'game':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'message':
        return Icons.message;
      case 'friend':
        return Icons.person_add;
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'reward':
        return Icons.card_giftcard;
      case 'game':
        return Icons.sports_esports;
      default:
        return Icons.notifications;
    }
  }

  String _getTitleForType(String type, int index) {
    switch (type) {
      case 'message':
        return 'New message from User ${index + 1}';
      case 'friend':
        return 'User ${index + 1} accepted your friend request';
      case 'like':
        return 'User ${index + 1} liked your story';
      case 'comment':
        return 'User ${index + 1} commented on your post';
      case 'reward':
        return 'You earned ${(index + 1) * 10} SoulCoins!';
      case 'game':
        return 'You won the tournament!';
      default:
        return 'Notification';
    }
  }

  String _getSubtitleForType(String type) {
    switch (type) {
      case 'message':
        return 'Tap to read the message';
      case 'friend':
        return 'You are now friends';
      case 'like':
        return 'Your story got a like';
      case 'comment':
        return 'Check out what they said';
      case 'reward':
        return 'Daily login reward';
      case 'game':
        return 'Congratulations!';
      default:
        return '';
    }
  }
}
