import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/repositories/tax_calculation_repository.dart';
import 'package:taxratesystem_mobile/domain/services/tax_calculation_service.dart';

/// Computes tax on-device using [TaxCalculationService].
///
/// This is the offline-first implementation. It translates the service's
/// programmer-error `ArgumentError` into a domain [CalculationException] so the
/// UI has exactly one failure type to handle, and it is the class to replace
/// with a remote implementation once a calculation endpoint exists.
class LocalTaxCalculationRepository implements TaxCalculationRepository {
  const LocalTaxCalculationRepository([
    this._service = const TaxCalculationService(),
  ]);

  final TaxCalculationService _service;

  @override
  Future<TaxCalculation> calculate({
    required TaxTypeId taxType,
    required double amount,
  }) async {
    try {
      return _service.calculate(taxType: taxType, amount: amount);
    } on ArgumentError catch (error) {
      throw CalculationException('$error');
    }
  }
}
