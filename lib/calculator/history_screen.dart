import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_decorations.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/core/formatters/tax_formatters.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/core/state/view_state.dart';
import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';
import 'package:taxratesystem_mobile/presentation/controllers/history_controller.dart';
import 'package:taxratesystem_mobile/widgets/state_views.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController _history;
  bool _didRequestLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _history = context.dependencies.historyController;
    // Loaded once per mount so a calculation saved from the result screen is
    // visible as soon as this tab is opened.
    if (_didRequestLoad) return;
    _didRequestLoad = true;
    _history.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: widget.showAppBar ? _buildAppBar(context) : null,
      body: SafeArea(
        top: !widget.showAppBar,
        child: Column(
          children: [
            if (!widget.showAppBar) _buildHeader(context),
            Expanded(
              child: ListenableBuilder(
                listenable: _history,
                builder: (context, _) => _buildBody(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Exhaustive over [ViewState], so "loading", "failed" and "nothing saved
  /// yet" can never be conflated with an empty result set.
  Widget _buildBody(BuildContext context) {
    return switch (_history.state) {
      ViewStateLoading<List<SavedCalculation>>() => const AppLoadingView(),
      ViewStateError<List<SavedCalculation>>(:final String message) =>
        AppErrorStateView(message: message, onRetry: _history.load),
      ViewStateEmpty<List<SavedCalculation>>() => const AppEmptyStateView(
          icon: Icons.history,
          title: AppStrings.noSavedCalculationsTitle,
          message: AppStrings.noSavedCalculationsMessage,
        ),
      ViewStateData<List<SavedCalculation>>() => _buildList(context),
    };
  }

  Widget _buildList(BuildContext context) {
    final List<SavedCalculation> items = _history.items;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalPadding,
        20,
        AppDimens.pageHorizontalPadding,
        24,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildHistoryCard(context, items[index]),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: AppColors.textDark),
      ),
      title: Text(
        AppStrings.calculationHistoryTitle,
        style: TextStyle(
          fontSize: AppDimens.bodyFontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      actions: [_buildSortMenu()],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pageHorizontalPadding,
        vertical: 16,
      ),
      decoration: BoxDecoration(color: AppColors.headerBackground),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.calculationHistoryTitle,
              style: TextStyle(
                fontSize: AppDimens.titleFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          _buildSortMenu(),
        ],
      ),
    );
  }

  Widget _buildSortMenu() {
    return ListenableBuilder(
      listenable: _history,
      builder: (context, _) => PopupMenuButton<HistorySortOrder>(
        icon: Icon(Icons.tune, color: AppColors.textSecondary),
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        ),
        onSelected: _history.setSortOrder,
        itemBuilder: (context) => [
          for (final HistorySortOrder order in HistorySortOrder.values)
            PopupMenuItem<HistorySortOrder>(
              value: order,
              child: Row(
                children: [
                  Icon(
                    _history.sortOrder == order ? Icons.check : Icons.sort,
                    size: 18,
                    color: _history.sortOrder == order
                        ? AppColors.focusBlue
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(order.label),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, SavedCalculation saved) {
    final calc = saved.calculation;
    return GestureDetector(
      onTap: () => context.pushSavedCalculation(saved),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    calc.taxType.label,
                    style: TextStyle(
                      fontSize: AppDimens.bodyFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Text(
                  formatShortDate(saved.savedAt),
                  style: TextStyle(
                    fontSize: AppDimens.smallFontSize,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildAmountRow(
              AppStrings.taxableBaseLabel,
              formatMoney(calc.taxableIncome),
            ),
            const SizedBox(height: 8),
            _buildAmountRow(
              AppStrings.calculatedTaxAmountLabel,
              formatMoney(calc.calculatedTax),
              highlighted: true,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.pushSavedCalculation(saved),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.focusBlue,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.viewDetails,
                  style: TextStyle(
                    fontSize: AppDimens.smallFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    String value, {
    bool highlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimens.subtitleFontSize,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppDimens.subtitleFontSize,
            fontWeight: FontWeight.w600,
            color: highlighted ? AppColors.focusBlue : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}