import 'dart:ui';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0D1B2A);
  static const Color primaryLight = Color(0xFF1B2838);
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color accent = Color(0xFF1E3A5F);
  static const Color accentLight = Color(0xFF415A77);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFCF6679);
  static const Color successGreen = Color(0xFF81C784);
  static const Color successCheck = Color(0xFF22C55E);

  static const Color lightBlue = Color(0xFF4A90D9);
  static const Color red = Color(0xFFE74C3C);
  static const Color yellow = Color(0xFFF1C40F);

  static const Color focusBlue = Color(0xFF2563EB);
  static const Color cardBlueStart = Color(0xFF1E3A5F);
  static const Color cardBlueEnd = Color(0xFF2563EB);
  static const Color cardTealStart = Color(0xFF0D9488);
  static const Color cardTealEnd = Color(0xFF14B8A6);

  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navActive = Color(0xFF2563EB);

  // Declared `const` (not as getters) so they can be used inside `const`
  // constructors — e.g. `const Icon(Icons.chevron_right, color: AppColors.textSecondary)`.
  // The previous getters silently forbade that, which is what forced widgets to
  // duplicate colour literals instead of reusing this palette.
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color inputSoft = Color(0xFFF8FAFC);
  static const Color inputFill = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color inputBorder = Color(0xFFBDBDBD);

  /// Idle rule under a verification-code slot in `verification.png` (#CBCBCB
  /// sampled there). [divider] is too pale to read as an input rule and
  /// [inputBorder] is the outline of the boxed fields, so the underline slots of
  /// the redesigned verification screens use this one.
  static const Color inputUnderline = Color(0xFFCBCBCB);
  static const Color pageBackground = Color(0xFFF8F9FA);
  static const Color headerBackground = Color(0xFFE8F0FE);
  static const Color exampleTint = Color(0xFFE6F7F5);

  // Colours sampled from the auth redesign reference (`forgot-password.png`):
  // its mint input fill (#F4FCF9), brand action green (#00BF6E) and the
  // mid-tone grey of its helper copy (#616161).
  //
  // They live here rather than inline in the screen so the next redesigned
  // screen reuses the same fill/CTA instead of re-sampling the mockup.

  /// Filled, borderless input surface used by the single-task auth forms.
  static const Color inputMint = Color(0xFFF4FCF9);

  /// Fill of the primary call to action on the auth forms.
  static const Color actionGreen = Color(0xFF00BF6E);

  /// Helper/secondary paragraph copy. [textSecondary] (#B0BEC5) is too light to
  /// stay readable on a white surface, so supporting copy uses this instead.
  static const Color textMuted = Color(0xFF64748B);
}
