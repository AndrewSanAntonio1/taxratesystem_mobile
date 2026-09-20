import 'package:taxratesystem_mobile/domain/models/breakdown_step.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';

/// The immutable result of a single tax computation.
///
/// This is a pure domain model: it holds no UI state and knows nothing about
/// Flutter, so it can be produced by a local engine today and by a remote
/// calculation endpoint later without touching the widgets.
class TaxCalculation {
  const TaxCalculation({
    required this.taxType,
    required this.taxableIncome,
    required this.calculatedTax,
    required this.applicableBracket,
    required this.effectiveRule,
    required this.breakdown,
  });

  final TaxTypeId taxType;

  /// The amount the user entered (the taxable base before any deduction).
  final double taxableIncome;

  final double calculatedTax;

  /// Human-readable description of the bracket/rule that was applied.
  final String applicableBracket;

  /// The law and effective date the rule comes from.
  final String effectiveRule;

  final List<BreakdownStep> breakdown;
}
