import 'package:flutter_test/flutter_test.dart';
import 'package:taxratesystem_mobile/domain/models/tax_calculation.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/services/tax_calculation_service.dart';

/// Tax-law regression suite.
///
/// Every assertion that existed before the layering refactor is preserved here
/// unchanged — the engine was moved, not re-specified.
void main() {
  const TaxCalculationService service = TaxCalculationService();

  group('Personal Income Tax', () {
    test('income of ₱600,000 yields ₱62,500', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.personalIncome,
        amount: 600000,
      );
      expect(result.calculatedTax, 62500);
      expect(
        result.applicableBracket,
        '₱400,001 – ₱800,000 (20% excess rate)',
      );
      expect(result.effectiveRule, 'TRAIN Law Series (Jan 1, 2023)');
      expect(result.breakdown.first.value, '₱22,500.00');
    });

    test('income up to ₱250,000 is exempt', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.personalIncome,
        amount: 200000,
      );
      expect(result.calculatedTax, 0);
      expect(result.applicableBracket, '₱0 – ₱250,000 (Exempt)');
    });

    test('income over ₱8,000,000 applies 35% excess rate', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.personalIncome,
        amount: 9000000,
      );
      expect(result.calculatedTax, 2202500 + ((9000000 - 8000000) * 0.35));
      expect(result.applicableBracket, 'Over ₱8,000,000 (35% excess rate)');
    });

    test('boundary income of ₱250,000 stays exempt', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.personalIncome,
        amount: 250000,
      );
      expect(result.calculatedTax, 0);
    });

    test('income of ₱2,500,000 applies the 30% bracket', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.personalIncome,
        amount: 2500000,
      );
      expect(result.calculatedTax, 402500 + (500000 * 0.30));
    });
  });

  group('flat-rate taxes', () {
    test('VAT is 12% of gross sales', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.vat,
        amount: 100000,
      );
      expect(result.calculatedTax, 12000);
    });

    test('Percentage Tax is 3% of gross sales', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.percentage,
        amount: 2000000,
      );
      expect(result.calculatedTax, 60000);
    });

    test('CGT – Real Property is 6%', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.capitalGainsRealProperty,
        amount: 5000000,
      );
      expect(result.calculatedTax, 300000);
    });

    test('Documentary Stamp Tax is 1.5% and states the rate once', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.documentaryStamp,
        amount: 2000000,
      );
      expect(result.calculatedTax, 30000);
      expect(result.applicableBracket, 'Deeds of Sale (1.5%)');
    });

    test('Withholding Tax is 10% of the gross payment', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.withholding,
        amount: 100000,
      );
      expect(result.calculatedTax, 10000);
    });

    test('Real Property Tax is 1% of assessed value', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.realProperty,
        amount: 5000000,
      );
      expect(result.calculatedTax, 50000);
    });
  });

  group('CGT – Shares', () {
    test('gain of ₱150,000 yields ₱10,000', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.capitalGainsShares,
        amount: 150000,
      );
      expect(result.calculatedTax, 10000);
      expect(result.applicableBracket, 'Net Gain > ₱100,000 (10%)');
    });

    test('gain up to ₱100,000 is 5%', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.capitalGainsShares,
        amount: 80000,
      );
      expect(result.calculatedTax, 4000);
    });
  });

  group('Estate Tax', () {
    test('estate over ₱5M pays 6% on the excess', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.estate,
        amount: 15000000,
      );
      expect(result.calculatedTax, (15000000 - 5000000) * 0.06);
      expect(result.calculatedTax, 600000);
    });

    test('estate up to ₱5M is exempt', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.estate,
        amount: 4000000,
      );
      expect(result.calculatedTax, 0);
    });

    test('₱5M boundary is exempt, ₱1 above is not', () {
      expect(
        service
            .calculate(taxType: TaxTypeId.estate, amount: 5000000)
            .calculatedTax,
        0,
      );
      expect(
        service
            .calculate(taxType: TaxTypeId.estate, amount: 5000001)
            .calculatedTax,
        closeTo(0.06, 0.0001),
      );
    });
  });

  group('Corporate Income Tax', () {
    test('applies the 20% CREATE rate at or below ₱5M', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.corporateIncome,
        amount: 5000000,
      );
      expect(result.calculatedTax, 1000000);
      expect(result.applicableBracket, 'Net Taxable Income ≤ ₱5M (20%)');
    });

    test('applies 25% above ₱5M', () {
      final TaxCalculation result = service.calculate(
        taxType: TaxTypeId.corporateIncome,
        amount: 10000000,
      );
      expect(result.calculatedTax, 2500000);
    });
  });

  group('service contract', () {
    test('every tax type is computable — the switch is exhaustive', () {
      for (final TaxTypeId type in TaxTypeId.values) {
        final TaxCalculation result =
            service.calculate(taxType: type, amount: 1000000);
        expect(result.taxType, type, reason: 'wrong type for ${type.id}');
        expect(result.breakdown, isNotEmpty, reason: 'no steps for ${type.id}');
        expect(
          result.breakdown.last.label,
          'Total Tax Due',
          reason: 'missing total for ${type.id}',
        );
      }
    });

    test('rejects non-positive and non-finite amounts', () {
      expect(
        () => service.calculate(taxType: TaxTypeId.vat, amount: 0),
        throwsArgumentError,
      );
      expect(
        () => service.calculate(taxType: TaxTypeId.vat, amount: -1),
        throwsArgumentError,
      );
      expect(
        () =>
            service.calculate(taxType: TaxTypeId.vat, amount: double.infinity),
        throwsArgumentError,
      );
    });
  });
}