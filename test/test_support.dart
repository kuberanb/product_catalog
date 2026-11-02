import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:product_catalog/core/api_service.dart';
import 'package:product_catalog/core/internet_service.dart';
import 'package:product_catalog/core/local_store.dart';
import 'package:product_catalog/features/products/model/product.dart';

class MemoryStore extends LocalStore {
  final values = <String, String>{};
  final saved = <int, Product>{};
  bool failWrites = false;
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    if (failWrites) throw Exception('disk unavailable');
    values[key] = value;
  }

  @override
  Future<List<Product>> readFavourites() async => saved.values.toList();
  @override
  Future<void> setFavourite(Product product, bool save) async {
    if (failWrites) throw Exception('disk unavailable');
    if (save) {
      saved[product.id] = product;
    } else {
      saved.remove(product.id);
    }
  }

  @override
  Future<Uint8List?> readImage(String url) async => null;
}

class TestInternet extends InternetService {
  bool online = true;
  @override
  Future<bool> hasInternetConnection() async => online;
}

class TestApi extends ApiService {
  bool loggedIn = false;
  String? failure;
  final requests = <Map<String, dynamic>>[];
  @override
  Future<bool> restoreSession() async => loggedIn;
  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (failure != null) throw ApiException(failure!);
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: {'accessToken': 'test-token'} as T,
    );
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    loggedIn = true;
  }

  @override
  Future<void> clearTokens() async {
    loggedIn = false;
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    requests.add(Map.of(queryParameters ?? {'path': path}));
    if (failure != null) throw ApiException(failure!);
    final all = List.generate(
      43,
      (index) => {
        'id': index + 1,
        'title': 'Product ${index + 1}',
        'price': 12.5,
        'rating': 4.5,
        'thumbnail': '',
        'description': 'Description for product ${index + 1}',
        'brand': 'Catalog',
        'category': 'beauty',
        'stock': 5,
        'sku': 'SKU-${index + 1}',
        'meta': {'barcode': '1234567890${index + 1}'},
      },
    );
    if (queryParameters == null) {
      final id = int.parse(path.split('/').last);
      if (id < 1 || id > all.length) {
        final request = RequestOptions(path: path);
        throw DioException(
          requestOptions: request,
          response: Response<dynamic>(requestOptions: request, statusCode: 404),
          type: DioExceptionType.badResponse,
        );
      }
      return Response<T>(
        requestOptions: RequestOptions(path: path),
        data: all[id - 1] as T,
      );
    }
    final skip = queryParameters['skip'] as int;
    final query = (queryParameters['q'] as String? ?? '').toLowerCase();
    final matches = all
        .where((p) => (p['title'] as String).toLowerCase().contains(query))
        .toList();
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data:
          {
                'products': matches.skip(skip).take(20).toList(),
                'total': matches.length,
              }
              as T,
    );
  }
}
