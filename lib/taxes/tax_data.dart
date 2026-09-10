import 'package:flutter/material.dart';

class TaxType {
  const TaxType({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

class TaxBracket {
  const TaxBracket({required this.range, required this.rate});

  final String range;
  final String rate;
}

class TaxExample {
  const TaxExample({
    required this.income,
    required this.computation,
    required this.estimatedTax,
  });

  final String income;
  final String computation;
  final String estimatedTax;
}

class TaxDetailData {
  const TaxDetailData({
    required this.title,
    required this.description,
    required this.currentRate,
    required this.effectiveDate,
    required this.brackets,
    required this.example,
  });

  final String title;
  final String description;
  final String currentRate;
  final String effectiveDate;
  final List<TaxBracket> brackets;
  final TaxExample example;
}

const taxTypes = [
  TaxType(name: 'Personal Income Tax', icon: Icons.person_outline),
  TaxType(name: 'Corporate Income Tax', icon: Icons.business_center_outlined),
  TaxType(name: 'VAT', icon: Icons.receipt_long_outlined),
  TaxType(name: 'Percentage Tax', icon: Icons.percent_outlined),
  TaxType(name: 'CGT – Real Property', icon: Icons.home_outlined),
  TaxType(name: 'CGT – Shares', icon: Icons.show_chart_outlined),
  TaxType(name: 'Documentary Stamp Tax', icon: Icons.description_outlined),
  TaxType(name: 'Withholding Tax', icon: Icons.money_off_outlined),
  TaxType(name: 'Estate Tax', icon: Icons.gavel_outlined),
  TaxType(name: 'Real Property Tax', icon: Icons.location_city_outlined),
];

final taxDetails = <String, TaxDetailData>{
  'Personal Income Tax': const TaxDetailData(
    title: 'Personal Income Tax',
    description:
        'A tax imposed on an individual\'s net taxable income under the Philippine TRAIN Law.',
    currentRate: '0% – 35%',
    effectiveDate: 'January 1, 2023',
    brackets: [
      TaxBracket(range: '₱0 – ₱250,000', rate: '0%'),
      TaxBracket(range: '₱250,001 – ₱400,000', rate: '15% of excess over ₱250k'),
      TaxBracket(range: '₱400,001 – ₱800,000', rate: '₱22,500 + 20% of excess'),
      TaxBracket(range: '₱800,001 – ₱2,000,000', rate: '₱102,500 + 25% of excess'),
    ],
    example: TaxExample(
      income: '₱500,000',
      computation: '₱22,500 + 20%(₱100,000)',
      estimatedTax: '₱42,500',
    ),
  ),
  'Corporate Income Tax': const TaxDetailData(
    title: 'Corporate Income Tax',
    description:
        'A tax on the net taxable income of domestic and resident foreign corporations under the CREATE Law.',
    currentRate: '20% – 25%',
    effectiveDate: 'July 1, 2020',
    brackets: [
      TaxBracket(range: 'Net Taxable Income ≤ ₱5M', rate: '20% (MCIT)'),
      TaxBracket(range: 'Net Taxable Income > ₱5M', rate: '25%'),
      TaxBracket(range: 'Resident Foreign Corp.', rate: '25%'),
      TaxBracket(range: 'Non-Resident Foreign Corp.', rate: '30%'),
    ],
    example: TaxExample(
      income: '₱10,000,000',
      computation: '₱10,000,000 × 25%',
      estimatedTax: '₱2,500,000',
    ),
  ),
  'VAT': const TaxDetailData(
    title: 'VAT',
    description:
        'Value-Added Tax is a consumption tax placed on goods and services at each stage of the supply chain.',
    currentRate: '12%',
    effectiveDate: 'January 1, 2018',
    brackets: [
      TaxBracket(range: 'Goods & Services', rate: '12%'),
      TaxBracket(range: 'Export Sales', rate: '0%'),
      TaxBracket(range: 'Senior Citizens/PWD', rate: 'Exempt'),
    ],
    example: TaxExample(
      income: '₱100,000',
      computation: '₱100,000 × 12%',
      estimatedTax: '₱12,000',
    ),
  ),
  'Percentage Tax': const TaxDetailData(
    title: 'Percentage Tax',
    description:
        'A tax on persons or entities whose gross sales do not exceed the VAT threshold of ₱3,000,000.',
    currentRate: '3%',
    effectiveDate: 'January 1, 2018',
    brackets: [
      TaxBracket(range: 'Gross Sales ≤ ₱3M', rate: '3%'),
      TaxBracket(range: 'Gross Sales > ₱3M', rate: 'Subject to VAT'),
    ],
    example: TaxExample(
      income: '₱2,000,000',
      computation: '₱2,000,000 × 3%',
      estimatedTax: '₱60,000',
    ),
  ),
  'CGT – Real Property': const TaxDetailData(
    title: 'CGT – Real Property',
    description:
        'Capital Gains Tax on the sale of real property located in the Philippines classified as a capital asset.',
    currentRate: '6%',
    effectiveDate: 'January 1, 1998',
    brackets: [
      TaxBracket(range: 'Selling Price or Zonal Value', rate: '6%'),
      TaxBracket(range: 'Higher of the two', rate: '6%'),
    ],
    example: TaxExample(
      income: '₱5,000,000',
      computation: '₱5,000,000 × 6%',
      estimatedTax: '₱300,000',
    ),
  ),
  'CGT – Shares': const TaxDetailData(
    title: 'CGT – Shares',
    description:
        'Capital Gains Tax on the sale of shares of stock not traded through the local stock exchange.',
    currentRate: '5% – 10%',
    effectiveDate: 'January 1, 1998',
    brackets: [
      TaxBracket(range: 'Net Gain ≤ ₱100,000', rate: '5%'),
      TaxBracket(range: 'Net Gain > ₱100,000', rate: '10%'),
    ],
    example: TaxExample(
      income: '₱150,000 gain',
      computation: '₱100,000 × 5% + ₱50,000 × 10%',
      estimatedTax: '₱10,000',
    ),
  ),
  'Documentary Stamp Tax': const TaxDetailData(
    title: 'Documentary Stamp Tax',
    description:
        'A tax on documents, instruments, loan agreements and other papers showing the acceptance, assignment, or transfer of rights.',
    currentRate: '0.5% – 1.5%',
    effectiveDate: 'January 1, 2005',
    brackets: [
      TaxBracket(range: 'Loan Agreements', rate: '0.5%'),
      TaxBracket(range: 'Deeds of Sale', rate: '1.5%'),
      TaxBracket(range: 'Lease Agreements', rate: '0.5%'),
    ],
    example: TaxExample(
      income: '₱2,000,000 loan',
      computation: '₱2,000,000 × 0.5%',
      estimatedTax: '₱10,000',
    ),
  ),
  'Withholding Tax': const TaxDetailData(
    title: 'Withholding Tax',
    description:
        'A tax withheld by the payer of income to the payee at the prescribed rate on certain income payments.',
    currentRate: '1% – 15%',
    effectiveDate: 'January 1, 2018',
    brackets: [
      TaxBracket(range: 'Professional Fees', rate: '10%'),
      TaxBracket(range: 'Rentals', rate: '5%'),
      TaxBracket(range: 'Commissions', rate: '10%'),
    ],
    example: TaxExample(
      income: '₱100,000',
      computation: '₱100,000 × 10%',
      estimatedTax: '₱10,000',
    ),
  ),
  'Estate Tax': const TaxDetailData(
    title: 'Estate Tax',
    description:
        'A tax on the right to transmit the estate of a decedent to his lawful heirs and beneficiaries.',
    currentRate: '6%',
    effectiveDate: 'January 1, 1998',
    brackets: [
      TaxBracket(range: 'Net Estate ≤ ₱10M (exclusive)', rate: 'Exempt'),
      TaxBracket(range: 'Net Estate > ₱10M', rate: '6%'),
    ],
    example: TaxExample(
      income: '₱15,000,000',
      computation: '₱15,000,000 × 6%',
      estimatedTax: '₱900,000',
    ),
  ),
  'Real Property Tax': const TaxDetailData(
    title: 'Real Property Tax',
    description:
        'An annual ad valorem tax assessed by the local government unit on real property within its jurisdiction.',
    currentRate: '1% – 2%',
    effectiveDate: 'January 1, 1992',
    brackets: [
      TaxBracket(range: 'Basic RPT (City)', rate: '1%'),
      TaxBracket(range: 'Basic RPT (Province)', rate: '1%'),
      TaxBracket(range: 'Additional Levy (CND)', rate: 'Up to 1%'),
    ],
    example: TaxExample(
      income: '₱5,000,000 assessed value',
      computation: '₱5,000,000 × 1%',
      estimatedTax: '₱50,000',
    ),
  ),
};