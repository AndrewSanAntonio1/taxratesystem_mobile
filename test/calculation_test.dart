import 'package:flutter_test/flutter_test.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';
import 'package:taxratesystem_mobile/calculator/history_store.dart';

void main() {
  group('formatMoney', () {
    test('formats with thousands separators and two decimals', () {
      expect(formatMoney(62500), '₱62,500.00');
      expect(formatMoney(600000), '₱600,000.00');
      expect(formatMoney(2202500.50), '₱2,202,500.50');
    });
  });

  group('Personal Income Tax', () {
    test('income of ₱600,000 yields ₱62,500', () {
      final result = calculateTax(taxType: 'Personal Income Tax', amount: 600000);
      expect(result.calculatedTax, 62500);
      expect(result.applicableBracket,
          '₱400,001 – ₱800,000 (20% excess rate)');
      expect(result.effectiveRule, 'TRAIN Law Series (Jan 1, 2023)');
      expect(result.breakdown.first.value, '₱22,500.00');
    });

    test('income up to ₱250,000 is exempt', () {
      final result = calculateTax(taxType: 'Personal Income Tax', amount: 200000);
      expect(result.calculatedTax, 0);
      expect(result.applicableBracket, '₱0 – ₱250,000 (Exempt)');
    });

    test('income over ₱8,000,000 applies 35% excess rate', () {
      final result = calculateTax(taxType: 'Personal Income Tax', amount: 9000000);
      expect(result.calculatedTax, 2202500 + ((9000000 - 8000000) * 0.35));
      expect(result.applicableBracket,
          'Over ₱8,000,000 (35% excess rate)');
    });
  });

  group('flat-rate taxes', () {
    test('VAT is 12% of gross sales', () {
      final result = calculateTax(taxType: 'VAT', amount: 100000);
      expect(result.calculatedTax, 12000);
    });

    test('Percentage Tax is 3% of gross sales', () {
      final result = calculateTax(taxType: 'Percentage Tax', amount: 2000000);
      expect(result.calculatedTax, 60000);
    });

    test('CGT – Real Property is 6%', () {
      final result = calculateTax(taxType: 'CGT – Real Property', amount: 5000000);
      expect(result.calculatedTax, 300000);
    });
  });

  group('CGT – Shares', () {
    test('gain of ₱150,000 yields ₱10,000', () {
      final result = calculateTax(taxType: 'CGT – Shares', amount: 150000);
      expect(result.calculatedTax, 10000);
      expect(
        result.applicableBracket,
        'Net Gain > ₱100,000 (10%)',
      );
    });

    test('gain up to ₱100,000 is 5%', () {
      final result = calculateTax(taxType: 'CGT – Shares', amount: 80000);
      expect(result.calculatedTax, 4000);
    });
  });

  group('Estate Tax', () {
    test('estate over ₱5M pays 6% on the excess', () {
      final result = calculateTax(taxType: 'Estate Tax', amount: 15000000);
      expect(result.calculatedTax, (15000000 - 5000000) * 0.06);
      expect(result.calculatedTax, 600000);
    });

    test('estate up to ₱5M is exempt', () {
      final result = calculateTax(taxType: 'Estate Tax', amount: 4000000);
      expect(result.calculatedTax, 0);
    });
  });

  group('date formatting', () {
    test('formats short and long dates', () {
      final date = DateTime(2026, 9, 10);
      expect(formatShortDate(date), 'Sep 10, 2026');
      expect(formatLongDate(date), 'September 10, 2026');
    });
  });

  group('HistoryStore', () {
    setUp(() {
      HistoryStore.instance.clear();
    });

    test('starts empty and adds newest first', () {
      expect(HistoryStore.instance.isEmpty, isTrue);

      HistoryStore.instance.add(
        SavedCalculation(
          calculation: calculateTax(taxType: 'VAT', amount: 100000),
          savedAt: DateTime(2026, 9, 9),
        ),
      );
      HistoryStore.instance.add(
        SavedCalculation(
          calculation: calculateTax(taxType: 'Personal Income Tax', amount: 600000),
          savedAt: DateTime(2026, 9, 10),
        ),
      );

      expect(HistoryStore.instance.items.length, 2);
      expect(
        HistoryStore.instance.items.first.calculation.taxType,
        'Personal Income Tax',
      );
      expect(HistoryStore.instance.isEmpty, isFalse);
    });
  });
}