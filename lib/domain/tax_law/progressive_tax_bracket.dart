/// Progressive (graduated) income tax brackets — the authoritative table.
///
/// Single source of truth: `TaxCalculationService` computes from this table and
/// `StaticTaxReferenceRepository` renders it, so the bracket the app *shows*
/// can never drift from the bracket the app *applies*.
///
/// Rates are the TRAIN Law schedule effective January 1, 2023.
library;

class ProgressiveBracket {
  const ProgressiveBracket({
    required this.label,
    required this.lowerBound,
    required this.upperBound,
    required this.baseTax,
    required this.rate,
  });

  /// Display range, e.g. `400,001 – ₱800,000`.
  final String label;

  /// Income above this amount is taxed at [rate].
  final double lowerBound;

  /// Inclusive ceiling of the bracket; `null` means "and above".
  final double? upperBound;

  /// Tax already due on everything up to [lowerBound].
  final double baseTax;

  /// Marginal rate applied to the excess over [lowerBound].
  final double rate;

  /// Rate formatted as required by the detail table, e.g. `20% of excess`.
  String get rateDescription {
    if (rate == 0) return 'Exempt';
    final String percent = _formatRate(rate);
    if (baseTax == 0) {
      return '$percent of excess over ${_formatPeso(lowerBound)}';
    }
    return '${_formatPeso(baseTax)} + $percent of excess';
  }

  static String _formatRate(double rate) {
    final double value = rate * 100;
    return value == value.roundToDouble()
        ? '${value.round()}%'
        : '${value.toStringAsFixed(2)}%';
  }

  static String _formatPeso(double amount) {
    final String digits = amount.toStringAsFixed(0);
    final StringBuffer buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '₱$buffer';
  }
}

/// TRAIN Law personal income tax schedule effective January 1, 2023.
const List<ProgressiveBracket> personalIncomeTaxBrackets = <ProgressiveBracket>[
  ProgressiveBracket(
    label: '₱0 – ₱250,000',
    lowerBound: 0,
    upperBound: 250000,
    baseTax: 0,
    rate: 0,
  ),
  ProgressiveBracket(
    label: '₱250,001 – ₱400,000',
    lowerBound: 250000,
    upperBound: 400000,
    baseTax: 0,
    rate: 0.15,
  ),
  ProgressiveBracket(
    label: '₱400,001 – ₱800,000',
    lowerBound: 400000,
    upperBound: 800000,
    baseTax: 22500,
    rate: 0.20,
  ),
  ProgressiveBracket(
    label: '₱800,001 – ₱2,000,000',
    lowerBound: 800000,
    upperBound: 2000000,
    baseTax: 102500,
    rate: 0.25,
  ),
  ProgressiveBracket(
    label: '₱2,000,001 – ₱8,000,000',
    lowerBound: 2000000,
    upperBound: 8000000,
    baseTax: 402500,
    rate: 0.30,
  ),
  ProgressiveBracket(
    label: 'Over ₱8,000,000',
    lowerBound: 8000000,
    upperBound: null,
    baseTax: 2202500,
    rate: 0.35,
  ),
];

/// Lookup helpers so the engine and the UI share one bracket-resolution rule.
extension ProgressiveBracketLookup on List<ProgressiveBracket> {
  /// Returns the bracket that [income] falls into.
  ///
  /// Walks the table in order, so the first bracket whose ceiling is not
  /// exceeded wins; the final entry (`upperBound == null`) catches everything
  /// above. Throws [StateError] only if the table itself is malformed.
  ProgressiveBracket bracketFor(double income) => firstWhere(
        (ProgressiveBracket bracket) =>
            bracket.upperBound == null || income <= bracket.upperBound!,
        orElse: () => throw StateError(
          'No progressive bracket found for $income — the table must end '
          'with an open-ended bracket.',
        ),
      );
}