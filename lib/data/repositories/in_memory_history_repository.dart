import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';
import 'package:taxratesystem_mobile/domain/repositories/history_repository.dart';

/// In-memory [HistoryRepository].
///
/// Intentionally simple: the app has no persistence dependency yet, and this
/// class is the seam where `sqflite`, `shared_preferences` or a remote history
/// API will plug in. Swapping it changes no widget code.
///
/// The instance is *injected* rather than globally reachable, so tests get a
/// clean store per test and cannot leak state into each other.
class InMemoryHistoryRepository implements HistoryRepository {
  InMemoryHistoryRepository({List<SavedCalculation> seed = const []})
      : _items = List<SavedCalculation>.of(seed);

  final List<SavedCalculation> _items;

  @override
  Future<List<SavedCalculation>> getHistory() async =>
      List<SavedCalculation>.unmodifiable(_items);

  @override
  Future<void> add(SavedCalculation item) async {
    _items.insert(0, item);
  }

  @override
  Future<void> clear() async {
    _items.clear();
  }
}
