import 'package:flutter_test/flutter_test.dart';

import 'package:apps_wa/main.dart';

void main() {
  testWidgets('Home screen shows chat list', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Andi'), findsOneWidget);
  });
}
