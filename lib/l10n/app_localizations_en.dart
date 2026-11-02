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
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';
}
