import 'package:flutter/foundation.dart';
import '../../../core/app_services.dart';
import '../../products/model/product.dart';

class FavouritesViewModel extends ChangeNotifier {
  FavouritesViewModel();

  final Map<int, Product> _products = {};
  List<Product> get products => List.unmodifiable(_products.values);
  bool get isEmpty => _products.isEmpty;
  bool isLoading = true;
  bool isSaving = false;
  String? error;
  bool _disposed = false;
  Product? _pending;
  bool contains(int id) => _products.containsKey(id);
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initialize() async {
    isLoading = true;
    error = null;
    _changed();
    try {
      final saved = await AppServices.store.readFavourites();
      _products
        ..clear()
        ..addEntries(saved.map((p) => MapEntry(p.id, p)));
    } catch (_) {
      error = 'favouritesError';
    }
    isLoading = false;
    _changed();
  }

  Future<void> toggle(Product product) async {
    if (isLoading || isSaving || _disposed) return;
    isSaving = true;
    error = null;
    _pending = product;
    _changed();
    final save = !contains(product.id);
    try {
      await AppServices.store.setFavourite(product, save);
      if (save) {
        _products[product.id] = product;
      } else {
        _products.remove(product.id);
      }
      _pending = null;
    } catch (_) {
      error = 'favouriteSaveError';
    }
    isSaving = false;
    _changed();
  }

  Future<void> retry() => _pending == null ? initialize() : toggle(_pending!);
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
