class BreakdownStep {
  const BreakdownStep({
    required this.label,
    required this.value,
    this.detail,
  });

  final String label;
  final String value;
  final String? detail;
}

class TaxCalculation {
  const TaxCalculation({
    required this.taxType,
    required this.taxableIncome,
    required this.calculatedTax,
    required this.applicableBracket,
    required this.effectiveRule,
    required this.breakdown,
  });

  final String taxType;
  final double taxableIncome;
  final double calculatedTax;
  final String applicableBracket;
  final String effectiveRule;
  final List<BreakdownStep> breakdown;
}

class SavedCalculation {
  const SavedCalculation({
    required this.calculation,
    required this.savedAt,
  });

  final TaxCalculation calculation;
  final DateTime savedAt;
}

String formatMoney(double amount) {
  final negative = amount < 0;
  final value = amount.abs();
  final parts = value.toStringAsFixed(2).split('.');
  final digits = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}₱$buffer.${parts[1]}';
}

String formatPercent(double rate) {
  final value = rate * 100;
  return value == value.roundToDouble()
      ? '${value.round()}%'
      : '${value.toStringAsFixed(2)}%';
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String formatLongDate(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';

String formatShortDate(DateTime date) =>
    '${_monthNames[date.month - 1].substring(0, 3)} ${date.day}, ${date.year}';

TaxCalculation calculateTax({
  required String taxType,
  required double amount,
}) {
  switch (taxType) {
    case 'Personal Income Tax':
      return _personalIncomeTax(amount);
    case 'Corporate Income Tax':
      return _corporateIncomeTax(amount);
    case 'VAT':
      return _flatRate(
        taxType: 'VAT',
        amount: amount,
        rate: 0.12,
        amountLabel: 'Gross Sales',
        bracket: 'Goods & Services',
        effectiveRule: 'TRAIN Law (Jan 1, 2018)',
      );
    case 'Percentage Tax':
      return _flatRate(
        taxType: 'Percentage Tax',
        amount: amount,
        rate: 0.03,
        amountLabel: 'Gross Sales',
        bracket: 'Gross Sales ≤ ₱3M',
        effectiveRule: 'TRAIN Law (Jan 1, 2018)',
      );
    case 'CGT – Real Property':
      return _flatRate(
        taxType: 'CGT – Real Property',
        amount: amount,
        rate: 0.06,
        amountLabel: 'Selling Price',
        bracket: 'Selling Price or Zonal Value',
        effectiveRule: 'NIRC – Capital Gains (Jan 1, 1998)',
      );
    case 'CGT – Shares':
      return _cgtShares(amount);
    case 'Documentary Stamp Tax':
      return _flatRate(
        taxType: 'Documentary Stamp Tax',
        amount: amount,
        rate: 0.015,
        amountLabel: 'Document Value',
        bracket: 'Deeds of Sale (1.5%)',
        effectiveRule: 'NIRC – DST (Jan 1, 2005)',
      );
    case 'Withholding Tax':
      return _flatRate(
        taxType: 'Withholding Tax',
        amount: amount,
        rate: 0.10,
        amountLabel: 'Gross Payment',
        bracket: 'Professional Fees (10%)',
        effectiveRule: 'TRAIN Law (Jan 1, 2018)',
      );
    case 'Estate Tax':
      return _estateTax(amount);
    case 'Real Property Tax':
      return _flatRate(
        taxType: 'Real Property Tax',
        amount: amount,
        rate: 0.01,
        amountLabel: 'Assessed Value',
        bracket: 'Basic RPT (1%)',
        effectiveRule: 'Local Government Code (Jan 1, 1992)',
      );
    default:
      throw ArgumentError('Unsupported tax type: $taxType');
  }
}

TaxCalculation _personalIncomeTax(double income) {
  var baseTax = 0.0;
  var excessRate = 0.0;
  var excessAmount = 0.0;
  var bracket = '₱0 – ₱250,000';

  if (income > 250000 && income <= 400000) {
    excessRate = 0.15;
    excessAmount = income - 250000;
    bracket = '₱250,001 – ₱400,000';
  } else if (income > 400000 && income <= 800000) {
    baseTax = 22500;
    excessRate = 0.20;
    excessAmount = income - 400000;
    bracket = '₱400,001 – ₱800,000';
  } else if (income > 800000 && income <= 2000000) {
    baseTax = 102500;
    excessRate = 0.25;
    excessAmount = income - 800000;
    bracket = '₱800,001 – ₱2,000,000';
  } else if (income > 2000000 && income <= 8000000) {
    baseTax = 402500;
    excessRate = 0.30;
    excessAmount = income - 2000000;
    bracket = '₱2,000,001 – ₱8,000,000';
  } else if (income > 8000000) {
    baseTax = 2202500;
    excessRate = 0.35;
    excessAmount = income - 8000000;
    bracket = 'Over ₱8,000,000';
  }

  final totalTax = baseTax + (excessAmount * excessRate);

  return TaxCalculation(
    taxType: 'Personal Income Tax',
    taxableIncome: income,
    calculatedTax: totalTax,
    applicableBracket:
        income <= 250000 ? '$bracket (Exempt)' : '$bracket (${formatPercent(excessRate)} excess rate)',
    effectiveRule: 'TRAIN Law Series (Jan 1, 2023)',
    breakdown: [
      if (excessRate > 0)
        BreakdownStep(
          label: 'Base Tax',
          value: formatMoney(baseTax),
        ),
      if (excessRate > 0)
        BreakdownStep(
          label: 'Excess Amount',
          value: formatMoney(excessAmount),
          detail:
              '${formatPercent(excessRate)} = ${formatMoney(excessAmount * excessRate)}',
        ),
      BreakdownStep(
        label: 'Total Tax Due',
        value: formatMoney(totalTax),
      ),
    ],
  );
}

TaxCalculation _corporateIncomeTax(double income) {
  final rate = income <= 5000000 ? 0.20 : 0.25;
  final bracket = income <= 5000000
      ? 'Net Taxable Income ≤ ₱5M'
      : 'Net Taxable Income > ₱5M';
  return TaxCalculation(
    taxType: 'Corporate Income Tax',
    taxableIncome: income,
    calculatedTax: income * rate,
    applicableBracket: '$bracket (${formatPercent(rate)})',
    effectiveRule: 'CREATE Law (Jul 1, 2020)',
    breakdown: [
      BreakdownStep(
        label: 'Net Taxable Income',
        value: formatMoney(income),
      ),
      BreakdownStep(
        label: 'Rate Applied',
        value: formatPercent(rate),
      ),
      BreakdownStep(
        label: 'Total Tax Due',
        value: formatMoney(income * rate),
      ),
    ],
  );
}

TaxCalculation _cgtShares(double gain) {
  final baseTax = gain <= 100000 ? 0.0 : 5000.0;
  final excessRate = gain <= 100000 ? 0.05 : 0.10;
  final excessAmount = gain <= 100000 ? gain : gain - 100000;
  final totalTax = gain <= 100000
      ? gain * 0.05
      : 5000 + ((gain - 100000) * 0.10);
  final bracket = gain <= 100000
      ? 'Net Gain ≤ ₱100,000'
      : 'Net Gain > ₱100,000';

  return TaxCalculation(
    taxType: 'CGT – Shares',
    taxableIncome: gain,
    calculatedTax: totalTax,
    applicableBracket:
        '$bracket (${formatPercent(gain <= 100000 ? 0.05 : 0.10)})',
    effectiveRule: 'NIRC – Capital Gains (Jan 1, 1998)',
    breakdown: [
      if (gain > 100000)
        BreakdownStep(
          label: 'Base Tax',
          value: formatMoney(baseTax),
        ),
      BreakdownStep(
        label: 'Applicable Rate',
        value: formatPercent(excessRate),
        detail: 'On gain of ${formatMoney(excessAmount)}',
      ),
      BreakdownStep(
        label: 'Total Tax Due',
        value: formatMoney(totalTax),
      ),
    ],
  );
}

TaxCalculation _estateTax(double estate) {
  final standardDeduction = 5000000.0;
  final taxableBase = estate <= standardDeduction ? 0.0 : estate - standardDeduction;
  final totalTax = taxableBase * 0.06;
  final bracket =
      estate <= standardDeduction ? 'Net Estate ≤ ₱5M (Exempt)' : 'Net Estate > ₱5M';

  return TaxCalculation(
    taxType: 'Estate Tax',
    taxableIncome: estate,
    calculatedTax: totalTax,
    applicableBracket: '$bracket (6% of taxable base)',
    effectiveRule: 'TRAIN Law (Jan 1, 2018)',
    breakdown: [
      BreakdownStep(
        label: 'Net Estate',
        value: formatMoney(estate),
      ),
      BreakdownStep(
        label: 'Standard Deduction',
        value: formatMoney(standardDeduction),
      ),
      BreakdownStep(
        label: 'Excess Rate',
        value: '6%',
        detail: 'On excess of ${formatMoney(taxableBase)}',
      ),
      BreakdownStep(
        label: 'Total Tax Due',
        value: formatMoney(totalTax),
      ),
    ],
  );
}

TaxCalculation _flatRate({
  required String taxType,
  required double amount,
  required double rate,
  required String amountLabel,
  required String bracket,
  required String effectiveRule,
}) {
  final totalTax = amount * rate;
  return TaxCalculation(
    taxType: taxType,
    taxableIncome: amount,
    calculatedTax: totalTax,
    applicableBracket: '$bracket (${formatPercent(rate)})',
    effectiveRule: effectiveRule,
    breakdown: [
      BreakdownStep(
        label: amountLabel,
        value: formatMoney(amount),
      ),
      BreakdownStep(
        label: 'Rate Applied',
        value: formatPercent(rate),
      ),
      BreakdownStep(
        label: 'Total Tax Due',
        value: formatMoney(totalTax),
      ),
    ],
  );
}