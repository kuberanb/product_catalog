import 'package:flutter/foundation.dart';
import 'app_services.dart';

class SessionService extends ChangeNotifier {
  bool isLoading = true;
  bool isLoggedIn = false;
  String? error;
  bool _disposed = false;
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  Future<void> restore() async {
    isLoading = true;
    error = null;
    _changed();
    try {
      isLoggedIn = await AppServices.api.restoreSession();
    } catch (_) {
      error = 'sessionError';
    }
    isLoading = false;
    _changed();
  }

  void signedIn() {
    isLoggedIn = true;
    error = null;
    _changed();
  }

  Future<void> logout() async {
    if (isLoading || _disposed) return;
    isLoading = true;
    error = null;
    _changed();
    try {
      await AppServices.api.clearTokens();
      isLoggedIn = false;
    } catch (_) {
      error = 'logoutError';
    }
    isLoading = false;
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
