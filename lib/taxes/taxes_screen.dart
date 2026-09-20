import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_decorations.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/domain/models/tax_type_id.dart';
import 'package:taxratesystem_mobile/presentation/tax_type_visuals.dart';
import 'package:taxratesystem_mobile/widgets/state_views.dart';

/// Lists every tax type the catalogue publishes.
///
/// The list comes from [TaxReferenceRepository] rather than a hard-coded
/// constant, so it renders loading, empty and error states like any other
/// remote-backed screen and is ready for a server-driven catalogue.
class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  /// Created in [didChangeDependencies] (not in `build`) so a rebuild does not
  /// re-issue the request — the classic `FutureBuilder` pitfall.
  late Future<List<TaxTypeId>> _taxTypes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _taxTypes = _loadTaxTypes();
  }

  Future<List<TaxTypeId>> _loadTaxTypes() =>
      context.dependencies.taxReferenceRepository.getSupportedTaxTypes();

  void _retry() => setState(() {
        _taxTypes = _loadTaxTypes();
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: FutureBuilder<List<TaxTypeId>>(
            future: _taxTypes,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const AppLoadingView();
              }
              if (snapshot.hasError) {
                return AppErrorStateView(
                  message: AppStrings.genericErrorMessage,
                  onRetry: _retry,
                );
              }
              final List<TaxTypeId> types = snapshot.data ?? const [];
              if (types.isEmpty) {
                return const AppEmptyStateView(
                  icon: Icons.receipt_long_outlined,
                  title: AppStrings.noTaxTypesTitle,
                  message: AppStrings.noTaxTypesMessage,
                );
              }
              return _buildList(types);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<TaxTypeId> types) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalPadding,
        20,
        AppDimens.pageHorizontalPadding,
        24,
      ),
      itemCount: types.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildTaxTypeTile(context, types[index]),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalPadding,
        16,
        AppDimens.pageHorizontalPadding,
        20,
      ),
      decoration: BoxDecoration(color: AppColors.headerBackground),
      child: SafeArea(
        bottom: false,
        child: Text(
          AppStrings.taxesTitle,
          style: TextStyle(
            fontSize: AppDimens.headerFontSize - 2,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildTaxTypeTile(BuildContext context, TaxTypeId taxType) {
    return InkWell(
      onTap: () => context.pushTaxDetail(taxType),
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppDecorations.outlinedPanel,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
              ),
              child: Icon(taxType.icon, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                taxType.label,
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}