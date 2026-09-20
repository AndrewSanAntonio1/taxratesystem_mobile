import 'package:taxratesystem_mobile/core/formatters/tax_formatters.dart';
import 'package:taxratesystem_mobile/domain/models/breakdown_step.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/tax_law/progressive_tax_bracket.dart';

/// Computes tax for every [TaxTypeId] the system supports.
///
/// This is the **domain service**: pure Dart, no Flutter, no I/O. It is the only
/// place that knows Philippine tax arithmetic, which means it can be unit-tested
/// directly and later complemented by a remote calculation endpoint without
/// touching a single widget.
class TaxCalculationService {
  const TaxCalculationService();

  /// Computes the tax due on [amount] for [taxType].
  ///
  /// Throws [ArgumentError] when [amount] is not finite and greater than zero;
  /// the presentation layer validates before calling, so this guard exists to
  /// fail loudly on programmer error instead of silently returning zero.
  TaxCalculation calculate({
    required TaxTypeId taxType,
    required double amount,
  }) {
    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError.value(
        amount,
        'amount',
        'Taxable amount must be a finite number greater than zero',
      );
    }

    // Exhaustive switch: adding a TaxTypeId produces a compile-time error here
    // until its rule is implemented.
    return switch (taxType) {
      TaxTypeId.personalIncome => _personalIncomeTax(amount),
      TaxTypeId.corporateIncome => _corporateIncomeTax(amount),
      TaxTypeId.vat => _flatRate(taxType, amount, _vatRule),
      TaxTypeId.percentage => _flatRate(taxType, amount, _percentageTaxRule),
      TaxTypeId.capitalGainsRealProperty =>
        _flatRate(taxType, amount, _capitalGainsRealPropertyRule),
      TaxTypeId.capitalGainsShares => _capitalGainsShares(amount),
      TaxTypeId.documentaryStamp =>
        _flatRate(taxType, amount, _documentaryStampRule),
      TaxTypeId.withholding => _flatRate(taxType, amount, _withholdingRule),
      TaxTypeId.estate => _estateTax(amount),
      TaxTypeId.realProperty => _flatRate(taxType, amount, _realPropertyRule),
    };
  }

  // ----------------------------------------------------------- progressive

  TaxCalculation _personalIncomeTax(double income) {
    final ProgressiveBracket bracket =
        personalIncomeTaxBrackets.bracketFor(income);
    final double excessAmount = income - bracket.lowerBound;
    final double totalTax = bracket.baseTax + (excessAmount * bracket.rate);
    final bool isExempt = bracket.rate == 0;

    return TaxCalculation(
      taxType: TaxTypeId.personalIncome,
      taxableIncome: income,
      calculatedTax: totalTax,
      applicableBracket: isExempt
          ? '${bracket.label} (Exempt)'
          : '${bracket.label} (${formatPercent(bracket.rate)} excess rate)',
      effectiveRule: 'TRAIN Law Series (Jan 1, 2023)',
      breakdown: <BreakdownStep>[
        if (!isExempt)
          BreakdownStep(
            label: 'Base Tax',
            value: formatMoney(bracket.baseTax),
          ),
        if (!isExempt)
          BreakdownStep(
            label: 'Excess Amount',
            value: formatMoney(excessAmount),
            detail: '${formatPercent(bracket.rate)} = '
                '${formatMoney(excessAmount * bracket.rate)}',
          ),
        BreakdownStep(
          label: BreakdownStep.totalLabel,
          value: formatMoney(totalTax),
        ),
      ],
    );
  }

  TaxCalculation _corporateIncomeTax(double income) {
    final double rate =
        income <= _corporatePreferredIncomeCeiling ? 0.20 : 0.25;
    final String bracket = income <= _corporatePreferredIncomeCeiling
        ? 'Net Taxable Income ≤ ₱5M'
        : 'Net Taxable Income > ₱5M';

    return TaxCalculation(
      taxType: TaxTypeId.corporateIncome,
      taxableIncome: income,
      calculatedTax: income * rate,
      applicableBracket: '$bracket (${formatPercent(rate)})',
      effectiveRule: 'CREATE Law (Jul 1, 2020)',
      breakdown: <BreakdownStep>[
        BreakdownStep(label: 'Net Taxable Income', value: formatMoney(income)),
        BreakdownStep(label: 'Rate Applied', value: formatPercent(rate)),
        BreakdownStep(
          label: BreakdownStep.totalLabel,
          value: formatMoney(income * rate),
        ),
      ],
    );
  }

  TaxCalculation _capitalGainsShares(double gain) {
    final bool aboveThreshold = gain > _capitalGainsSharesThreshold;
    final double baseTax = aboveThreshold ? 5000 : 0;
    final double rate = aboveThreshold ? 0.10 : 0.05;
    final double excessAmount =
        aboveThreshold ? gain - _capitalGainsSharesThreshold : gain;
    final double totalTax =
        aboveThreshold ? baseTax + (excessAmount * rate) : gain * rate;
    final String bracket =
        aboveThreshold ? 'Net Gain > ₱100,000' : 'Net Gain ≤ ₱100,000';

    return TaxCalculation(
      taxType: TaxTypeId.capitalGainsShares,
      taxableIncome: gain,
      calculatedTax: totalTax,
      applicableBracket: '$bracket (${formatPercent(rate)})',
      effectiveRule: 'NIRC – Capital Gains (Jan 1, 1998)',
      breakdown: <BreakdownStep>[
        if (aboveThreshold)
          BreakdownStep(label: 'Base Tax', value: formatMoney(baseTax)),
        BreakdownStep(
          label: 'Applicable Rate',
          value: formatPercent(rate),
          detail: 'On gain of ${formatMoney(excessAmount)}',
        ),
        BreakdownStep(
          label: BreakdownStep.totalLabel,
          value: formatMoney(totalTax),
        ),
      ],
    );
  }

  TaxCalculation _estateTax(double estate) {
    final bool exempt = estate <= _estateStandardDeduction;
    final double taxableBase = exempt ? 0 : estate - _estateStandardDeduction;
    final double totalTax = taxableBase * _estateTaxRate;
    final String bracket =
        exempt ? 'Net Estate ≤ ₱5M (Exempt)' : 'Net Estate > ₱5M';

    return TaxCalculation(
      taxType: TaxTypeId.estate,
      taxableIncome: estate,
      calculatedTax: totalTax,
      applicableBracket: '$bracket (6% of taxable base)',
      effectiveRule: 'TRAIN Law (Jan 1, 2018)',
      breakdown: <BreakdownStep>[
        BreakdownStep(label: 'Net Estate', value: formatMoney(estate)),
        BreakdownStep(
          label: 'Standard Deduction',
          value: formatMoney(_estateStandardDeduction),
        ),
        BreakdownStep(
          label: 'Excess Rate',
          value: '6%',
          detail: 'On excess of ${formatMoney(taxableBase)}',
        ),
        BreakdownStep(
          label: BreakdownStep.totalLabel,
          value: formatMoney(totalTax),
        ),
      ],
    );
  }

  // ------------------------------------------------------------- flat rate

  /// `amount × rate` — models every tax whose whole rule is one percentage.
  TaxCalculation _flatRate(
    TaxTypeId taxType,
    double amount,
    _FlatRateRule rule,
  ) {
    final double totalTax = amount * rule.rate;

    return TaxCalculation(
      taxType: taxType,
      taxableIncome: amount,
      calculatedTax: totalTax,
      applicableBracket: '${rule.bracket} (${formatPercent(rule.rate)})',
      effectiveRule: rule.effectiveRule,
      breakdown: <BreakdownStep>[
        BreakdownStep(label: rule.amountLabel, value: formatMoney(amount)),
        BreakdownStep(label: 'Rate Applied', value: formatPercent(rule.rate)),
        BreakdownStep(
          label: BreakdownStep.totalLabel,
          value: formatMoney(totalTax),
        ),
      ],
    );
  }
}

/// The single percentage rule behind a flat-rate tax.
class _FlatRateRule {
  const _FlatRateRule({
    required this.rate,
    required this.amountLabel,
    required this.bracket,
    required this.effectiveRule,
  });

  final double rate;

  /// What the entered amount represents, e.g. `Gross Sales`.
  final String amountLabel;

  /// Bracket description *without* the rate, which is appended by the engine so
  /// the percentage is never written twice.
  final String bracket;

  final String effectiveRule;
}

const double _corporatePreferredIncomeCeiling = 5000000;
const double _capitalGainsSharesThreshold = 100000;
const double _estateStandardDeduction = 5000000;
const double _estateTaxRate = 0.06;

const _FlatRateRule _vatRule = _FlatRateRule(
  rate: 0.12,
  amountLabel: 'Gross Sales',
  bracket: 'Goods & Services',
  effectiveRule: 'TRAIN Law (Jan 1, 2018)',
);

const _FlatRateRule _percentageTaxRule = _FlatRateRule(
  rate: 0.03,
  amountLabel: 'Gross Sales',
  bracket: 'Gross Sales ≤ ₱3M',
  effectiveRule: 'TRAIN Law (Jan 1, 2018)',
);

const _FlatRateRule _capitalGainsRealPropertyRule = _FlatRateRule(
  rate: 0.06,
  amountLabel: 'Selling Price',
  bracket: 'Selling Price or Zonal Value',
  effectiveRule: 'NIRC – Capital Gains (Jan 1, 1998)',
);

const _FlatRateRule _documentaryStampRule = _FlatRateRule(
  rate: 0.015,
  amountLabel: 'Document Value',
  bracket: 'Deeds of Sale',
  effectiveRule: 'NIRC – DST (Jan 1, 2005)',
);

const _FlatRateRule _withholdingRule = _FlatRateRule(
  rate: 0.10,
  amountLabel: 'Gross Payment',
  bracket: 'Professional Fees',
  effectiveRule: 'TRAIN Law (Jan 1, 2018)',
);

const _FlatRateRule _realPropertyRule = _FlatRateRule(
  rate: 0.01,
  amountLabel: 'Assessed Value',
  bracket: 'Basic RPT',
  effectiveRule: 'Local Government Code (Jan 1, 1992)',
);