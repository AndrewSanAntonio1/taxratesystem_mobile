import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taxratesystem_mobile/auth/forgot_password_screen.dart';
import 'package:taxratesystem_mobile/auth/new_password_screen.dart';
import 'package:taxratesystem_mobile/auth/password_reset_otp_screen.dart';
import 'package:taxratesystem_mobile/auth/register_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/core/di/app_dependencies.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';

/// Hosts a screen on the app's real routing table — with the dependency scope
/// installed above it, exactly as the app root does — so a tap that pushes a
/// route resolves exactly as it does in the app, including screens that read
/// the scope (login does, once a flow lands there).
Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
  final AppDependencies dependencies = AppDependencies();
  addTearDown(dependencies.dispose);
  await tester.pumpWidget(
    DependencyScope(
      dependencies: dependencies,
      child: MaterialApp(onGenerateRoute: AppRouter.onGenerateRoute, home: screen),
    ),
  );
  await tester.pump();
}

/// Tears the tree down so the screens' periodic cooldown timers are cancelled
/// before the test ends (a pending timer fails a widget test).
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

void main() {
  group('signup (one page only — no verification or review step)', () {
    testWidgets('A valid signup form shows the account-created confirmation', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester, const RegisterScreen());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'),
        'Maria Santos',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone'),
        '09171234567',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret123',
      );
      await tester.tap(find.text('Country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Philippines').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Account Created Successfully!'), findsOneWidget);

      await unmount(tester);
    });

    testWidgets(
      'Proceed to Login on the confirmation resets the flow to login',
      (WidgetTester tester) async {
        await pumpScreen(tester, const RegisterScreen());

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Full name'),
          'Maria Santos',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone'),
          '09171234567',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'secret123',
        );
        await tester.tap(find.text('Country'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Philippines').last);
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byType(PrimaryButton));
        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Proceed to Login'));
        await tester.pumpAndSettle();

        expect(find.text('Account Created Successfully!'), findsNothing);
        expect(find.text('Sign Up'), findsNothing);

        await unmount(tester);
      },
    );

    testWidgets('The signup CTA is the flat green pill of the reference', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester, const RegisterScreen());

      final PrimaryButton cta = tester.widget<PrimaryButton>(
        find.byType(PrimaryButton),
      );
      expect(cta.text, 'Sign Up');
      expect(cta.backgroundColor, AppColors.actionGreen);
      expect(cta.showShadow, isFalse);

      await unmount(tester);
    });
  });

  group('forgot-password reset flow (unchanged)', () {
    testWidgets('A verified reset code continues to the new-password step', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester, const PasswordResetOtpScreen(
        email: 'maria@example.com',
      ));

      expect(find.text('Verify Your Account'), findsOneWidget);
      expect(find.text('maria@example.com'), findsOneWidget);

      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.byType(NewPasswordScreen), findsOneWidget);

      await unmount(tester);
    });

    testWidgets('The address typed on the forgot-password step is displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const ForgotPasswordScreen(),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'maria@example.com');
      await tester.tap(find.text('Send Verification Code'));
      await tester.pumpAndSettle();

      expect(find.byType(PasswordResetOtpScreen), findsOneWidget);
      expect(find.text('maria@example.com'), findsOneWidget);
      expect(find.text('your email address'), findsNothing);

      await unmount(tester);
    });

    testWidgets('The reset step falls back when no address was entered', (
      WidgetTester tester,
    ) async {
      // Sending the code with an empty field must not leave a blank destination
      // line on the next screen.
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const ForgotPasswordScreen(),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Send Verification Code'));
      await tester.pumpAndSettle();

      expect(find.byType(PasswordResetOtpScreen), findsOneWidget);
      expect(find.text('your email address'), findsOneWidget);

      await unmount(tester);
    });
  });
}