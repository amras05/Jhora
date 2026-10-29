import 'package:flutter_test/flutter_test.dart';
import 'package:jhora_mobile/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JhoraApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(JhoraApp), findsOneWidget);
  });
}
