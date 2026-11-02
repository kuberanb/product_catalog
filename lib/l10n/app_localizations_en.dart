// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get continueToCatalog => 'Continue to catalog';

  @override
  String get products => 'Products';

  @override
  String get favourites => 'Favourites';

  @override
  String get noFavourites => 'No favourite products yet';

  @override
  String get favouritesHint =>
      'Products you save as favourites will appear here.';

  @override
  String get removeFavourite => 'Remove from favourites';

  @override
  String get settings => 'Settings';

  @override
  String get addFavourite => 'Save to favourites';

  @override
  String get allProductsLoaded => 'All products loaded';

  @override
  String get loginFailed =>
      'Unable to sign in. Check your connection and try again.';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get retry => 'Retry';

  @override
  String price(String amount) {
    return 'USD $amount';
  }

  @override
  String rating(String value) {
    return 'Rating $value out of 5';
  }

  @override
  String get offline => 'You are offline';

  @override
  String get enterPassword => 'Enter your password.';

  @override
  String get secureStorageError =>
      'Unable to securely save your session. Please retry.';

  @override
  String get noProducts => 'No products available. Pull down to refresh.';

  @override
  String get logout => 'Logout';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get cacheError =>
      'Products are shown, but could not be saved for offline use. Please retry.';

  @override
  String get sessionError => 'Unable to restore your session. Please retry.';

  @override
  String get credentialsRequired => 'Enter your username and password.';

  @override
  String get favouriteSaveError =>
      'Unable to save your favourite. Please retry.';

  @override
  String get retryImage => 'Image unavailable. Tap to retry.';

  @override
  String get loadMore => 'Load more';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter your username.';

  @override
  String get settingsError =>
      'Unable to save your language preference. Please retry.';

  @override
  String get invalidCredentials => 'Incorrect username or password.';

  @override
  String get logoutError =>
      'Unable to clear your session. Please retry logout.';

  @override
  String get productsError => 'Unable to load products. Please retry.';

  @override
  String get favouritesError => 'Unable to load favourites. Please retry.';

  @override
  String get demoCredentials => 'DummyJSON demo: emilys / emilyspass';

  @override
  String get searchHint => 'Search products';

  @override
  String get productCode => 'Product code or ID';

  @override
  String get findProduct => 'Find product';

  @override
  String get brand => 'Brand';

  @override
  String get search => 'Search';

  @override
  String get inStock => 'In stock';

  @override
  String get noSearchResults => 'No matching products. Try another search.';

  @override
  String get enterCode => 'Enter a product code or ID.';

  @override
  String get scanner => 'Scanner';

  @override
  String get searchError => 'Unable to search products. Please retry.';

  @override
  String get codeHint => 'catalogue://product/3';

  @override
  String get description => 'Description';

  @override
  String get detailsError => 'Unable to load product details. Please retry.';

  @override
  String get searchPrompt => 'Search by product name or keyword.';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get startCamera => 'Start camera';

  @override
  String get productDetails => 'Product details';

  @override
  String get availability => 'Availability';

  @override
  String get scannerHint =>
      'Scan a product QR code to open its details. You can also type a code such as catalogue://product/3.';

  @override
  String get category => 'Category';

  @override
  String get cameraError =>
      'Camera unavailable. Allow camera access in device settings, then retry, or enter a code below.';

  @override
  String get noDescription => 'No description available.';

  @override
  String get invalidProductCode => 'This QR code is not a product.';

  @override
  String get productNotFound => 'Product not found.';

  @override
  String get typeCodeInstead => 'Type code instead';

  @override
  String get openSettings => 'Open settings';

  @override
  String get cameraPermissionDenied =>
      'Camera permission was denied. Enable camera access in app settings, then tap Retry, or type a code instead.';

  @override
  String get settingsOpenError =>
      'Unable to open settings. Open the app permissions in your device settings, or type a code instead.';

  @override
  String get language => 'Language';
}
