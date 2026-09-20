import 'package:flutter/foundation.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/core/state/view_state.dart';
import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';
import 'package:taxratesystem_mobile/domain/repositories/history_repository.dart';

/// The order saved calculations are listed in.
enum HistorySortOrder {
  newestFirst(AppStrings.sortNewestFirst),
  oldestFirst(AppStrings.sortOldestFirst);

  const HistorySortOrder(this.label);

  final String label;

  HistorySortOrder get toggled =>
      this == newestFirst ? oldestFirst : newestFirst;
}

/// Presentation state for the calculation history screen.
///
/// Holds a [ViewState] (loading / data / empty / error) instead of a bare list,
/// so the screen can never render "no history" while data is still loading, and
/// never crashes on a storage failure.
class HistoryController extends ChangeNotifier {
  HistoryController(this._repository);

  final HistoryRepository _repository;

  ViewState<List<SavedCalculation>> _state =
      const ViewStateLoading<List<SavedCalculation>>();
  HistorySortOrder _sortOrder = HistorySortOrder.newestFirst;

  ViewState<List<SavedCalculation>> get state => _state;

  HistorySortOrder get sortOrder => _sortOrder;

  /// The saved calculations in the currently selected [sortOrder].
  List<SavedCalculation> get items {
    final List<SavedCalculation> raw = _state.valueOrNull ?? const [];
    if (_sortOrder == HistorySortOrder.newestFirst) return raw;
    return List<SavedCalculation>.of(raw)
      ..sort(
        (SavedCalculation a, SavedCalculation b) =>
            a.savedAt.compareTo(b.savedAt),
      );
  }

  Future<void> load() async {
    _state = const ViewStateLoading<List<SavedCalculation>>();
    notifyListeners();
    await _guard(() async {
      final List<SavedCalculation> items = await _repository.getHistory();
      _state = items.isEmpty
          ? const ViewStateEmpty<List<SavedCalculation>>()
          : ViewStateData<List<SavedCalculation>>(items);
    });
  }

  /// Persists [item] and refreshes the list so any visible history is current.
  Future<void> save(SavedCalculation item) async {
    await _guard(() => _repository.add(item));
    await load();
  }

  Future<void> clear() async {
    await _guard(_repository.clear);
    await load();
  }

  void setSortOrder(HistorySortOrder order) {
    if (_sortOrder == order) return;
    _sortOrder = order;
    notifyListeners();
  }

  void toggleSortOrder() => setSortOrder(_sortOrder.toggled);

  /// Runs [action], converting any failure into an error [ViewState].
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on AppException catch (error) {
      _state = ViewStateError<List<SavedCalculation>>(error.message);
    } catch (_) {
      _state = const ViewStateError<List<SavedCalculation>>(
        AppStrings.genericErrorMessage,
      );
    }
    notifyListeners();
  }
}