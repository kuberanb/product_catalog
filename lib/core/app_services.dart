import '../features/products/model/product.dart';
import 'api_service.dart';
import 'local_store.dart';

class AppServices {
  AppServices._();

  static ApiService api = ApiService();
  static LocalStore store = LocalStore();
  static List<Product> Function() _productSource = () => const [];
  static List<Product> Function() _favouriteSource = () => const [];

  static void configure({ApiService? apiService, LocalStore? localStore}) {
    if (apiService != null) api = apiService;
    if (localStore != null) store = localStore;
  }

  static void useProducts(List<Product> Function() products) {
    _productSource = products;
  }

  static void useFavourites(List<Product> Function() favourites) {
    _favouriteSource = favourites;
  }

  static List<Product> get cachedProducts => [
    ..._productSource(),
    ..._favouriteSource(),
  ];
}
