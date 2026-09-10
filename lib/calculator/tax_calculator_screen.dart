import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';
import 'package:taxratesystem_mobile/calculator/calculation_result_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/taxes/tax_data.dart';

class TaxCalculatorScreen extends StatefulWidget {
  const TaxCalculatorScreen({
    super.key,
    this.initialTaxType,
    this.showAppBar = true,
  });

  final String? initialTaxType;
  final bool showAppBar;

  @override
  State<TaxCalculatorScreen> createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  late String _selectedTaxType;
  final _amountController = TextEditingController();
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _selectedTaxType = widget.initialTaxType ?? 'Personal Income Tax';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _calculate() {
    final parsed = double.tryParse(_amountController.text.replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      setState(() {
        _amountError = 'Enter a valid taxable amount';
      });
      return;
    }
    setState(() {
      _amountError = null;
    });
    final result = calculateTax(taxType: _selectedTaxType, amount: parsed);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalculationResultScreen(calculation: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: widget.showAppBar
          ? AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: AppColors.textDark),
              ),
              title: Text(
                'Tax Calculator',
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              backgroundColor: AppColors.surface,
              elevation: 0,
              centerTitle: false,
            )
          : null,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pageHorizontalPadding,
          12,
          AppDimens.pageHorizontalPadding,
          12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: AppDimens.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate_outlined, size: 20),
              label: const Text(
                'Calculate Tax',
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.focusBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: !widget.showAppBar,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pageHorizontalPadding,
            20,
            AppDimens.pageHorizontalPadding,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Tax Type',
                style: TextStyle(
                  fontSize: AppDimens.smallFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 24),
              Text(
                'Taxable Income (PHP)',
                style: TextStyle(
                  fontSize: AppDimens.smallFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _buildAmountField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputSoft,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTaxType,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          borderRadius: BorderRadius.circular(12),
          items: taxTypes
              .map(
                (type) => DropdownMenuItem(
                  value: type.name,
                  child: _HoverableMenuOption(label: type.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedTaxType = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      style: TextStyle(
        fontSize: AppDimens.bodyFontSize,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        prefixText: 'P ',
        prefixStyle: TextStyle(
          fontSize: AppDimens.bodyFontSize,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        filled: true,
        fillColor: AppColors.surface,
        hintText: 'Enter amount',
        hintStyle: TextStyle(
          fontSize: AppDimens.bodyFontSize,
          color: AppColors.textSecondary,
        ),
        helperText: 'Enter annual gross taxable income',
        helperStyle: TextStyle(
          fontSize: AppDimens.tinyFontSize,
          color: AppColors.textSecondary,
        ),
        errorText: _amountError,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.inputContentPaddingH,
          vertical: AppDimens.inputContentPaddingV,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          borderSide: BorderSide(
            color: _amountError == null
                ? AppColors.divider
                : AppColors.error,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.focusBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

class _HoverableMenuOption extends StatefulWidget {
  const _HoverableMenuOption({required this.label});

  final String label;

  @override
  State<_HoverableMenuOption> createState() => _HoverableMenuOptionState();
}

class _HoverableMenuOptionState extends State<_HoverableMenuOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.inputFill : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: AppDimens.bodyFontSize,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
