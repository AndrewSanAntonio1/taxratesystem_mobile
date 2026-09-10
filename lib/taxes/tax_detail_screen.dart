import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/tax_calculator_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/taxes/tax_data.dart';

class TaxDetailScreen extends StatelessWidget {
  const TaxDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.currentRate,
    required this.brackets,
    required this.effectiveDate,
    required this.example,
  });

  TaxDetailScreen.fromData(TaxDetailData data, {super.key})
      : title = data.title,
        description = data.description,
        currentRate = data.currentRate,
        brackets = data.brackets,
        effectiveDate = data.effectiveDate,
        example = data.example;

  final String title;
  final String description;
  final String currentRate;
  final List<TaxBracket> brackets;
  final String effectiveDate;
  final TaxExample example;

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
          title,
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
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaxCalculatorScreen(
                      initialTaxType: title,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calculate_outlined, size: 20),
              label: const Text(
                'Calculate This Tax',
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.focusBlue,
                foregroundColor: Colors.white,
                elevation: 0,
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
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            _buildRateBadge(),
            const SizedBox(height: 16),
            _buildBracketsTable(),
            const SizedBox(height: 16),
            _buildEffectiveDate(),
            const SizedBox(height: 16),
            _buildExampleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.focusBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.focusBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: AppDimens.subtitleFontSize,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.focusBlue,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
        boxShadow: [
          BoxShadow(
            color: AppColors.focusBlue.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.speed_outlined, color: Colors.white, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Rate',
                style: TextStyle(
                  fontSize: AppDimens.tinyFontSize,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currentRate,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBracketsTable() {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Tax Brackets',
              style: TextStyle(
                fontSize: AppDimens.bodyFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.inputSoft,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 1),
                bottom: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Taxable Income',
                    style: TextStyle(
                      fontSize: AppDimens.smallFontSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tax Rate',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: AppDimens.smallFontSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(brackets.length, (index) {
            final b = brackets[index];
            final isLast = index == brackets.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: AppColors.divider.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      b.range,
                      style: TextStyle(
                        fontSize: AppDimens.subtitleFontSize,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      b.rate,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: AppDimens.subtitleFontSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.focusBlue,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEffectiveDate() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.textSecondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            'Effective Date: $effectiveDate',
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.exampleTint,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
        border: Border.all(
          color: AppColors.cardTealEnd.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.cardTealEnd.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.cardTealEnd,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Example Calculation',
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildExampleRow('Taxable Income', example.income),
          const SizedBox(height: 8),
          _buildExampleRow('Computation', example.computation),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Tax',
                  style: TextStyle(
                    fontSize: AppDimens.subtitleFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  example.estimatedTax,
                  style: const TextStyle(
                    fontSize: AppDimens.bodyFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.focusBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
