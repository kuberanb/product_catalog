import 'package:flutter/material.dart';

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
      await AppServices.api.login(username, password);
      return true;
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
}
