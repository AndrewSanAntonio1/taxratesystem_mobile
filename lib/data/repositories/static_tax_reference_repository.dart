import 'package:taxratesystem_mobile/domain/models/tax_reference.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/domain/repositories/tax_reference_repository.dart';
import 'package:taxratesystem_mobile/domain/tax_law/progressive_tax_bracket.dart';

/// Ships the tax knowledge base compiled into the app.
///
/// Replaces the former `taxes/tax_data.dart`, which was a bare top-level map that
/// screens reached for directly. Two classes of defect were fixed while porting
/// the data here:
///
/// * The **personal income tax bracket table** was hard-coded and had drifted
///   from the engine (four rows listed, six implemented). It is now *derived*
///   from [personalIncomeTaxBrackets], the same table the engine computes from.
/// * The **estate tax** row claimed an exemption up to ₱10M while the engine
///   applied the correct TRAIN standard deduction of ₱5M, and its worked example
///   (₱15M × 6% = ₱900,000) contradicted the engine's ₱600,000.
class StaticTaxReferenceRepository implements TaxReferenceRepository {
  const StaticTaxReferenceRepository();

  @override
  Future<List<TaxTypeId>> getSupportedTaxTypes() async => TaxTypeId.values;

  @override
  Future<TaxDetailData?> getDetail(TaxTypeId taxType) async => _details[taxType];

  /// Built once, on first access.
  static final Map<TaxTypeId, TaxDetailData> _details =
      <TaxTypeId, TaxDetailData>{
    TaxTypeId.personalIncome: TaxDetailData(
      description:
          "A tax imposed on an individual's net taxable income under the "
          'Philippine TRAIN Law.',
      currentRate: '0% – 35%',
      effectiveDate: 'January 1, 2023',
      brackets: personalIncomeTaxBrackets
          .map(
            (ProgressiveBracket bracket) => TaxBracket(
              range: bracket.label,
              rate: bracket.rateDescription,
            ),
          )
          .toList(growable: false),
      example: const TaxExample(
        amount: '₱600,000',
        computation: '₱22,500 + 20% of ₱200,000',
        estimatedTax: '₱62,500',
      ),
    ),
    TaxTypeId.corporateIncome: const TaxDetailData(
      description:
          'A tax on the net taxable income of domestic and resident foreign '
          'corporations under the CREATE Law.',
      currentRate: '20% – 25%',
      effectiveDate: 'July 1, 2020',
      brackets: <TaxBracket>[
        TaxBracket(
          range: 'Domestic corp., net taxable income ≤ ₱5M',
          rate: '20% (CREATE reduced rate)',
        ),
        TaxBracket(range: 'Domestic corp., net taxable income > ₱5M', rate: '25%'),
        TaxBracket(range: 'Resident foreign corp.', rate: '25%'),
        TaxBracket(range: 'Non-resident foreign corp.', rate: '30%'),
      ],
      example: TaxExample(
        amount: '₱10,000,000',
        computation: '₱10,000,000 × 25%',
        estimatedTax: '₱2,500,000',
      ),
    ),
    TaxTypeId.vat: const TaxDetailData(
      description:
          'Value-Added Tax is a consumption tax levied on the sale of goods and '
          'services at each stage of the supply chain.',
      currentRate: '12%',
      effectiveDate: 'January 1, 2018',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Sale of goods or properties', rate: '12%'),
        TaxBracket(range: 'Sale of services', rate: '12%'),
        TaxBracket(range: 'Importation of goods', rate: '12%'),
      ],
      example: TaxExample(
        amount: '₱100,000',
        computation: '₱100,000 × 12%',
        estimatedTax: '₱12,000',
      ),
    ),
    TaxTypeId.percentage: const TaxDetailData(
      description:
          'A business tax on gross sales or receipts of non-VAT registered '
          'taxpayers whose annual gross sales fall below the VAT threshold.',
      currentRate: '3%',
      effectiveDate: 'January 1, 2018',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Gross sales or receipts ≤ ₱3M', rate: '3%'),
        TaxBracket(range: 'VAT-registered taxpayers', rate: 'Not applicable'),
      ],
      example: TaxExample(
        amount: '₱2,000,000',
        computation: '₱2,000,000 × 3%',
        estimatedTax: '₱60,000',
      ),
    ),
    TaxTypeId.capitalGainsRealProperty: const TaxDetailData(
      description:
          'Capital Gains Tax on the sale of real property located in the '
          'Philippines classified as a capital asset.',
      currentRate: '6%',
      effectiveDate: 'January 1, 1998',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Selling price or zonal value', rate: '6%'),
        TaxBracket(range: 'Higher of the two', rate: '6%'),
        TaxBracket(range: 'Sale of principal residence (exemption)', rate: 'Exempt'),
      ],
      example: TaxExample(
        amount: '₱5,000,000',
        computation: '₱5,000,000 × 6%',
        estimatedTax: '₱300,000',
      ),
    ),
    TaxTypeId.capitalGainsShares: const TaxDetailData(
      description:
          'Capital Gains Tax on the sale of shares of stock not traded through '
          'the local stock exchange.',
      currentRate: '5% – 10%',
      effectiveDate: 'January 1, 1998',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Net gain ≤ ₱100,000', rate: '5%'),
        TaxBracket(range: 'Net gain > ₱100,000', rate: '10% of the excess'),
      ],
      example: TaxExample(
        amount: '₱150,000 net gain',
        computation: '₱5,000 + 10% of ₱50,000',
        estimatedTax: '₱10,000',
      ),
    ),
    TaxTypeId.documentaryStamp: const TaxDetailData(
      description:
          'A tax on documents, instruments, loan agreements and other papers '
          'showing the acceptance, assignment or transfer of rights.',
      currentRate: '0.5% – 1.5%',
      effectiveDate: 'January 1, 2005',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Loan agreements', rate: '0.5%'),
        TaxBracket(range: 'Deeds of sale', rate: '1.5%'),
        TaxBracket(range: 'Lease agreements', rate: '0.5%'),
      ],
      example: TaxExample(
        amount: '₱2,000,000 deed of sale',
        computation: '₱2,000,000 × 1.5%',
        estimatedTax: '₱30,000',
      ),
    ),
    TaxTypeId.withholding: const TaxDetailData(
      description:
          'A tax withheld by the payer of income from the payee at the '
          'prescribed rate on certain income payments.',
      currentRate: '1% – 15%',
      effectiveDate: 'January 1, 2018',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Professional fees', rate: '10%'),
        TaxBracket(range: 'Rentals', rate: '5%'),
        TaxBracket(range: 'Commissions', rate: '10%'),
      ],
      example: TaxExample(
        amount: '₱100,000 professional fees',
        computation: '₱100,000 × 10%',
        estimatedTax: '₱10,000',
      ),
    ),
    TaxTypeId.estate: const TaxDetailData(
      description:
          'A tax on the right to transmit the estate of a decedent to the '
          'lawful heirs and beneficiaries.',
      currentRate: '6%',
      effectiveDate: 'January 1, 2018',
      brackets: <TaxBracket>[
        TaxBracket(
          range: 'Net estate ≤ ₱5M (standard deduction)',
          rate: 'Exempt',
        ),
        TaxBracket(range: 'Net estate > ₱5M', rate: '6% of the excess'),
      ],
      example: TaxExample(
        amount: '₱15,000,000',
        computation: '₱15,000,000 − ₱5,000,000 = ₱10,000,000 × 6%',
        estimatedTax: '₱600,000',
      ),
    ),
    TaxTypeId.realProperty: const TaxDetailData(
      description:
          'An annual ad valorem tax assessed by the local government unit on '
          'real property within its jurisdiction.',
      currentRate: '1% – 2%',
      effectiveDate: 'January 1, 1992',
      brackets: <TaxBracket>[
        TaxBracket(range: 'Basic RPT (city or municipality)', rate: '1%'),
        TaxBracket(range: 'Basic RPT (province)', rate: '1%'),
        TaxBracket(range: 'Additional levy (Special Education Fund)', rate: 'Up to 1%'),
      ],
      example: TaxExample(
        amount: '₱5,000,000 assessed value',
        computation: '₱5,000,000 × 1%',
        estimatedTax: '₱50,000',
      ),
    ),
  };
}
