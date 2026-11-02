import 'dart:async';
import 'package:dio/dio.dart';
import 'package:product_catalog/core/app_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/features/search/view_model/search_view_model.dart';
import 'package:product_catalog/features/product_detail/view_model/product_detail_view_model.dart';
import 'package:product_catalog/features/products/model/product.dart';
import 'test_support.dart';

class DelayedDetailApi extends TestApi {
  final pending = <String, Completer<Response<Map<String, dynamic>>>>{};

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final completer = Completer<Response<Map<String, dynamic>>>();
    pending[path] = completer;
    return await completer.future as Response<T>;
  }

  void complete(int id) {
    final path = '/products/$id';
    pending[path]!.complete(
      Response(
        requestOptions: RequestOptions(path: path),
        data: {'id': id, 'title': 'Product $id', 'price': 10, 'rating': 4},
      ),
    );
  }
}

void main() {
  setUp(() {
    AppServices.useProducts(() => []);
    AppServices.useFavourites(() => []);
  });
  test(
    'Search uses query and 20-item pages, then resets for a new query',
    () async {
      final api = TestApi();
      AppServices.configure(apiService: api);
      AppServices.useProducts(() => []);
      final model = SearchViewModel();
      addTearDown(model.dispose);
      await model.search(' Product ');
      await model.loadMore();
      expect(api.requests.first, {'q': 'Product', 'limit': 20, 'skip': 0});
      expect(api.requests.last['skip'], 20);
      expect(model.products.length, 40);
      await model.search('Product 43');
      expect(api.requests.last['skip'], 0);
      expect(model.products.single.title, 'Product 43');
      expect(model.hasMore, isFalse);
      await model.search('no match');
      expect(model.products, isEmpty);
      expect(model.error, isNull);
    },
  );

  test('Offline search shows cached matches and Retry recovers', () async {
    final api = TestApi()..failure = 'offline';
    const product = Product(
      id: 1,
      title: 'Lipstick',
      price: 10,
      rating: 4,
      image: '',
    );
    AppServices.configure(apiService: api);
    AppServices.useProducts(() => [product]);
    final model = SearchViewModel();
    addTearDown(model.dispose);
    await model.search('lip');
    expect(model.products.single, product);
    expect(model.isOffline, isTrue);
    expect(model.error, 'offline');
    api.failure = null;
    await model.search('Product 1');
    expect(model.isOffline, isFalse);
    expect(model.error, isNull);
    expect(model.products, isNotEmpty);
  });

  test(
    'Detail fetches full product, caches it and restores it offline',
    () async {
      final api = TestApi();
      final store = MemoryStore();
      AppServices.configure(apiService: api, localStore: store);
      final model = ProductDetailViewModel()..selectProduct(id: 2);
      await model.load();
      expect(model.product!.description, 'Description for product 2');
      expect(model.product!.barcode, '12345678902');
      model.dispose();
      api.failure = 'offline';
      AppServices.configure(apiService: api, localStore: store);
      final offline = ProductDetailViewModel()..selectProduct(id: 2);
      addTearDown(offline.dispose);
      await offline.load();
      expect(offline.product!.title, 'Product 2');
      expect(offline.error, 'offline');
      expect(offline.isLoading, isFalse);
      api.failure = null;
      await offline.load();
      expect(offline.error, isNull);
    },
  );

  test('Detail without cached data shows a retryable error', () async {
    final api = TestApi()..failure = 'offline';
    AppServices.configure(apiService: api, localStore: MemoryStore());
    final model = ProductDetailViewModel()..selectProduct(id: 1);
    addTearDown(model.dispose);
    await model.load();
    expect(model.product, isNull);
    expect(model.error, 'offline');
    api.failure = null;
    await model.load();
    expect(model.product!.id, 1);
  });

  test(
    'An earlier detail request cannot overwrite a newly scanned product',
    () async {
      final api = DelayedDetailApi();
      AppServices.configure(apiService: api, localStore: MemoryStore());
      final model = ProductDetailViewModel()..selectProduct(id: 3);
      addTearDown(model.dispose);
      final first = model.load();
      await Future<void>.delayed(Duration.zero);
      model.selectProduct(id: 15);
      final second = model.load();
      await Future<void>.delayed(Duration.zero);
      api.complete(15);
      await second;
      api.complete(3);
      await first;
      expect(model.productId, 15);
      expect(model.product!.id, 15);
      expect(model.isLoading, isFalse);
      expect(model.error, isNull);
    },
  );
}
