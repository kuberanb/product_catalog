import 'dart:convert';
import 'package:dio/dio.dart';
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
  int _selection = 0;
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  void selectProduct({required int id, Product? selectedProduct}) {
    _selection++;
    isLoading = false;
    productId = id;
    product = selectedProduct;
    error = null;
    _changed();
  }

  Future<void> load() async {
    if (isLoading || _disposed) return;
    final id = productId;
    final selection = _selection;
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
      if (_disposed || selection != _selection) return;
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
      if (_disposed || selection != _selection) return;
      product = Product.fromJson(response.data!);
      try {
        await AppServices.store.write(
          'product_$id',
          jsonEncode(product!.toJson()),
        );
      } catch (_) {
        if (selection == _selection) error = 'cacheError';
      }
    } on ApiException catch (e) {
      if (selection == _selection) {
        error = e.message == 'offline' ? 'offline' : 'detailsError';
      }
    } on DioException catch (e) {
      if (_disposed || selection != _selection) return;
      if (e.response?.statusCode == 404) product = null;
      error = e.response?.statusCode == 404
          ? 'productNotFound'
          : e.response == null
          ? 'offline'
          : 'detailsError';
    } catch (_) {
      if (selection == _selection) error = 'detailsError';
    } finally {
      if (selection == _selection) {
        isLoading = false;
        _changed();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
