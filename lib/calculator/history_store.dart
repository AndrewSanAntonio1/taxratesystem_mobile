import 'package:flutter/foundation.dart';
import 'package:taxratesystem_mobile/calculator/calculation.dart';

class HistoryStore extends ChangeNotifier {
  HistoryStore._();

  static final HistoryStore instance = HistoryStore._();

  final List<SavedCalculation> _items = [];

  List<SavedCalculation> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  void add(SavedCalculation item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}