import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/api_endpoints.dart';
import '../../../core/api_service.dart';
import '../../../core/app_services.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: 'emilys');
  final passwordController = TextEditingController(text: 'emilyspass');

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _disposed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (_isLoading || _disposed) return false;
    if (username.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'credentialsRequired';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AppServices.api.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'username': username.trim(),
          'password': password,
          'expiresInMins': 30,
        },
      );
      await _saveResponseTokens(response.data);
      return true;
    } on DioException catch (error) {
      _errorMessage =
          error.response?.statusCode == 400 || error.response?.statusCode == 401
          ? 'invalidCredentials'
          : 'loginFailed';
      return false;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'loginFailed';
      return false;
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _saveResponseTokens(Map<String, dynamic>? body) async {
    final token = body?['accessToken'] ?? body?['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException('invalidLoginResponse');
    }
    final refresh = body?['refreshToken'];
    try {
      await AppServices.api.saveTokens(
        accessToken: token,
        refreshToken: refresh is String ? refresh : null,
      );
    } catch (_) {
      throw const ApiException('secureStorageError');
    }
  }
}
