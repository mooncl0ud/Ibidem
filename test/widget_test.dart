import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ibidem/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: IbidemApp()));

    // Verify that the app starts.
    expect(find.text('IBIDEM'), findsOneWidget); // Splash screen text
  });
}
