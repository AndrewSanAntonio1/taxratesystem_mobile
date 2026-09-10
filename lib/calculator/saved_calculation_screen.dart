import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';
import 'package:taxratesystem_mobile/calculator/widgets/breakdown_card.dart';
import 'package:taxratesystem_mobile/calculator/widgets/details_card.dart';
import 'package:taxratesystem_mobile/calculator/widgets/summary_banner.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class SavedCalculationScreen extends StatelessWidget {
  const SavedCalculationScreen({super.key, required this.saved});

  final SavedCalculation saved;

  @override
  Widget build(BuildContext context) {
    final calc = saved.calculation;
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text(
          'Saved Calculation',
          style: TextStyle(
            fontSize: AppDimens.bodyFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pageHorizontalPadding,
          12,
          AppDimens.pageHorizontalPadding,
          12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: AppDimens.buttonHeight,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              label: const Text(
                'Back to History',
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.focusBlue,
                side: const BorderSide(color: AppColors.focusBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryBanner(
              taxType: calc.taxType,
              subtitle: 'Saved on ${formatLongDate(saved.savedAt)}',
              amountLabel: 'Calculated Tax Amount',
              amount: formatMoney(calc.calculatedTax),
            ),
            const SizedBox(height: 16),
            DetailsCard(
              rows: [
                ('Taxable Base', formatMoney(calc.taxableIncome)),
                ('Applicable Bracket', calc.applicableBracket),
                ('Effective Date', calc.effectiveRule),
              ],
            ),
            const SizedBox(height: 16),
            BreakdownCard(steps: calc.breakdown),
          ],
        ),
      ),
    );
  }
}
