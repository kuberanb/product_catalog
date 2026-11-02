import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

String errorText(BuildContext context, String code) {
  final t = AppLocalizations.of(context)!;
  return switch (code) {
    'invalidCredentials' => t.invalidCredentials,
    'credentialsRequired' => t.credentialsRequired,
    'offline' => t.offline,
    'secureStorageError' => t.secureStorageError,
    'invalidLoginResponse' => t.loginFailed,
    'loginFailed' => t.loginFailed,
    'sessionError' => t.sessionError,
    'logoutError' => t.logoutError,
    'cacheError' => t.cacheError,
    'productsError' => t.productsError,
    'detailsError' => t.detailsError,
    'productNotFound' => t.productNotFound,
    'searchError' => t.searchError,
    'favouritesError' => t.favouritesError,
    'favouriteSaveError' => t.favouriteSaveError,
    'settingsError' => t.settingsError,
    _ => t.productsError,
  };
}
