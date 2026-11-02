import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product_catalog/core/api_service.dart';
import 'package:product_catalog/core/app_services.dart';
import 'package:product_catalog/core/session_service.dart';
import 'package:product_catalog/features/login/view_model/login_view_model.dart';
import 'test_support.dart';

class JsonAdapter implements HttpClientAdapter {
  int status = 200;
  Map<String, dynamic> body = {};
  RequestOptions? lastRequest;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

String tokenWithExpiry(int expiry) =>
    'header.${base64Url.encode(utf8.encode(jsonEncode({'exp': expiry})))}.signature';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late JsonAdapter backend;
  late ApiService api;
  late TestInternet internet;
  const storage = FlutterSecureStorage();
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    internet = TestInternet();
    backend = JsonAdapter();
    api = ApiService(
      dio: Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
        ..httpClientAdapter = backend,
      internetService: internet,
      storage: storage,
    );
    AppServices.configure(apiService: api);
  });

  test(
    'Login stores tokens in secure storage and sends trimmed username',
    () async {
      backend.body = {
        'accessToken': tokenWithExpiry(4102444800),
        'refreshToken': 'refresh',
      };
      final login = LoginViewModel();
      addTearDown(login.dispose);
      expect(
        await login.login(username: ' emilys ', password: 'password'),
        isTrue,
      );
      expect(backend.lastRequest!.data['username'], 'emilys');
      expect(
        backend.lastRequest!.headers.containsKey('Authorization'),
        isFalse,
      );
      expect(
        await storage.read(key: 'access_token'),
        backend.body['accessToken'],
      );
      expect(await storage.read(key: 'refresh_token'), 'refresh');
      expect(await api.restoreSession(), isTrue);
      final session = SessionService();
      addTearDown(session.dispose);
      await session.restore();
      expect(session.isLoggedIn, isTrue);
      await session.logout();
      expect(await storage.read(key: 'access_token'), isNull);
      expect(await storage.read(key: 'refresh_token'), isNull);
      expect(session.isLoggedIn, isFalse);
    },
  );

  test('Wrong details produce an error without storing tokens', () async {
    backend.status = 400;
    backend.body = {'message': 'Invalid credentials'};
    final login = LoginViewModel();
    addTearDown(login.dispose);
    expect(await login.login(username: 'wrong', password: 'wrong'), isFalse);
    expect(login.errorMessage, 'invalidCredentials');
    expect(login.isLoading, isFalse);
    expect(await storage.read(key: 'access_token'), isNull);
  });

  test('Product requests attach the secure token as a Bearer header', () async {
    await api.saveTokens(accessToken: 'saved-token');
    await api.get<Map<String, dynamic>>('/products');
    expect(backend.lastRequest!.headers['Authorization'], 'Bearer saved-token');
  });

  test('Missing token rejects a malformed successful response', () async {
    final login = LoginViewModel();
    addTearDown(login.dispose);
    expect(await login.login(username: 'user', password: 'pass'), isFalse);
    expect(login.errorMessage, 'invalidLoginResponse');
    expect(await storage.read(key: 'access_token'), isNull);
  });

  test(
    'Restore only checks secure storage, without a network request',
    () async {
      expect(await api.restoreSession(), isFalse);
      await api.saveTokens(accessToken: 'saved-token');
      expect(await api.restoreSession(), isTrue);
      expect(backend.lastRequest, isNull);
      await api.clearTokens();
      expect(await api.restoreSession(), isFalse);
    },
  );

  test(
    'Saved session restores offline without decoding token claims',
    () async {
      await api.saveTokens(accessToken: 'saved-token');
      internet.online = false;
      expect(await api.restoreSession(), isTrue);
      expect(backend.lastRequest, isNull);
    },
  );
}
