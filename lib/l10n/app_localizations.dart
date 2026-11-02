import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @continueToCatalog.
  ///
  /// In en, this message translates to:
  /// **'Continue to catalog'**
  String get continueToCatalog;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @noFavourites.
  ///
  /// In en, this message translates to:
  /// **'No favourite products yet'**
  String get noFavourites;

  /// No description provided for @favouritesHint.
  ///
  /// In en, this message translates to:
  /// **'Products you save as favourites will appear here.'**
  String get favouritesHint;

  /// No description provided for @removeFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get removeFavourite;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addFavourite.
  ///
  /// In en, this message translates to:
  /// **'Save to favourites'**
  String get addFavourite;

  /// No description provided for @allProductsLoaded.
  ///
  /// In en, this message translates to:
  /// **'All products loaded'**
  String get allProductsLoaded;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Check your connection and try again.'**
  String get loginFailed;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'USD {amount}'**
  String price(String amount);

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating {value} out of 5'**
  String rating(String value);

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offline;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get enterPassword;

  /// No description provided for @secureStorageError.
  ///
  /// In en, this message translates to:
  /// **'Unable to securely save your session. Please retry.'**
  String get secureStorageError;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available. Pull down to refresh.'**
  String get noProducts;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @cacheError.
  ///
  /// In en, this message translates to:
  /// **'Products are shown, but could not be saved for offline use. Please retry.'**
  String get cacheError;

  /// No description provided for @sessionError.
  ///
  /// In en, this message translates to:
  /// **'Unable to restore your session. Please retry.'**
  String get sessionError;

  /// No description provided for @credentialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your username and password.'**
  String get credentialsRequired;

  /// No description provided for @favouriteSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save your favourite. Please retry.'**
  String get favouriteSaveError;

  /// No description provided for @retryImage.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable. Tap to retry.'**
  String get retryImage;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username.'**
  String get enterUsername;

  /// No description provided for @settingsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save your language preference. Please retry.'**
  String get settingsError;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password.'**
  String get invalidCredentials;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Unable to clear your session. Please retry logout.'**
  String get logoutError;

  /// No description provided for @productsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load products. Please retry.'**
  String get productsError;

  /// No description provided for @favouritesError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load favourites. Please retry.'**
  String get favouritesError;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'DummyJSON demo: emilys / emilyspass'**
  String get demoCredentials;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchHint;

  /// No description provided for @productCode.
  ///
  /// In en, this message translates to:
  /// **'Product code or ID'**
  String get productCode;

  /// No description provided for @findProduct.
  ///
  /// In en, this message translates to:
  /// **'Find product'**
  String get findProduct;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inStock;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No matching products. Try another search.'**
  String get noSearchResults;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a product code or ID.'**
  String get enterCode;

  /// No description provided for @scanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get scanner;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Unable to search products. Please retry.'**
  String get searchError;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'catalogue://product/3'**
  String get codeHint;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @detailsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load product details. Please retry.'**
  String get detailsError;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search by product name or keyword.'**
  String get searchPrompt;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @startCamera.
  ///
  /// In en, this message translates to:
  /// **'Start camera'**
  String get startCamera;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @scannerHint.
  ///
  /// In en, this message translates to:
  /// **'Scan a product QR code to open its details. You can also type a code such as catalogue://product/3.'**
  String get scannerHint;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable. Allow camera access in device settings, then retry, or enter a code below.'**
  String get cameraError;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescription;

  /// No description provided for @invalidProductCode.
  ///
  /// In en, this message translates to:
  /// **'This QR code is not a product.'**
  String get invalidProductCode;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFound;

  /// No description provided for @typeCodeInstead.
  ///
  /// In en, this message translates to:
  /// **'Type code instead'**
  String get typeCodeInstead;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission was denied. Enable camera access in app settings, then tap Retry, or type a code instead.'**
  String get cameraPermissionDenied;

  /// No description provided for @settingsOpenError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open settings. Open the app permissions in your device settings, or type a code instead.'**
  String get settingsOpenError;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
