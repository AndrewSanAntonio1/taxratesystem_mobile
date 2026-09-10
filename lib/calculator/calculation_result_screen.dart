import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';
import 'package:taxratesystem_mobile/calculator/history_store.dart';
import 'package:taxratesystem_mobile/calculator/widgets/breakdown_card.dart';
import 'package:taxratesystem_mobile/calculator/widgets/details_card.dart';
import 'package:taxratesystem_mobile/calculator/widgets/summary_banner.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class CalculationResultScreen extends StatelessWidget {
  const CalculationResultScreen({super.key, required this.calculation});

  final TaxCalculation calculation;

  void _save(BuildContext context) {
    HistoryStore.instance.add(
      SavedCalculation(
        calculation: calculation,
        savedAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculation saved to history'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text(
          'Calculation Result',
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
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppDimens.buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text(
                      'Calculate Again',
                      style: TextStyle(
                        fontSize: AppDimens.smallFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.focusBlue,
                      side: const BorderSide(color: AppColors.focusBlue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.borderRadiusCard),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: AppDimens.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () => _save(context),
                    icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                    label: const Text(
                      'Save Calculation',
                      style: TextStyle(
                        fontSize: AppDimens.smallFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.focusBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.borderRadiusCard),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryBanner(
              taxType: calculation.taxType,
              amountLabel: 'Calculated Tax Amount',
              amount: formatMoney(calculation.calculatedTax),
            ),
            const SizedBox(height: 16),
            DetailsCard(
              rows: [
                ('Taxable Income', formatMoney(calculation.taxableIncome)),
                ('Applicable Bracket', calculation.applicableBracket),
                ('Effective Rule', calculation.effectiveRule),
              ],
            ),
            const SizedBox(height: 16),
            BreakdownCard(steps: calculation.breakdown),
          ],
        ),
      ),
    );
  }
}
