import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_service.dart';
import '../../../core/app_services.dart';
import '../../../core/internet_service.dart';
import '../model/product.dart';

class ProductsViewModel extends ChangeNotifier {
  ProductsViewModel();

  final List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);
  bool isLoading = false;
  bool isOffline = false;
  bool hasMore = true;
  String? error;
  int _skip = 0;
  bool _disposed = false;
  bool _checking = false;
  Timer? _timer;
  bool _retryRefresh = false;
  String? _pendingSnapshot;
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initialize() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    _changed();
    try {
      final cached = await AppServices.store.read('products');
      if (cached != null) {
        final snapshot = jsonDecode(cached) as Map<String, dynamic>;
        final items = (snapshot['products'] as List)
            .map((p) => Product.fromJson(Map<String, dynamic>.from(p as Map)))
            .toList();
        _products
          ..clear()
          ..addAll(items);
        _skip = snapshot['skip'] as int;
        hasMore = _skip < (snapshot['total'] as int);
        _changed();
      }
    } catch (_) {
      error = 'cacheError';
    }
    isLoading = false;
    if (_disposed) return;
    _timer ??= Timer.periodic(
      const Duration(seconds: 15),
      (_) => checkConnection(),
    );
    await load(refresh: true);
  }

  Future<void> checkConnection() async {
    if (_checking || _disposed) return;
    _checking = true;
    try {
      final offline = !await const InternetService().hasInternetConnection();
      final reconnect = isOffline && !offline;
      isOffline = offline;
      _changed();
      if (reconnect) await load(refresh: true);
    } catch (_) {
      isOffline = true;
      _changed();
    } finally {
      _checking = false;
    }
  }

  Future<void> load({bool refresh = false}) async {
    if (_disposed || isLoading || (!refresh && !hasMore)) return;
    isLoading = true;
    error = null;
    _retryRefresh = refresh;
    _changed();
    try {
      final skip = refresh ? 0 : _skip;
      final response = await AppServices.api.get<Map<String, dynamic>>(
        ApiEndpoints.products,
        queryParameters: {'limit': 20, 'skip': skip},
      );
      final body = response.data!;
      final page = (body['products'] as List)
          .map((p) => Product.fromJson(Map<String, dynamic>.from(p as Map)))
          .toList();
      final total = (body['total'] as num).toInt();
      if (_disposed) return;
      final byId = {
        if (!refresh)
          for (final product in _products) product.id: product,
        for (final product in page) product.id: product,
      };
      _products
        ..clear()
        ..addAll(byId.values);
      _skip = skip + 20;
      hasMore = page.isNotEmpty && _skip < total;
      isOffline = false;
      _pendingSnapshot = jsonEncode({
        'products': _products.map((p) => p.toJson()).toList(),
        'skip': _skip,
        'total': total,
      });
      try {
        await AppServices.store.write('products', _pendingSnapshot!);
        _pendingSnapshot = null;
      } catch (_) {
        error = 'cacheError';
      }
    } on ApiException catch (e) {
      isOffline = e.message == 'offline';
      error = isOffline ? 'offline' : 'productsError';
    } on DioException catch (e) {
      isOffline = e.response == null;
      error = isOffline ? 'offline' : 'productsError';
    } catch (_) {
      error = 'productsError';
    } finally {
      isLoading = false;
      _changed();
    }
  }

  Future<void> retry() async {
    if (_disposed || isLoading) return;
    if (error != 'cacheError' || _pendingSnapshot == null) {
      return load(refresh: _retryRefresh);
    }
    isLoading = true;
    error = null;
    _changed();
    try {
      await AppServices.store.write('products', _pendingSnapshot!);
      _pendingSnapshot = null;
    } catch (_) {
      error = 'cacheError';
    }
    isLoading = false;
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
