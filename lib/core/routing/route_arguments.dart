import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';

/// Arguments passed to the calculator route.
///
/// A typed class (rather than a bare `Map` or positional values) keeps
/// `Navigator.pushNamed(..., arguments: ...)` compile-time checked.
class CalculatorRouteArgs {
  const CalculatorRouteArgs({this.initialTaxType, this.showAppBar = true});

  /// Pre-selects a tax type, used when arriving from a tax detail screen.
  final TaxTypeId? initialTaxType;

  /// `false` when embedded in the home shell's tab (which already has chrome).
  final bool showAppBar;
}

/// Arguments passed to the history route.
class HistoryRouteArgs {
  const HistoryRouteArgs({this.showAppBar = true});

  final bool showAppBar;
}

/// Arguments passed to the password-reset verification step.
///
/// Carries the address the code was requested for, so the verification screen can
/// name it instead of making the user remember which account they started from.
class PasswordResetOtpArgs {
  const PasswordResetOtpArgs({this.email = ''});

  /// The address collected by the forgot-password step; empty when the route is
  /// opened without one, in which case the screen names the email generically.
  final String email;
}
