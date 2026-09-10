import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class SummaryBanner extends StatelessWidget {
  const SummaryBanner({
    super.key,
    required this.taxType,
    required this.amountLabel,
    required this.amount,
    this.subtitle,
  });

  final String taxType;
  final String amountLabel;
  final String amount;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardBlueStart, AppColors.focusBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
        boxShadow: [
          BoxShadow(
            color: AppColors.focusBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  taxType,
                  style: TextStyle(
                    fontSize: AppDimens.subtitleFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: AppDimens.tinyFontSize,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            amountLabel,
            style: TextStyle(
              fontSize: AppDimens.smallFontSize,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}