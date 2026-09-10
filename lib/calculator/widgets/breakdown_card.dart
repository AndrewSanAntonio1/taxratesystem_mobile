import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class BreakdownCard extends StatelessWidget {
  const BreakdownCard({super.key, required this.steps});

  final List<BreakdownStep> steps;

  @override
  Widget build(BuildContext context) {
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
              _StepHeaderIcon(),
              SizedBox(width: 8),
              Text(
                'Step-by-Step Breakdown',
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i < steps.length - 1 ? 10 : 0,
              ),
              child: _StepRow(step: steps[i], index: i),
            ),
        ],
      ),
    );
  }
}

class _StepHeaderIcon extends StatelessWidget {
  const _StepHeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.cardTealEnd.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.calculate_outlined,
        color: AppColors.cardTealEnd,
        size: 16,
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.index});

  final BreakdownStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isTotal = step.label == 'Total Tax Due';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isTotal ? AppColors.cardTealEnd : AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              isTotal ? 'Σ' : '${index + 1}',
              style: TextStyle(
                fontSize: AppDimens.tinyFontSize,
                fontWeight: FontWeight.bold,
                color: isTotal ? Colors.white : AppColors.cardTealEnd,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step.label,
                    style: TextStyle(
                      fontSize: AppDimens.subtitleFontSize,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    step.value,
                    style: TextStyle(
                      fontSize: AppDimens.subtitleFontSize,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                      color: isTotal ? AppColors.cardTealEnd : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              if (step.detail != null) ...[
                const SizedBox(height: 2),
                Text(
                  step.detail!,
                  style: TextStyle(
                    fontSize: AppDimens.tinyFontSize,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}