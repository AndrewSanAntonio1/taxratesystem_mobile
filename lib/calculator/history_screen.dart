import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';
import 'package:taxratesystem_mobile/calculator/history_store.dart';
import 'package:taxratesystem_mobile/calculator/saved_calculation_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

enum _SortOrder { newest, oldest }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _SortOrder _sortOrder = _SortOrder.newest;

  List<SavedCalculation> _sortedItems(HistoryStore store) {
    final items = store.items;
    if (_sortOrder == _SortOrder.newest) {
      return items;
    }
    return [...items]..sort((a, b) => a.savedAt.compareTo(b.savedAt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: SafeArea(
        top: !widget.showAppBar,
        child: Column(
          children: [
            if (!widget.showAppBar) _buildHeader(),
            Expanded(
              child: ListenableBuilder(
                listenable: HistoryStore.instance,
                builder: (context, _) {
                  final items = _sortedItems(HistoryStore.instance);
                  if (items.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.pageHorizontalPadding,
                      20,
                      AppDimens.pageHorizontalPadding,
                      24,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _buildHistoryCard(context, items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: AppColors.textDark),
      ),
      title: Text(
        'Calculation History',
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalPadding,
        16,
        AppDimens.pageHorizontalPadding,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Calculation History',
              style: TextStyle(
                fontSize: 22,
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
    return PopupMenuButton<_SortOrder>(
      icon: Icon(Icons.tune, color: AppColors.textSecondary),
      tooltip: 'Sort',
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        setState(() {
          _sortOrder = value;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _SortOrder.newest,
          child: Row(
            children: [
              Icon(
                _sortOrder == _SortOrder.newest
                    ? Icons.check
                    : Icons.arrow_downward,
                size: 18,
                color: _sortOrder == _SortOrder.newest
                    ? AppColors.focusBlue
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              const Text('Newest first'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _SortOrder.oldest,
          child: Row(
            children: [
              Icon(
                _sortOrder == _SortOrder.oldest
                    ? Icons.check
                    : Icons.arrow_upward,
                size: 18,
                color: _sortOrder == _SortOrder.oldest
                    ? AppColors.focusBlue
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              const Text('Oldest first'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppDimens.pageHorizontalPadding),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.inputSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 34,
                color: AppColors.focusBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No calculation history yet.',
              style: TextStyle(
                fontSize: AppDimens.bodyFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your saved tax calculations will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimens.subtitleFontSize,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, SavedCalculation saved) {
    final calc = saved.calculation;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SavedCalculationScreen(saved: saved),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    calc.taxType,
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
              'Taxable Amount',
              formatMoney(calc.taxableIncome),
            ),
            const SizedBox(height: 8),
            _buildAmountRow(
              'Tax Calculated',
              formatMoney(calc.calculatedTax),
              highlighted: true,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SavedCalculationScreen(saved: saved),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.focusBlue,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View Details >',
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

  Widget _buildAmountRow(String label, String value, {bool highlighted = false}) {
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
