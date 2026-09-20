import 'package:flutter_test/flutter_test.dart';
import 'package:taxratesystem_mobile/core/formatters/tax_formatters.dart';

void main() {
  group('formatMoney', () {
    test('formats with thousands separators and two decimals', () {
      expect(formatMoney(62500), '₱62,500.00');
      expect(formatMoney(600000), '₱600,000.00');
      expect(formatMoney(2202500.50), '₱2,202,500.50');
    });

    test('handles zero and negatives', () {
      expect(formatMoney(0), '₱0.00');
      expect(formatMoney(-1500), '-₱1,500.00');
    });
  });

  group('formatPercent', () {
    test('drops decimals for whole rates', () {
      expect(formatPercent(0.12), '12%');
      expect(formatPercent(0.20), '20%');
      expect(formatPercent(0), '0%');
    });

    test('trims trailing zeros for fractional rates', () {
      expect(formatPercent(0.015), '1.5%');
      expect(formatPercent(0.0025), '0.25%');
    });
  });

  group('date formatting', () {
    test('formats short and long dates', () {
      final DateTime date = DateTime(2026, 9, 10);
      expect(formatShortDate(date), 'Sep 10, 2026');
      expect(formatLongDate(date), 'September 10, 2026');
    });
  });

  group('parseAmountInput', () {
    test('accepts thousands separators and decimals', () {
      expect(parseAmountInput('1,250,000'), 1250000);
      expect(parseAmountInput(' 1250.50 '), 1250.5);
    });

    test('rejects empty, non-numeric and non-positive input', () {
      expect(parseAmountInput(''), isNull);
      expect(parseAmountInput('   '), isNull);
      expect(parseAmountInput('abc'), isNull);
      expect(parseAmountInput('0'), isNull);
      expect(parseAmountInput('-10'), isNull);
      expect(parseAmountInput('Infinity'), isNull);
    });
  });
}