/// Pure, Flutter-free formatting helpers for the tax domain.
///
/// These live in `core` (not in a model file) so that the domain layer and the
/// widget layer can share exactly one implementation of each format, and so
/// they can be unit-tested without a widget binding.
library;

import 'package:taxratesystem_mobile/constants/app_strings.dart';

const List<String> _monthNames = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Formats [amount] as Philippine pesos, e.g. `62500` -> `₱62,500.00`.
String formatMoney(double amount) {
  final bool negative = amount.isNegative;
  final List<String> parts = amount.abs().toStringAsFixed(2).split('.');
  final String digits = parts[0];
  final StringBuffer buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  final String sign = negative ? '-' : '';
  return '$sign${AppStrings.currencySymbol}$buffer.${parts[1]}';
}

/// Formats a fractional [rate] as a percentage, e.g. `0.12` -> `12%`.
///
/// Whole percentages lose their decimals, and trailing zeros are trimmed, so
/// `0.015` renders as `1.5%` rather than `1.50%`.
String formatPercent(double rate) {
  final double value = rate * 100;
  if (value == value.roundToDouble()) return '${value.round()}%';
  final String text = value.toStringAsFixed(2);
  return '${text.endsWith('0') ? text.substring(0, text.length - 1) : text}%';
}

/// `September 10, 2026`
String formatLongDate(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';

/// `Sep 10, 2026`
String formatShortDate(DateTime date) =>
    '${_monthNames[date.month - 1].substring(0, 3)} ${date.day}, ${date.year}';

/// Parses user input such as `1,250,000.50` into a number.
///
/// Returns `null` when the input is not a valid positive amount, so callers can
/// surface a single, consistent validation error.
double? parseAmountInput(String raw) {
  final String cleaned = raw.replaceAll(',', '').trim();
  if (cleaned.isEmpty) return null;
  final double? parsed = double.tryParse(cleaned);
  if (parsed == null || !parsed.isFinite || parsed <= 0) return null;
  return parsed;
}