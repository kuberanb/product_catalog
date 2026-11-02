import 'package:flutter/foundation.dart';

/// Holds favourite product IDs until the product repository is connected.
class FavouritesViewModel extends ChangeNotifier {
  final Set<String> _productIds = {};

  Set<String> get productIds => Set.unmodifiable(_productIds);

  bool get isEmpty => _productIds.isEmpty;

  bool contains(String productId) => _productIds.contains(productId);

  void toggle(String productId) {
    if (!_productIds.add(productId)) {
      _productIds.remove(productId);
    }
    notifyListeners();
  }
}
