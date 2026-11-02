import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/api_endpoints.dart';
import '../../../core/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
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
    if (username.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Enter your username and password.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'username': username.trim(),
          'password': password,
          'expiresInMins': 30,
        },
      );

      final body = response.data;
      final accessToken = body?['accessToken'] ?? body?['token'];
      if (accessToken is! String || accessToken.isEmpty) {
        _errorMessage = 'Login response did not include an access token.';
        return false;
      }

      final refreshToken = body?['refreshToken'];
      await _apiService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken is String ? refreshToken : null,
      );
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } on DioException catch (error) {
      final data = error.response?.data;
      _errorMessage = data is Map && data['message'] is String
          ? data['message'] as String
          : 'Unable to sign in. Check your connection and credentials.';
      return false;
    } catch (_) {
      _errorMessage = 'Unable to sign in. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }
}
