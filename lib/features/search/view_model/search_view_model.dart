import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/api_endpoints.dart';
import '../../../core/api_service.dart';
import '../../../core/app_services.dart';
import '../../products/model/product.dart';

class SearchViewModel extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  String query = '';
  String? error;
  bool isLoading = false;
  bool hasMore = false;

  CancelToken? _request;
  Timer? _debounce;
  bool _disposed = false;

  bool get isOffline => error == 'offline';

  void setQuery(String value) {
    query = value.trim();
    _debounce?.cancel();
    _request?.cancel();
    isLoading = false;
    error = null;
    _products.clear();
    hasMore = false;
    _notify();

    if (query.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 350), () => search(query));
    }
  }

  Future<void> search([String? value]) async {
    _debounce?.cancel();
    _request?.cancel();
    query = (value ?? query).trim();
    _products.clear();
    hasMore = false;
    error = null;
    isLoading = false;
    _notify();

    if (query.isNotEmpty) await loadMore();
  }

  Future<void> loadMore() async {
    if (_disposed || isLoading || query.isEmpty) return;

    final request = CancelToken();
    _request = request;
    isLoading = true;
    error = null;
    _notify();

    try {
      final response = await AppServices.api.get<Map<String, dynamic>>(
        ApiEndpoints.searchProducts,
        queryParameters: {'q': query, 'limit': 20, 'skip': _products.length},
        cancelToken: request,
      );
      if (_disposed || request.isCancelled) return;

      final body = response.data!;
      final page = (body['products'] as List)
          .map(
            (item) => Product.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
      _products.addAll(page);
      hasMore = page.isNotEmpty && _products.length < (body['total'] as num);
    } catch (exception) {
      if (_disposed || request.isCancelled) return;

      final offline = exception is ApiException
          ? exception.message == 'offline'
          : exception is DioException && exception.response == null;
      error = offline ? 'offline' : 'searchError';
      if (offline) _loadCachedMatches();
    } finally {
      if (!_disposed && !request.isCancelled) {
        isLoading = false;
        _notify();
      }
    }
  }

  void _loadCachedMatches() {
    final term = query.toLowerCase();
    final matches = <int, Product>{};
    for (final product in AppServices.cachedProducts) {
      final text =
          '${product.title} ${product.description} ${product.brand} ${product.sku} ${product.barcode}'
              .toLowerCase();
      if (text.contains(term)) matches[product.id] = product;
    }
    _products.addAll(matches.values);
  }

  Future<void> retry() => search();

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _request?.cancel();
    super.dispose();
  }
}
