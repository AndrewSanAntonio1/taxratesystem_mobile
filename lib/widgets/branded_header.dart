import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class BrandedHeader extends StatelessWidget {
  const BrandedHeader({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(width: double.infinity),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: AppDimens.headerFontSize,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: 'Tax', style: TextStyle(color: AppColors.lightBlue)),
              TextSpan(text: 'Rate', style: TextStyle(color: AppColors.red)),
              TextSpan(text: 'System', style: TextStyle(color: AppColors.yellow)),
            ],
          ),
        ),
        if (showBackButton)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: AppColors.textDark),
            ),
          ),
      ],
    );
  }
}
