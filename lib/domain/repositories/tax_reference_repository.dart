import 'package:taxratesystem_mobile/domain/models/tax_reference.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';

/// Source of the "knowledge base" shown by the Taxes section: which tax types
/// exist and what the rules are.
///
/// Kept behind an interface because this content is a prime candidate for a
/// server-driven catalogue — the app must be able to refresh rates without a
/// store release.
abstract interface class TaxReferenceRepository {
  /// The tax types this build can explain, in display order.
  Future<List<TaxTypeId>> getSupportedTaxTypes();

  /// Reference detail for [taxType], or `null` when none is published.
  Future<TaxDetailData?> getDetail(TaxTypeId taxType);
}
