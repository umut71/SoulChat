import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Mobil: geçici ses dosyası yolu döner.
Future<String?> getTempRecordingPath(String prefix) async {
  final dir = await getTemporaryDirectory();
  return '${dir.path}/${prefix}_${DateTime.now().millisecondsSinceEpoch}.wav';
}

/// Mobil: dosyayı siler.
Future<void> deleteTempFile(String path) async {
  try {
    await File(path).delete();
  } catch (_) {}
}
