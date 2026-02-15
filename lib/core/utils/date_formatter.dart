import 'package:intl/intl.dart';

class DateFormatter {
  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat.Hm().format(dateTime); // 14:30
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(dateTime); // Mon, Tue, etc.
    } else {
      return DateFormat.MMMd().format(dateTime); // Jan 15
    }
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.MMMd().format(dateTime);
    }
  }

  static String formatFullDate(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime); // January 15, 2024
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_Hm().format(dateTime); // Jan 15, 2024 14:30
  }
}
