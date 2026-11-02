import 'package:flutter/material.dart';
import 'app_services.dart';

class LocaleService extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  bool isLoading = false;
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
      final code = await AppServices.store.read('language');
      if (code == 'en' || code == 'ar') _locale = Locale(code!);
    } catch (_) {
      error = 'settingsError';
    }
    isLoading = false;
    _changed();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode != 'en' && locale.languageCode != 'ar') return;
    _locale = locale;
    await retry();
  }

  Future<void> retry() async {
    error = null;
    _changed();
    try {
      await AppServices.store.write('language', _locale.languageCode);
    } catch (_) {
      error = 'settingsError';
    }
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
