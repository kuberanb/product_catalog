import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:product_catalog/core/locale_service.dart';
import 'package:product_catalog/main.dart';
import 'test_support.dart';

void main() {
  testWidgets('Scrolling fetches the next page and hearts update Favourites', (
    tester,
  ) async {
    final api = TestApi()..loggedIn = true;
    await tester.pumpWidget(MyApp(apiService: api, localStore: MemoryStore()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save to favourites').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favourites'));
    await tester.pumpAndSettle();
    expect(find.text('Product 1'), findsOneWidget);
    await tester.tap(find.text('Products').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(api.requests.any((request) => request['skip'] == 20), isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Offline first load displays banner and Retry without crashing', (
    tester,
  ) async {
    final api = TestApi()
      ..loggedIn = true
      ..failure = 'offline';
    await tester.pumpWidget(MyApp(apiService: api, localStore: MemoryStore()));
    await tester.pumpAndSettle();
    expect(find.text('You are offline'), findsWidgets);
    expect(find.text('Retry'), findsWidgets);
    expect(tester.takeException(), isNull);
    api.failure = null;
    await tester.tap(find.text('Retry').first);
    await tester.pumpAndSettle();
    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('You are offline'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Password visibility changes preserve login inputs', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(apiService: TestApi(), localStore: MemoryStore()),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'test-user');
    await tester.enterText(find.byType(TextFormField).last, 'test-password');
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isTrue,
    );
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isFalse,
    );
    expect(find.text('test-user'), findsOneWidget);
    expect(find.text('test-password'), findsOneWidget);
  });

  testWidgets('Arabic flips the entire app and preserves login form state', (
    tester,
  ) async {
    final store = MemoryStore();
    await tester.pumpWidget(MyApp(apiService: TestApi(), localStore: store));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'test-user');
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    await tester
        .element(find.byType(MaterialApp))
        .read<LocaleService>()
        .setLocale(const Locale('ar'));
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.byType(TextFormField).first)),
      TextDirection.rtl,
    );
    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(find.text('test-user'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isFalse,
    );
    expect(store.values['language'], 'ar');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Wrong credentials show localized error and Retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        apiService: TestApi()..failure = 'invalidCredentials',
        localStore: MemoryStore(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to catalog'));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect username or password.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets(
    'Saved session opens products; Settings changes RTL and logs out',
    (tester) async {
      final api = TestApi()..loggedIn = true;
      await tester.pumpWidget(
        MyApp(apiService: api, localStore: MemoryStore()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Product 1'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arabic').last);
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.byType(NavigationBar))),
        TextDirection.rtl,
      );
      await tester.tap(find.text('تسجيل الخروج'));
      await tester.pumpAndSettle();
      expect(api.loggedIn, isFalse);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
