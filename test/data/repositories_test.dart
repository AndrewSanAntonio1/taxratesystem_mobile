import 'package:flutter_test/flutter_test.dart';
import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/data/repositories/in_memory_history_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_auth_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_tax_calculation_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/static_tax_reference_repository.dart';
import 'package:taxratesystem_mobile/domain/models/app_user.dart';
import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_reference.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/services/tax_calculation_service.dart';
import 'package:taxratesystem_mobile/domain/tax_law/progressive_tax_bracket.dart';

void main() {
  const TaxCalculationService service = TaxCalculationService();

  SavedCalculation savedAt(DateTime when) => SavedCalculation(
        calculation: service.calculate(taxType: TaxTypeId.vat, amount: 100000),
        savedAt: when,
      );

  group('InMemoryHistoryRepository', () {
    test('starts empty and keeps the newest entry first', () async {
      final InMemoryHistoryRepository repository = InMemoryHistoryRepository();
      expect(await repository.getHistory(), isEmpty);

      await repository.add(savedAt(DateTime(2026, 9, 9)));
      await repository.add(savedAt(DateTime(2026, 9, 10)));

      final List<SavedCalculation> items = await repository.getHistory();
      expect(items.length, 2);
      expect(items.first.savedAt, DateTime(2026, 9, 10));
      expect(items.last.savedAt, DateTime(2026, 9, 9));
    });

    test('hands out an unmodifiable view', () async {
      final InMemoryHistoryRepository repository = InMemoryHistoryRepository();
      await repository.add(savedAt(DateTime(2026, 9, 9)));
      final List<SavedCalculation> items = await repository.getHistory();
      expect(
        () => items.add(savedAt(DateTime(2026, 9, 11))),
        throwsUnsupportedError,
      );
    });

    test('clear empties the store', () async {
      final InMemoryHistoryRepository repository = InMemoryHistoryRepository();
      await repository.add(savedAt(DateTime(2026, 9, 9)));
      await repository.clear();
      expect(await repository.getHistory(), isEmpty);
    });

    test('seeded instances do not share state', () async {
      final SavedCalculation seed = savedAt(DateTime(2026, 9, 9));
      final InMemoryHistoryRepository first =
          InMemoryHistoryRepository(seed: [seed]);
      final InMemoryHistoryRepository second = InMemoryHistoryRepository();
      expect((await first.getHistory()).length, 1);
      expect(await second.getHistory(), isEmpty);
    });
  });

  group('LocalTaxCalculationRepository', () {
    test('delegates to the domain service', () async {
      const LocalTaxCalculationRepository repository =
          LocalTaxCalculationRepository();
      final TaxCalculation result = await repository.calculate(
        taxType: TaxTypeId.vat,
        amount: 100000,
      );
      expect(result.calculatedTax, 12000);
    });

    test('translates ArgumentError into a domain CalculationException', () {
      const LocalTaxCalculationRepository repository =
          LocalTaxCalculationRepository();
      expect(
        () => repository.calculate(taxType: TaxTypeId.vat, amount: 0),
        throwsA(isA<CalculationException>()),
      );
    });
  });

  group('LocalAuthRepository', () {
    test('signs in and derives the profile from the e-mail', () async {
      final LocalAuthRepository repository = LocalAuthRepository();
      final AppUser user = await repository.signIn(
        email: '  Maria.Santos@Example.com ',
        password: 'secret123',
      );
      expect(user.email, 'maria.santos@example.com');
      expect(user.displayName, 'Maria Santos');
      expect(await repository.getCurrentUser(), isNotNull);
    });

    test('rejects a malformed e-mail', () {
      final LocalAuthRepository repository = LocalAuthRepository();
      expect(
        () => repository.signIn(email: 'nope', password: 'secret123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('rejects a password below the minimum length', () {
      final LocalAuthRepository repository = LocalAuthRepository();
      expect(
        () => repository.signIn(email: 'a@b.com', password: '123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('signOut clears the session', () async {
      final LocalAuthRepository repository = LocalAuthRepository();
      await repository.signIn(email: 'a@b.com', password: 'secret123');
      await repository.signOut();
      expect(await repository.getCurrentUser(), isNull);
    });
  });

  group('StaticTaxReferenceRepository', () {
    const StaticTaxReferenceRepository repository =
        StaticTaxReferenceRepository();

    test('publishes a detail record for every tax type', () async {
      final List<TaxTypeId> types = await repository.getSupportedTaxTypes();
      expect(types, TaxTypeId.values);
      for (final TaxTypeId type in types) {
        expect(await repository.getDetail(type), isNotNull, reason: type.id);
      }
    });

    test('personal income brackets mirror the engine table', () async {
      final TaxDetailData detail =
          (await repository.getDetail(TaxTypeId.personalIncome))!;
      // Regression: the screen listed 4 brackets while the engine applied 6.
      expect(detail.brackets.length, personalIncomeTaxBrackets.length);
      expect(detail.brackets.first.range, '₱0 – ₱250,000');
      expect(detail.brackets.first.rate, 'Exempt');
      expect(detail.brackets.last.range, 'Over ₱8,000,000');
      expect(detail.brackets.last.rate, '₱2,202,500 + 35% of excess');
    });

    test('estate tax states the ₱5M TRAIN deduction the engine uses', () async {
      final TaxDetailData detail =
          (await repository.getDetail(TaxTypeId.estate))!;
      // Regression: the screen claimed a ₱10M exemption; the engine uses ₱5M.
      expect(detail.brackets.first.range, contains('₱5M'));
      expect(detail.brackets.first.rate, 'Exempt');
      expect(detail.example.estimatedTax, '₱600,000');
      expect(detail.effectiveDate, 'January 1, 2018');
    });

    test('every tax type documents a computation example', () async {
      for (final TaxTypeId type in TaxTypeId.values) {
        final TaxDetailData detail = (await repository.getDetail(type))!;
        expect(
          detail.example.computation,
          isNotEmpty,
          reason: 'no example for ${type.id}',
        );
        expect(
          detail.example.estimatedTax,
          isNotEmpty,
          reason: 'no estimated tax for ${type.id}',
        );
      }
    });
  });
}