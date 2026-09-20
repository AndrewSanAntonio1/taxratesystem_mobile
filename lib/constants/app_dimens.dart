class AppDimens {
  AppDimens._();

  static const double borderRadiusSmall = 8;
  static const double borderRadiusMedium = 12;
  static const double borderRadiusLarge = 28;
  static const double borderRadiusCard = 16;

  static const double buttonHeight = 50;
  static const double progressBarHeight = 4;
  static const double dashWidth = 50;
  static const double dashHeight = 3;

  static const double inputContentPaddingH = 16;
  static const double inputContentPaddingV = 11;

  /// Filled (borderless) input controls of the auth redesign — a roomier field
  /// than [inputContentPaddingH]/[inputContentPaddingV] and a softer corner.
  static const double filledInputPaddingH = 20;
  static const double filledInputPaddingV = 15;
  static const double borderRadiusField = 16;

  /// Capsule password fields of the create-new-password reference
  /// (`create-newpassword.png`): a stadium whose corner radius is half its
  /// height — [borderRadiusLarge] — inset by [filledInputPaddingH] on the sides.
  /// Together with the placeholder's line box this padding lands the 56pt field
  /// height measured in that reference, and the fill covers all of it because the
  /// height is produced by the padding rather than imposed on the container.
  static const double capsuleInputPaddingV = 16;
  static const double capsuleToggleSize = 36;

  static const double otpBoxWidth = 48;
  static const double otpBoxHeight = 56;

  /// Underline-style slots of the verification redesign (`verification.png`):
  /// the rule spans the whole slot (74pt wide there), so the slots flex to fill
  /// the row and only the gap between them is fixed.
  static const double otpSlotGap = 16;
  static const double otpUnderlineWidth = 1.2;
  static const double otpUnderlineFocusedWidth = 2;
  static const double otpUnderlineContentBottom = 10;

  static const int otpLength = 6;
  static const int resendCooldownSeconds = 45;
  static const int splashDurationMs = 2500;

  static const double pageHorizontalPadding = 24;
  static const double pageTopPadding = 0;
  static const double pageBottomPadding = 26;
  static const double footerPaddingV = 12;
  static const double footerPaddingH = 24;

  static const double headerFontSize = 28;
  static const double titleFontSize = 22;
  static const double subtitleFontSize = 14;
  static const double bodyFontSize = 16;
  static const double smallFontSize = 13;
  static const double tinyFontSize = 12;
}
