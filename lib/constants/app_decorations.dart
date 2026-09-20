import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

/// Reusable [BoxDecoration]/[BoxShadow] recipes.
///
/// These values (shadow blur, offsets, alphas) were previously re-typed inline
/// in a dozen widgets, which is how a design system drifts. Every screen should
/// pick a recipe from here instead of inventing another shadow.
class AppDecorations {
  AppDecorations._();

  static const Offset _softOffset = Offset(0, 2);
  static const Offset _liftedOffset = Offset(0, 6);

  /// Small drop shadow used by cards and list tiles.
  static List<BoxShadow> get softShadow => <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: _softOffset,
        ),
      ];

  /// Slightly stronger shadow for interactive surfaces.
  static List<BoxShadow> get raisedShadow => <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: _softOffset,
        ),
      ];

  /// Coloured glow used beneath the coloured summary cards.
  static List<BoxShadow> glowShadow(Color color) => <BoxShadow>[
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: _liftedOffset,
        ),
      ];

  /// White card on a page background.
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
        boxShadow: softShadow,
      );

  /// Outlined, low-emphasis panel used for form fields and list rows.
  static BoxDecoration get outlinedPanel => BoxDecoration(
        color: AppColors.inputSoft,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        border: Border.all(color: AppColors.divider),
      );

  /// Sticky footer container above the bottom safe area.
  static BoxDecoration get bottomBar => BoxDecoration(
        color: AppColors.surface,
        boxShadow: raisedShadow,
      );

  /// Primary (blue) gradient card.
  static const LinearGradient primaryCardGradient = LinearGradient(
    colors: <Color>[AppColors.cardBlueStart, AppColors.cardBlueEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary (teal) gradient card.
  static const LinearGradient accentCardGradient = LinearGradient(
    colors: <Color>[AppColors.cardTealStart, AppColors.cardTealEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
