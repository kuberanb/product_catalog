

class ApiEndpoints {
  static const baseUrl = 'https://dummyjson.com';

  static const login = '/auth/login';
  static const refreshToken = '/auth/refresh';
  static const products = '/products';
  static const searchProducts = '/products/search';

  static String productDetails(int productId) => '/products/$productId';
}
