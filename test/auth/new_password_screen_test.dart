import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taxratesystem_mobile/auth/login_screen.dart';
import 'package:taxratesystem_mobile/auth/new_password_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/core/di/app_dependencies.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/widgets/app_password_field.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/dash_divider.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';

/// Hosts the step on the app's real routing table, below the app's dependency
/// scope, so a tap that leaves the screen resolves exactly as it does in the app.
Future<void> pumpNewPasswordScreen(WidgetTester tester) async {
  final AppDependencies dependencies = AppDependencies();
  addTearDown(dependencies.dispose);

  await tester.pumpWidget(
    DependencyScope(
      dependencies: dependencies,
      child: MaterialApp(
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const NewPasswordScreen(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('The step renders the reference layout', (
    WidgetTester tester,
  ) async {
    await pumpNewPasswordScreen(tester);

    expect(find.text('Create New Password'), findsOneWidget);
    expect(find.text('New Password *'), findsOneWidget);
    expect(find.text('Confirm New Password *'), findsOneWidget);
    expect(find.byType(AppPasswordField), findsNWidgets(2));
    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('The reference page carries no chrome', (
    WidgetTester tester,
  ) async {
    // The redesign replaced the branded header and the step dashes with the
    // reference's undecorated white page.
    await pumpNewPasswordScreen(tester);

    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(BrandedHeader), findsNothing);
    expect(find.byType(DashDivider), findsNothing);
  });

  testWidgets('The capsule fields are flat, mint and stadium-shaped', (
    WidgetTester tester,
  ) async {
    await pumpNewPasswordScreen(tester);

    final TextField field = tester.widget<TextField>(
      find.byType(TextField).first,
    );
    final InputDecoration decoration = field.decoration!;

    expect(field.obscureText, isTrue);
    expect(decoration.filled, isTrue);
    expect(decoration.fillColor, AppColors.inputMint);
    expect(decoration.hintStyle?.color, AppColors.textMuted);

    for (final InputBorder? border in <InputBorder?>[
      decoration.border,
      decoration.enabledBorder,
      decoration.focusedBorder,
    ]) {
      expect(border, isA<OutlineInputBorder>());
      expect(
        (border! as OutlineInputBorder).borderRadius,
        BorderRadius.circular(AppDimens.borderRadiusLarge),
      );
    }

    expect(
      (decoration.border! as OutlineInputBorder).borderSide,
      BorderSide.none,
    );
    expect(
      (decoration.focusedBorder! as OutlineInputBorder).borderSide.color,
      AppColors.actionGreen,
    );
  });

  testWidgets('The reveal control appears once the field has a value', (
    WidgetTester tester,
  ) async {
    // The reference shows an empty capsule with no trailing control; the reveal
    // icon is kept, but only for a field that has something to reveal.
    await pumpNewPasswordScreen(tester);

    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'Abcdefg1');
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(
      tester.widget<TextField>(find.byType(TextField).first).obscureText,
      isFalse,
    );
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('The rules panel tracks the new password as it is typed', (
    WidgetTester tester,
  ) async {
    await pumpNewPasswordScreen(tester);

    expect(find.text('At least 8 characters'), findsOneWidget);
    expect(find.text('1 uppercase letter'), findsOneWidget);
    expect(find.text('1 number'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'abcdefgh');
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Abcdefg1');
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
  });

  testWidgets('The CTA is the flat green pill of the reference', (
    WidgetTester tester,
  ) async {
    await pumpNewPasswordScreen(tester);

    final PrimaryButton cta = tester.widget<PrimaryButton>(
      find.byType(PrimaryButton),
    );

    expect(cta.text, 'Reset Password');
    expect(cta.backgroundColor, AppColors.actionGreen);
    expect(cta.showShadow, isFalse);
    expect(cta.borderRadius, AppDimens.borderRadiusLarge);
  });

  testWidgets('Resetting closes with the success card and returns to login', (
    WidgetTester tester,
  ) async {
    await pumpNewPasswordScreen(tester);

    await tester.ensureVisible(find.byType(PrimaryButton));
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(find.text('Password Reset Successfully!'), findsOneWidget);

    await tester.tap(find.text('Back to Login'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('The sign-in line leaves the reset flow for login', (
    WidgetTester tester,
  ) async {
    // The reference page has no back affordance, so this line is the screen's
    // escape hatch.
    await pumpNewPasswordScreen(tester);

    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(NewPasswordScreen), findsNothing);
  });
}
