import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.onToggle,
    this.focusBorderColor = AppColors.focusBlue,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggle;
  final Color focusBorderColor;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(
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
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide(color: focusBorderColor, width: 2),
        ),
      ),
    );
  }
}
