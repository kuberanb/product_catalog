import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/api_service.dart';
import 'core/app_colors.dart';
import 'core/theme_service.dart';
import 'core/app_services.dart';
import 'core/error_view.dart';
import 'core/local_store.dart';
import 'core/locale_service.dart';
import 'core/session_service.dart';
import 'features/bottom_nav/view/bottom_nav_view.dart';
import 'features/bottom_nav/view_model/bottom_nav_view_model.dart';
import 'features/favourites/view_model/favourites_view_model.dart';
import 'features/login/login_view/login_view.dart';
import 'features/login/view_model/login_view_model.dart';
import 'features/product_detail/view_model/product_detail_view_model.dart';
import 'features/products/view_model/products_view_model.dart';
import 'features/search/view_model/search_view_model.dart';
import 'features/scanner/view_model/scanner_view_model.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.apiService, this.localStore});
  final ApiService? apiService;
  final LocalStore? localStore;

  @override
  Widget build(BuildContext context) {
    AppServices.configure(apiService: apiService, localStore: localStore);
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: AppServices.api),
        Provider<LocalStore>.value(value: AppServices.store),
        ChangeNotifierProvider(create: (_) => LocaleService()..restore()),
        ChangeNotifierProvider(create: (_) => ThemeService()..restore()),
        ChangeNotifierProvider(create: (_) => SessionService()..restore()),
        ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            final model = ProductsViewModel()..initialize();
            AppServices.useProducts(() => model.products);
            return model;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final model = FavouritesViewModel()..initialize();
            AppServices.useFavourites(() => model.products);
            return model;
          },
        ),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => ScannerViewModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailViewModel()),
      ],
      child: const _LocalizedApp(),
    );
  }
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp();

  @override
  Widget build(BuildContext context) => Consumer2<LocaleService, ThemeService>(
    builder: (context, locale, appearance, _) => MaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      locale: locale.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppColors.theme(Brightness.light),
      darkTheme: AppColors.theme(Brightness.dark),
      themeMode: appearance.mode,
      home: Consumer<SessionService>(
        builder: (context, session, _) {
          if (session.isLoading && !session.isLoggedIn) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (session.isLoggedIn) return const BottomNavView();
          if (session.error != null) {
            return Scaffold(
              body: Center(
                child: ErrorView(
                  error: session.error!,
                  onRetry: session.restore,
                ),
              ),
            );
          }
          return LoginView(onLogin: (_) => session.signedIn());
        },
      ),
    ),
  );
}
