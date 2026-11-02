import 'package:flutter/material.dart';
import 'app_services.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  String? error;
  bool _disposed = false;
  int _revision = 0;

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  Future<void> restore() async {
    final revision = _revision;
    try {
      final saved = await AppServices.store.read('theme');
      if (_disposed || revision != _revision) return;
      mode = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    } catch (_) {
      if (revision == _revision) error = 'themeError';
    }
    _changed();
  }

  Future<void> setMode(ThemeMode value) async {
    _revision++;
    mode = value;
    await retry();
  }

  Future<void> retry() async {
    final revision = _revision;
    error = null;
    _changed();
    try {
      await AppServices.store.write('theme', mode.name);
    } catch (_) {
      if (revision == _revision) error = 'themeError';
    }
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
