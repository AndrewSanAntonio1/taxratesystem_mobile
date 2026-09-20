import 'package:flutter_test/flutter_test.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/core/state/view_state.dart';
import 'package:taxratesystem_mobile/data/repositories/in_memory_history_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_auth_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_tax_calculation_repository.dart';
import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/repositories/history_repository.dart';
import 'package:taxratesystem_mobile/domain/repositories/tax_calculation_repository.dart';
import 'package:taxratesystem_mobile/domain/services/tax_calculation_service.dart';
import 'package:taxratesystem_mobile/presentation/controllers/calculator_controller.dart';
import 'package:taxratesystem_mobile/presentation/controllers/history_controller.dart';
import 'package:taxratesystem_mobile/presentation/controllers/session_controller.dart';

/// Repository doubles: a controller must degrade to an error state, never throw
/// into the widget tree.
class _FailingHistoryRepository implements HistoryRepository {
  @override
  Future<List<SavedCalculation>> getHistory() async =>
      throw const StorageException('History unavailable');

  @override
  Future<void> add(SavedCalculation item) async =>
      throw const StorageException('History unavailable');

  @override
  Future<void> clear() async =>
      throw const StorageException('History unavailable');
}

class _FailingCalculationRepository implements TaxCalculationRepository {
  @override
  Future<TaxCalculation> calculate({
    required TaxTypeId taxType,
    required double amount,
  }) async =>
      throw const CalculationException('Calculation service unavailable');
}

void main() {
  const TaxCalculationService service = TaxCalculationService();

  TaxCalculation vatCalculation() =>
      service.calculate(taxType: TaxTypeId.vat, amount: 100000);

  group('HistoryController', () {
    test('reports loading, then empty for a fresh store', () async {
      final HistoryController controller =
          HistoryController(InMemoryHistoryRepository());

      final Future<void> pending = controller.load();
      expect(
        controller.state,
        isA<ViewStateLoading<List<SavedCalculation>>>(),
      );

      await pending;
      expect(controller.state, isA<ViewStateEmpty<List<SavedCalculation>>>());
      expect(controller.items, isEmpty);
    });

    test('exposes saved items newest first, and can flip the order', () async {
      final HistoryController controller =
          HistoryController(InMemoryHistoryRepository());

      await controller.save(
        SavedCalculation(
          calculation: vatCalculation(),
          savedAt: DateTime(2026, 9, 9),
        ),
      );
      await controller.save(
        SavedCalculation(
          calculation: vatCalculation(),
          savedAt: DateTime(2026, 9, 11),
        ),
      );

      expect(controller.state, isA<ViewStateData<List<SavedCalculation>>>());
      expect(controller.items.first.savedAt, DateTime(2026, 9, 11));

      controller.setSortOrder(HistorySortOrder.oldestFirst);
      expect(controller.items.first.savedAt, DateTime(2026, 9, 9));
    });

    test('surfaces storage failures as an error state', () async {
      final HistoryController controller =
          HistoryController(_FailingHistoryRepository());
      await controller.load();
      expect(controller.state, isA<ViewStateError<List<SavedCalculation>>>());
      expect(
        (controller.state as ViewStateError<List<SavedCalculation>>).message,
        'History unavailable',
      );
    });
  });

  group('CalculatorController', () {
    test('rejects an invalid amount without calling the repository', () async {
      final CalculatorController controller =
          CalculatorController(_FailingCalculationRepository());

      expect(await controller.submit(''), isNull);
      expect(controller.amountError, AppStrings.invalidAmountError);
      expect(controller.submitError, isNull);
      expect(controller.isSubmitting, isFalse);
    });

    test('returns the calculation on success and clears errors', () async {
      final CalculatorController controller =
          CalculatorController(const LocalTaxCalculationRepository());
      controller.selectTaxType(TaxTypeId.vat);

      final TaxCalculation? result = await controller.submit('100,000');

      expect(result, isNotNull);
      expect(result!.calculatedTax, 12000);
      expect(controller.amountError, isNull);
      expect(controller.submitError, isNull);
      expect(controller.isSubmitting, isFalse);
    });

    test('surfaces repository failures as submitError', () async {
      final CalculatorController controller =
          CalculatorController(_FailingCalculationRepository());

      expect(await controller.submit('100000'), isNull);
      expect(controller.submitError, 'Calculation service unavailable');
      expect(controller.amountError, isNull);
    });

    test('changing the tax type clears previous errors', () async {
      final CalculatorController controller =
          CalculatorController(_FailingCalculationRepository());

      await controller.submit('');
      expect(controller.amountError, isNotNull);

      controller.selectTaxType(TaxTypeId.estate);
      expect(controller.selectedTaxType, TaxTypeId.estate);
      expect(controller.amountError, isNull);
    });
  });

  group('SessionController', () {
    test('starts with no user and stays empty when nobody is signed in',
        () async {
      final SessionController controller =
          SessionController(LocalAuthRepository());

      expect(controller.state, isA<ViewStateEmpty>());
      await controller.ensureLoaded();
      expect(controller.user, isNull);
      expect(controller.isSignedIn, isFalse);
      expect(controller.errorMessage, isNull);
    });

    test('signs in and exposes the user to the profile screen', () async {
      final SessionController controller =
          SessionController(LocalAuthRepository());

      final bool ok = await controller.signIn(
        email: 'maria.santos@example.com',
        password: 'secret123',
      );

      expect(ok, isTrue);
      expect(controller.isSignedIn, isTrue);
      expect(controller.user!.displayName, 'Maria Santos');
      expect(controller.errorMessage, isNull);
    });

    test('reports a failure message for bad credentials', () async {
      final SessionController controller =
          SessionController(LocalAuthRepository());

      final bool ok =
          await controller.signIn(email: 'bad-email', password: 'secret123');

      expect(ok, isFalse);
      expect(controller.errorMessage, isNotNull);
      expect(controller.isSignedIn, isFalse);
    });

    test('signOut clears the session', () async {
      final SessionController controller =
          SessionController(LocalAuthRepository());

      await controller.signIn(email: 'a@b.com', password: 'secret123');
      await controller.signOut();

      expect(controller.isSignedIn, isFalse);
      expect(controller.state, isA<ViewStateEmpty>());
    });
  });
}