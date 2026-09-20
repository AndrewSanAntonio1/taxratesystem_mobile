import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/auth/forgot_password_screen.dart';
import 'package:taxratesystem_mobile/auth/login_screen.dart';
import 'package:taxratesystem_mobile/auth/new_password_screen.dart';
import 'package:taxratesystem_mobile/auth/password_reset_otp_screen.dart';
import 'package:taxratesystem_mobile/auth/register_screen.dart';
import 'package:taxratesystem_mobile/auth/splash_screen.dart';
import 'package:taxratesystem_mobile/calculator/calculation_result_screen.dart';
import 'package:taxratesystem_mobile/calculator/history_screen.dart';
import 'package:taxratesystem_mobile/calculator/saved_calculation_screen.dart';
import 'package:taxratesystem_mobile/calculator/tax_calculator_screen.dart';
import 'package:taxratesystem_mobile/core/routing/app_routes.dart';
import 'package:taxratesystem_mobile/core/routing/route_arguments.dart';
import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/home/home_shell.dart';
import 'package:taxratesystem_mobile/profile/change_password_screen.dart';
import 'package:taxratesystem_mobile/profile/notification_settings_screen.dart';
import 'package:taxratesystem_mobile/taxes/tax_detail_screen.dart';
import 'package:taxratesystem_mobile/widgets/state_views.dart';

/// The app's single routing table.
///
/// `MaterialApp.onGenerateRoute` delegates here, so every destination is
/// declared once. Screens navigate through the [AppNavigation] helpers below,
/// which are typed and null-safe — replacing 30+ inline `MaterialPageRoute`
/// constructions that could each pass the wrong argument silently.
class AppRouter {
  AppRouter._();

  /// Routes that need no arguments.
  static final Map<String, WidgetBuilder> _simpleRoutes =
      <String, WidgetBuilder>{
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.newPassword: (_) => const NewPasswordScreen(),
        AppRoutes.home: (_) => const HomeShell(),
        AppRoutes.changePassword: (_) => const ChangePasswordScreen(),
        AppRoutes.notificationSettings: (_) =>
            const NotificationSettingsScreen(),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String name = settings.name ?? AppRoutes.splash;
    final Object? arguments = settings.arguments;

    final WidgetBuilder? simple = _simpleRoutes[name];
    if (simple != null) return _material(simple, settings);

    switch (name) {
      case AppRoutes.passwordResetOtp:
        final PasswordResetOtpArgs args = arguments is PasswordResetOtpArgs
            ? arguments
            : const PasswordResetOtpArgs();
        return _material(
          (_) => PasswordResetOtpScreen(email: args.email),
          settings,
        );
      case AppRoutes.calculator:
        final CalculatorRouteArgs args = arguments is CalculatorRouteArgs
            ? arguments
            : const CalculatorRouteArgs();
        return _material(
          (_) => TaxCalculatorScreen(
            initialTaxType: args.initialTaxType,
            showAppBar: args.showAppBar,
          ),
          settings,
        );
      case AppRoutes.calculationResult:
        if (arguments is TaxCalculation) {
          return _material(
            (_) => CalculationResultScreen(calculation: arguments),
            settings,
          );
        }
        return _missingArgument(name, 'TaxCalculation', settings);
      case AppRoutes.taxDetail:
        if (arguments is TaxTypeId) {
          return _material(
            (_) => TaxDetailScreen(taxType: arguments),
            settings,
          );
        }
        return _missingArgument(name, 'TaxTypeId', settings);
      case AppRoutes.history:
        final HistoryRouteArgs args = arguments is HistoryRouteArgs
            ? arguments
            : const HistoryRouteArgs();
        return _material(
          (_) => HistoryScreen(showAppBar: args.showAppBar),
          settings,
        );
      case AppRoutes.savedCalculation:
        if (arguments is SavedCalculation) {
          return _material(
            (_) => SavedCalculationScreen(saved: arguments),
            settings,
          );
        }
        return _missingArgument(name, 'SavedCalculation', settings);
    }

    return _material(
      (_) => _RouteErrorScreen(
        message: 'No screen is registered for the route "$name".',
      ),
      settings,
    );
  }

  static MaterialPageRoute<dynamic> _material(
    WidgetBuilder builder,
    RouteSettings settings,
  ) => MaterialPageRoute<dynamic>(builder: builder, settings: settings);

  /// A route was reached without the argument it requires — a programming
  /// error, surfaced as a readable error state rather than a cast crash.
  static MaterialPageRoute<dynamic> _missingArgument(
    String routeName,
    String expectedType,
    RouteSettings settings,
  ) => _material(
    (_) => _RouteErrorScreen(
      message: 'Route "$routeName" requires a $expectedType argument.',
    ),
    settings,
  );
}

/// Fallback destination for an unknown or mis-configured route.
class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppErrorStateView(
          message: message,
          onRetry: () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}

/// Typed navigation helpers.
///
/// Call sites read as intent (`context.pushTaxDetail(type)`) and the compiler
/// checks the argument, which an inline `Navigator.push` + `MaterialPageRoute`
/// never did.
extension AppNavigation on BuildContext {
  NavigatorState get _navigator => Navigator.of(this);

  /// Splash -> login, and logout: replaces the whole stack.
  Future<void> replaceWithLogin() =>
      _navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);

  /// Login -> home: the user must not be able to go "back" to the login form.
  Future<void> replaceWithHome() =>
      _navigator.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);

  Future<void> openRegister() => _navigator.pushNamed(AppRoutes.register);

  Future<void> openForgotPassword() =>
      _navigator.pushNamed(AppRoutes.forgotPassword);

  /// Forgot password -> the code step. The address typed on the previous screen
  /// travels with the route so the verification screen can display it; an empty
  /// [email] is accepted, and the screen then names the address generically.
  Future<void> openPasswordResetOtp({String email = ''}) =>
      _navigator.pushNamed(
        AppRoutes.passwordResetOtp,
        arguments: PasswordResetOtpArgs(email: email),
      );

  Future<void> openNewPassword() => _navigator.pushNamed(AppRoutes.newPassword);

  Future<void> pushCalculator({TaxTypeId? initialTaxType}) =>
      _navigator.pushNamed(
        AppRoutes.calculator,
        arguments: CalculatorRouteArgs(initialTaxType: initialTaxType),
      );

  Future<void> pushCalculationResult(TaxCalculation calculation) =>
      _navigator.pushNamed(AppRoutes.calculationResult, arguments: calculation);

  Future<void> pushTaxDetail(TaxTypeId taxType) =>
      _navigator.pushNamed(AppRoutes.taxDetail, arguments: taxType);

  Future<void> pushHistory() => _navigator.pushNamed(
    AppRoutes.history,
    arguments: const HistoryRouteArgs(),
  );

  Future<void> pushSavedCalculation(SavedCalculation saved) =>
      _navigator.pushNamed(AppRoutes.savedCalculation, arguments: saved);

  Future<void> pushChangePassword() =>
      _navigator.pushNamed(AppRoutes.changePassword);

  Future<void> pushNotificationSettings() =>
      _navigator.pushNamed(AppRoutes.notificationSettings);
}
