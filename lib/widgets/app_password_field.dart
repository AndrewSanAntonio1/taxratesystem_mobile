import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

/// Visual treatment of [AppPasswordField].
enum AppPasswordFieldStyle {
  /// Outlined field of the original forms, led by a lock icon.
  boxed,

  /// Borderless capsule of the auth redesign (`create-newpassword.png`): the
  /// mint fill alone marks the input and the placeholder carries the label, as
  /// in that reference.
  ///
  /// The reveal control is kept — a password the user cannot check is a
  /// regression — but it only appears once there is something to reveal, so an
  /// empty field is the plain capsule the reference shows. Its slot is reserved
  /// either way, so revealing never changes the field's height.
  capsule,
}

class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.onToggle,
    this.style = AppPasswordFieldStyle.boxed,
    this.focusBorderColor = AppColors.focusBlue,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggle;
  final AppPasswordFieldStyle style;

  /// Focus ring of [AppPasswordFieldStyle.boxed]; the capsule draws its own, in
  /// the action colour of the auth redesign.
  final Color focusBorderColor;
  final ValueChanged<String>? onChanged;

  /// Submit-time rule of the enclosing [Form]. A `TextField` cannot carry one —
  /// only a [TextFormField] takes a [validator] — so the field builds one;
  /// screens that skip validation leave it null and nothing changes.
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final bool capsule = style == AppPasswordFieldStyle.capsule;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      validator: validator,
      style: capsule
          ? const TextStyle(
              fontSize: AppDimens.bodyFontSize,
              color: AppColors.textDark,
            )
          : const TextStyle(color: AppColors.textDark),
      decoration: capsule ? _capsuleDecoration() : _boxedDecoration(),
    );
  }

  InputDecoration _boxedDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: AppColors.textSecondary,
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
      ),
      filled: true,
      fillColor: AppColors.inputSoft,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.inputContentPaddingH,
        vertical: AppDimens.inputContentPaddingV,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        borderSide: BorderSide(color: focusBorderColor, width: 2),
      ),
    );
  }

  /// Filled, flat capsule of the auth redesign. The placeholder sits at
  /// [AppDimens.filledInputPaddingH] and the hint reads in [AppColors.textMuted],
  /// the same helper tone the other redesigned auth forms use.
  InputDecoration _capsuleDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: AppDimens.bodyFontSize,
        color: AppColors.textMuted,
      ),
      suffixIcon: _capsuleToggle(),
      filled: true,
      fillColor: AppColors.inputMint,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.filledInputPaddingH,
        vertical: AppDimens.capsuleInputPaddingV,
      ),
      border: _capsuleBorder(),
      enabledBorder: _capsuleBorder(),
      focusedBorder: _capsuleBorder(AppColors.actionGreen),
    );
  }

  /// Flat by default; [focusColor] draws the focus ring in the action colour,
  /// since a borderless capsule gives no other focus feedback.
  OutlineInputBorder _capsuleBorder([Color? focusColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
      borderSide: focusColor == null
          ? BorderSide.none
          : BorderSide(color: focusColor, width: 1.5),
    );
  }

  /// Reveal control of the capsule, shown only while the field has a value.
  Widget _capsuleToggle() {
    return SizedBox(
      width: AppDimens.capsuleToggleSize,
      height: AppDimens.capsuleToggleSize,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (BuildContext context, TextEditingValue value, Widget? child) {
          if (value.text.isEmpty) return child!;
          return IconButton(
            onPressed: onToggle,
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
            ),
          );
        },
        child: const SizedBox.shrink(),
      ),
    );
  }
}
