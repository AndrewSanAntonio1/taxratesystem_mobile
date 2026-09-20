import 'package:flutter/foundation.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/core/formatters/tax_formatters.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/repositories/tax_calculation_repository.dart';

/// Presentation state for the calculator form.
///
/// Owns input validation, the submitting flag and any failure message, so the
/// widget is left with nothing but layout — the previous implementation parsed
/// and computed inline inside `_calculate()` in the screen.
class CalculatorController extends ChangeNotifier {
  CalculatorController(
    this._repository, {
    TaxTypeId initialTaxType = TaxTypeId.personalIncome,
  }) : _selectedTaxType = initialTaxType;

  final TaxCalculationRepository _repository;

  TaxTypeId _selectedTaxType;
  String? _amountError;
  String? _submitError;
  bool _isSubmitting = false;

  TaxTypeId get selectedTaxType => _selectedTaxType;

  /// Validation message for the amount field, or `null`.
  String? get amountError => _amountError;

  /// Failure from the repository, or `null`. Rendered as an inline banner.
  String? get submitError => _submitError;

  bool get isSubmitting => _isSubmitting;

  /// True while the "Calculate Tax" button must be disabled.
  bool get canSubmit => !_isSubmitting;

  void selectTaxType(TaxTypeId taxType) {
    if (_selectedTaxType == taxType) return;
    _selectedTaxType = taxType;
    _amountError = null;
    _submitError = null;
    notifyListeners();
  }

  /// Validates and computes.
  ///
  /// Returns the [TaxCalculation] when it succeeds (so the caller can navigate
  /// to the result screen) or `null` when validation or the repository failed —
  /// in which case [amountError] or [submitError] explains why.
  Future<TaxCalculation?> submit(String rawAmount) async {
    final double? amount = parseAmountInput(rawAmount);
    if (amount == null) {
      _amountError = AppStrings.invalidAmountError;
      _submitError = null;
      notifyListeners();
      return null;
    }

    _amountError = null;
    _submitError = null;
    _isSubmitting = true;
    notifyListeners();

    try {
      return await _repository.calculate(
        taxType: _selectedTaxType,
        amount: amount,
      );
    } on AppException catch (error) {
      _submitError = error.message;
      return null;
    } catch (_) {
      _submitError = AppStrings.genericErrorMessage;
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}