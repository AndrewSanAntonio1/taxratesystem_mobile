/// Reference ("read-only knowledge base") models for the Taxes section.
///
/// These are pure data: the `Taxes` screens render them, and the calculation
/// engine may also be generated from them, so the app can never explain one
/// rule while computing another.
library;

/// A single row of a tax bracket table, e.g. `250,001 – ₱400,000 | 15%`.
class TaxBracket {
  const TaxBracket({required this.range, required this.rate});

  final String range;
  final String rate;
}

/// A worked example shown to help users understand a tax type.
class TaxExample {
  const TaxExample({
    required this.amount,
    required this.computation,
    required this.estimatedTax,
  });

  final String amount;
  final String computation;
  final String estimatedTax;
}

/// Everything the detail screen needs to explain one tax type.
class TaxDetailData {
  const TaxDetailData({
    required this.description,
    required this.currentRate,
    required this.effectiveDate,
    required this.brackets,
    required this.example,
  });

  final String description;
  final String currentRate;
  final String effectiveDate;
  final List<TaxBracket> brackets;
  final TaxExample example;
}