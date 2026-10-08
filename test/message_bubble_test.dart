import 'package:apps_wa/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows message and time in a sent message bubble', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            message: 'Hello',
            time: '16:20',
            isMe: true,
          ),
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('16:20'), findsOneWidget);

    final alignment = tester.widget<Align>(find.byType(Align));
    expect(alignment.alignment, Alignment.centerRight);

    final bubble = tester.widget<Container>(
      find.ancestor(
        of: find.text('Hello'),
        matching: find.byType(Container),
      ).first,
    );
    expect(
      (bubble.decoration! as BoxDecoration).color,
      const Color(0xFFD9FDD3),
    );
  });

  testWidgets('aligns received message bubbles to the left', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            message: 'Hi',
            time: '16:21',
            isMe: false,
          ),
        ),
      ),
    );

    final alignment = tester.widget<Align>(find.byType(Align));
    expect(alignment.alignment, Alignment.centerLeft);
    expect(find.text('Hi'), findsOneWidget);
    expect(find.text('16:21'), findsOneWidget);
  });
}
