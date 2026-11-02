import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/locale_service.dart';
import 'features/bottom_nav/view/bottom_nav_view.dart';
import 'features/login/login_view/login_view.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleService(),
      child: Consumer<LocaleService>(
        builder: (context, model, _) => MaterialApp(
          title: 'Product Catalog',
          debugShowCheckedModeBanner: false,
          locale: model.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          ),
          home: LoginView(
            onLogin: (context) => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => BottomNavView(localeService: model),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
