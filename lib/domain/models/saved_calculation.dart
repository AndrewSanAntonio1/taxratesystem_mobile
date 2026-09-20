import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';

/// A [TaxCalculation] the user chose to keep in their history, together with
/// the moment it was saved.
class SavedCalculation {
  const SavedCalculation({
    required this.calculation,
    required this.savedAt,
  });

  final TaxCalculation calculation;
  final DateTime savedAt;
}
