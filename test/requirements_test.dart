import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/core/app_services.dart';
import 'package:product_catalog/features/products/model/product.dart';
import 'package:product_catalog/features/products/view_model/products_view_model.dart';
import 'package:product_catalog/features/favourites/view_model/favourites_view_model.dart';
import 'package:product_catalog/features/search/view_model/search_view_model.dart';
import 'test_support.dart';

void main() {
  test(
    'Product pages use 20 item boundaries and refresh resets the offset',
    () async {
      final api = TestApi();
      AppServices.configure(apiService: api, localStore: MemoryStore());
      final model = ProductsViewModel();
      addTearDown(model.dispose);
      await model.load();
      await model.load();
      await model.load();
      expect(api.requests.map((r) => r['skip']), [0, 20, 40]);
      expect(api.requests.every((r) => r['limit'] == 20), isTrue);
      expect(model.products.length, 43);
      expect(model.hasMore, isFalse);
      await model.load(refresh: true);
      expect(api.requests.last['skip'], 0);
      expect(model.products.length, 20);
    },
  );

  test(
    'Last loaded products survive restart offline and Retry recovers',
    () async {
      final api = TestApi();
      final store = MemoryStore();
      AppServices.configure(apiService: api, localStore: store);
      final first = ProductsViewModel();
      await first.load();
      await first.load();
      first.dispose();
      api.failure = 'offline';
      final restored = ProductsViewModel();
      addTearDown(restored.dispose);
      await restored.initialize();
      expect(restored.products.length, 40);
      expect(restored.isOffline, isTrue);
      expect(restored.error, 'offline');
      api.failure = null;
      await restored.retry();
      expect(restored.error, isNull);
      expect(restored.isOffline, isFalse);
    },
  );

  test(
    'Favourites survive model recreation and failed writes can retry',
    () async {
      final store = MemoryStore();
      AppServices.configure(localStore: store);
      const product = Product(
        id: 3,
        title: 'Product 3',
        price: 10,
        rating: 4,
        image: '',
      );
      final first = FavouritesViewModel();
      await first.initialize();
      await first.toggle(product);
      first.dispose();
      final restored = FavouritesViewModel();
      addTearDown(restored.dispose);
      await restored.initialize();
      expect(restored.contains(3), isTrue);
      store.failWrites = true;
      await restored.toggle(product);
      expect(restored.error, 'favouriteSaveError');
      expect(restored.contains(3), isTrue);
      store.failWrites = false;
      await restored.retry();
      expect(restored.contains(3), isFalse);
      expect(restored.error, isNull);
    },
  );

  testWidgets('Search waits until typing has stopped for 350ms', (
    tester,
  ) async {
    final api = TestApi();
    AppServices.configure(apiService: api);
    final model = SearchViewModel();
    addTearDown(model.dispose);
    model.setQuery('P');
    await tester.pump(const Duration(milliseconds: 200));
    model.setQuery('Product');
    await tester.pump(const Duration(milliseconds: 349));
    expect(api.requests, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(api.requests.single['q'], 'Product');
    await tester.pump();
  });

  test('Missing brand is safe and full product images survive caching', () {
    final product = Product.fromJson({
      'id': 3,
      'title': 'Product 3',
      'price': 10,
      'rating': 4,
      'brand': null,
      'images': ['first.png', 'second.png'],
    });
    expect(product.brand, isEmpty);
    final cached = Product.fromJson(
      jsonDecode(jsonEncode(product.toJson())) as Map<String, dynamic>,
    );
    expect(cached.images, ['first.png', 'second.png']);
    expect(cached.brand, isEmpty);
  });
}
