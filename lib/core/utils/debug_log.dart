import 'dart:convert';
import 'package:http/http.dart' as http;

// #region agent log
const String _kIngest =
    'http://127.0.0.1:7246/ingest/e67c72a8-4a67-438d-89c1-986d94a4c3d0';

void _ingest(Map<String, dynamic> payload) {
  try {
    http.post(
      Uri.parse(_kIngest),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        ...payload,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }),
    ).catchError((_) {});
  } catch (_) {}
}
// #endregion

/// Call from instrumented code. Do not log secrets.
void debugLog({
  required String location,
  required String message,
  Map<String, dynamic>? data,
  String? hypothesisId,
  String? runId,
}) {
  final map = <String, dynamic>{
    'location': location,
    'message': message,
    if (data != null) 'data': data,
    if (hypothesisId != null) 'hypothesisId': hypothesisId,
    if (runId != null) 'runId': runId,
  };
  _ingest(map);
}
