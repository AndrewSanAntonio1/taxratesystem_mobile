import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';

/// Icon for each [TaxTypeId].
///
/// Icons are a *presentation* concern, so this mapping lives in the
/// presentation layer instead of on the domain enum — the domain stays free of
/// any `package:flutter` import.
extension TaxTypeIdVisuals on TaxTypeId {
  IconData get icon => switch (this) {
        TaxTypeId.personalIncome => Icons.person_outline,
        TaxTypeId.corporateIncome => Icons.business_center_outlined,
        TaxTypeId.vat => Icons.receipt_long_outlined,
        TaxTypeId.percentage => Icons.percent_outlined,
        TaxTypeId.capitalGainsRealProperty => Icons.home_outlined,
        TaxTypeId.capitalGainsShares => Icons.show_chart_outlined,
        TaxTypeId.documentaryStamp => Icons.description_outlined,
        TaxTypeId.withholding => Icons.money_off_outlined,
        TaxTypeId.estate => Icons.gavel_outlined,
        TaxTypeId.realProperty => Icons.location_city_outlined,
      };
}
