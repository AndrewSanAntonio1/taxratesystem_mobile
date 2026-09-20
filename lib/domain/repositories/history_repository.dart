import 'package:taxratesystem_mobile/domain/models/saved_calculation.dart';

/// Persistence boundary for the user's saved calculations.
///
/// The UI depends on this interface only, never on a concrete store, so the
/// in-memory implementation used today can be swapped for a `sqflite` or
/// remote-backed implementation without touching a widget (Dependency Inversion).
abstract interface class HistoryRepository {
  /// Returns the saved calculations, newest first.
  Future<List<SavedCalculation>> getHistory();

  /// Persists [item], placing it at the front of the history.
  Future<void> add(SavedCalculation item);

  /// Removes every saved calculation.
  Future<void> clear();
}
