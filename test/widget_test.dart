import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taxratesystem_mobile/main.dart';
import 'package:taxratesystem_mobile/auth/login_screen.dart';
import 'package:taxratesystem_mobile/auth/forgot_password_screen.dart';
import 'package:taxratesystem_mobile/auth/register_screen.dart';

void main() {
  testWidgets('Login screen shows required errors when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Hello, Welcome back!'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('full flow taps', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    // toggle password eye
    await tester.tap(find.byType(TextField).last);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    // navigate to forgot password and back
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Back to Login'));
    await tester.tap(find.text('Back to Login'));
    await tester.pumpAndSettle();

    // navigate to register and back
    await tester.ensureVisible(find.text('Create new account'));
    await tester.tap(find.text('Create new account'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    await tester.ensureVisible(find.byIcon(Icons.arrow_back));
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(ForgotPasswordScreen), findsNothing);
  });
}
