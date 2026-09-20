import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/core/di/app_dependencies.dart';
import 'package:taxratesystem_mobile/data/repositories/in_memory_history_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_auth_repository.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/main.dart';
import 'package:taxratesystem_mobile/auth/login_screen.dart';
import 'package:taxratesystem_mobile/auth/forgot_password_screen.dart';
import 'package:taxratesystem_mobile/auth/register_screen.dart';

/// Pumps the app and waits out the splash timer.
Future<void> pumpAppToLogin(
  WidgetTester tester, {
  AppDependencies? dependencies,
}) async {
  await tester.pumpWidget(MyApp(dependencies: dependencies));
  await tester.pump(const Duration(milliseconds: AppDimens.splashDurationMs));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Login screen shows required errors when fields are empty',
      (WidgetTester tester) async {
    await pumpAppToLogin(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Hello, Welcome back!'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('full flow taps', (WidgetTester tester) async {
    await pumpAppToLogin(tester);

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
    // The redesigned signup has no top-right back arrow; the "Sign in" line
    // under the CTA is the way back.
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(ForgotPasswordScreen), findsNothing);
  });

  testWidgets('Dependencies can be injected and drive the sign-in error state',
      (WidgetTester tester) async {
    final AppDependencies dependencies = AppDependencies(
      historyRepository: InMemoryHistoryRepository(),
      authRepository: LocalAuthRepository(),
    );
    addTearDown(dependencies.dispose);

    await pumpAppToLogin(tester, dependencies: dependencies);

    await tester.enterText(find.byType(TextField).first, 'not-an-email');
    await tester.enterText(find.byType(TextField).last, 'secret123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Invalid credentials render the controller's error state, and the user
    // stays on the login screen instead of reaching the home shell.
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(dependencies.sessionController.isSignedIn, isFalse);
    expect(dependencies.sessionController.errorMessage, isNotNull);
  });

  testWidgets('Signing in navigates to the home shell through named routes',
      (WidgetTester tester) async {
    final AppDependencies dependencies = AppDependencies();
    addTearDown(dependencies.dispose);

    await pumpAppToLogin(tester, dependencies: dependencies);

    await tester.enterText(find.byType(TextField).first, 'maria@example.com');
    await tester.enterText(find.byType(TextField).last, 'secret123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(dependencies.sessionController.user, isNotNull);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Calculator rejects an invalid amount with a validation message',
      (WidgetTester tester) async {
    final AppDependencies dependencies = AppDependencies();
    addTearDown(dependencies.dispose);

    await pumpAppToLogin(tester, dependencies: dependencies);
    await tester.enterText(find.byType(TextField).first, 'maria@example.com');
    await tester.enterText(find.byType(TextField).last, 'secret123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Calculator'));
    await tester.pumpAndSettle();

    // The dropdown is driven by TaxTypeId.values, so the default type is a
    // domain value rather than a magic string.
    expect(find.text(TaxTypeId.personalIncome.label), findsOneWidget);

    await tester.tap(find.text('Calculate Tax'));
    await tester.pumpAndSettle();

    // No result screen was pushed; the field shows the validation error and the
    // user stays on the calculator form.
    expect(find.text('Enter a valid taxable amount'), findsOneWidget);
    expect(find.text('Calculation Result'), findsNothing);
  });
}
