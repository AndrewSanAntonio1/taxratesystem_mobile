/// The tax types the system knows how to explain and compute.
///
/// This enum replaces the string literals that were previously duplicated
/// across the reference data, the calculation engine and the calculator
/// dropdown. Because it is an enum, `switch` statements over it are exhaustive:
/// adding a new tax type becomes a **compile-time** error in every place that
/// must handle it, instead of a silent runtime failure.
///
/// [id] is the stable, transport-safe key intended for the backend API and any
/// future persistence (`vat`, `cgt_real_property`, ...). [label] is the
/// display string shown in the UI.
enum TaxTypeId {
  personalIncome('personal_income_tax', 'Personal Income Tax'),
  corporateIncome('corporate_income_tax', 'Corporate Income Tax'),
  vat('vat', 'VAT'),
  percentage('percentage_tax', 'Percentage Tax'),
  capitalGainsRealProperty('cgt_real_property', 'CGT – Real Property'),
  capitalGainsShares('cgt_shares', 'CGT – Shares'),
  documentaryStamp('documentary_stamp_tax', 'Documentary Stamp Tax'),
  withholding('withholding_tax', 'Withholding Tax'),
  estate('estate_tax', 'Estate Tax'),
  realProperty('real_property_tax', 'Real Property Tax');

  const TaxTypeId(this.id, this.label);

  /// Stable key for APIs / persistence. Never derive this from [label].
  final String id;

  /// Human-readable name rendered in the UI.
  final String label;

  /// Resolves a transport-safe [id] coming from the API, or `null` when the
  /// payload references a tax type this build does not know about yet.
  static TaxTypeId? fromId(String id) {
    for (final TaxTypeId type in TaxTypeId.values) {
      if (type.id == id) return type;
    }
    return null;
  }
}
