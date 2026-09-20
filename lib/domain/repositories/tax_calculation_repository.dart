import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';

/// Boundary for obtaining a tax computation.
///
/// The calculator screen talks to this, not to [TaxCalculationService] directly.
/// That keeps the door open for a server-side computation endpoint (or a
/// server-authoritative rate table) without rewriting the presentation layer,
/// while the offline engine remains the default implementation.
abstract interface class TaxCalculationRepository {
  /// Computes the tax due on [amount] for [taxType].
  ///
  /// Throws [CalculationException] when the input cannot be computed.
  Future<TaxCalculation> calculate({
    required TaxTypeId taxType,
    required double amount,
  });
}
