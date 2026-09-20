/// Every route name in the app, in one place.
///
/// Screens navigate with [AppRoutes] constants (or the typed helpers in
/// `app_router.dart`) instead of constructing a `MaterialPageRoute` inline,
/// which was previously done in 30+ places. That makes the navigation graph
/// readable in a single file, makes deep links mentionable, and lets a
/// redirect (e.g. anonymous user -> login) be added once.
class AppRoutes {
  AppRoutes._();

  // ------------------------------------------------------------------ public
  static const String splash = '/';
  static const String login = '/login';

  // -------------------------------------------------------------------- auth
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String passwordResetOtp = '/forgot-password/otp';
  static const String newPassword = '/forgot-password/new-password';

  // -------------------------------------------------------------------- home
  static const String home = '/home';

  // -------------------------------------------------------------- calculator
  static const String calculator = '/calculator';
  static const String calculationResult = '/calculator/result';

  // ------------------------------------------------------------------- taxes
  static const String taxDetail = '/taxes/detail';

  // ----------------------------------------------------------------- history
  static const String history = '/history';
  static const String savedCalculation = '/history/saved';

  // ----------------------------------------------------------------- profile
  static const String changePassword = '/profile/change-password';
  static const String notificationSettings = '/profile/notifications';
}