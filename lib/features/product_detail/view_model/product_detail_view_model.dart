import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_service.dart';
import '../../../core/app_services.dart';
import '../../products/model/product.dart';

class ProductDetailViewModel extends ChangeNotifier {
  int? productId;
  Product? product;
  bool isLoading = false;
  String? error;
  bool _disposed = false;
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  void selectProduct({required int id, Product? selectedProduct}) {
    productId = id;
    product = selectedProduct;
    error = null;
    _changed();
  }

  Future<void> load() async {
    if (isLoading || _disposed) return;
    final id = productId;
    if (id == null) {
      error = 'detailsError';
      _changed();
      return;
    }
    isLoading = true;
    error = null;
    _changed();
    try {
      final cached = await AppServices.store.read('product_$id');
      if (cached != null) {
        product = Product.fromJson(jsonDecode(cached) as Map<String, dynamic>);
        _changed();
      }
    } catch (_) {
      /* Keep the product passed from the list if the cache fails. */
    }
    try {
      final response = await AppServices.api.get<Map<String, dynamic>>(
        ApiEndpoints.productDetails(id),
      );
      product = Product.fromJson(response.data!);
      try {
        await AppServices.store.write(
          'product_$id',
          jsonEncode(product!.toJson()),
        );
      } catch (_) {
        error = 'cacheError';
      }
    } on ApiException catch (e) {
      error = e.message == 'offline' ? 'offline' : 'detailsError';
    } catch (_) {
      error = 'detailsError';
    } finally {
      isLoading = false;
      _changed();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
