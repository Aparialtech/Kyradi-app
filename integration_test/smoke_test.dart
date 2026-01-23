import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kyradi_app/main.dart' as app;

// Minimal smoke test. This does NOT perform real login; replace TODOs with
// real credentials or mock hooks if available.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('smoke: launch app and reach login screen', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Intro splash should show a login/register CTA; tap login.
    final loginButton = find.textContaining('Giriş');
    if (loginButton.evaluate().isNotEmpty) {
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    // Verify we are on LoginPage (email field present).
    final emailField = find.byType(TextFormField);
    expect(emailField, findsWidgets);

    // TODO: If test credentials available, fill and submit here.
    // Example (replace with real values):
    // await tester.enterText(emailField.at(0), 'user@example.com');
    // final passwordField = find.byType(TextFormField).at(1);
    // await tester.enterText(passwordField, 'password');
    // final submit = find.textContaining('Giriş');
    // await tester.tap(submit);
    // await tester.pumpAndSettle();
    //
    // expect(find.textContaining('KYRADI'), findsWidgets);
  });
}
