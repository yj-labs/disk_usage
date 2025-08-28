// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:disk_usage_example/main.dart';

void main() {
  testWidgets('Verify disk space information display', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for async operations to complete
    await tester.pumpAndSettle();

    // Verify that disk space information is displayed.
    expect(find.text('Disk Space Information'), findsOneWidget);
    expect(find.text('Total Space:'), findsOneWidget);
    expect(find.text('Free Space:'), findsOneWidget);

    // Verify refresh button exists
    expect(find.text('Refresh Disk Space'), findsOneWidget);
  });
}
