/// One line of a step-by-step calculation breakdown.
///
/// The values are pre-formatted strings because the breakdown mirrors exactly
/// what the taxpayer sees on the BIR computation sheet.
class BreakdownStep {
  const BreakdownStep({
    required this.label,
    required this.value,
    this.detail,
  });

  final String label;
  final String value;
  final String? detail;

  /// Label used by the engine for the final, summing line of a breakdown.
  static const String totalLabel = 'Total Tax Due';

  /// Whether this step is the grand total (rendered with sum styling).
  bool get isTotal => label == totalLabel;
}
