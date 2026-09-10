import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/taxes/tax_data.dart';
import 'package:taxratesystem_mobile/taxes/tax_detail_screen.dart';

class TaxesScreen extends StatelessWidget {
  const TaxesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pageHorizontalPadding,
              20,
              AppDimens.pageHorizontalPadding,
              24,
            ),
            itemCount: taxTypes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final type = taxTypes[index];
              final detail = taxDetails[type.name];
              return _buildTaxTypeTile(
                icon: type.icon,
                title: type.name,
                onTap: detail == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaxDetailScreen.fromData(detail),
                          ),
                        );
                      },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalPadding,
        16,
        AppDimens.pageHorizontalPadding,
        20,
      ),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Taxes',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View Rates',
                style: TextStyle(
                  fontSize: AppDimens.smallFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.focusBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxTypeTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.inputSoft,
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}