import 'package:flutter/material.dart';

import '../../../core/locale_service.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required LocaleService localeService})
    : _localeService = localeService;

  final LocaleService _localeService;

  Locale get locale => _localeService.locale;

  void setLanguage(String languageCode) {
    if (locale.languageCode == languageCode) return;
    _localeService.setLocale(Locale(languageCode));
    notifyListeners();
  }
}
