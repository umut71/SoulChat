import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soulchat/main.dart';

void main() {
  testWidgets('SoulChat app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoulChatApp());

    // Verify that the app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
