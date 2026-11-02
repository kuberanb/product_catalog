import 'package:flutter/material.dart';

/// App-wide locale state shared by MaterialApp and the Settings feature.
class LocaleService extends ChangeNotifier {
  LocaleService({Locale initialLocale = const Locale('en')})
    : _locale = initialLocale;

  Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
