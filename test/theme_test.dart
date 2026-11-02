import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:product_catalog/core/app_services.dart';
import 'package:product_catalog/core/theme_service.dart';
import 'package:product_catalog/main.dart';
import 'test_support.dart';

void main() {
  test('Appearance persists and failed saves can retry', () async {
    final store = MemoryStore();
    AppServices.configure(apiService: TestApi(), localStore: store);
    final theme = ThemeService();
    await theme.setMode(ThemeMode.dark);
    final restored = ThemeService();
    await restored.restore();
    expect(restored.mode, ThemeMode.dark);
    store.failWrites = true;
    await theme.setMode(ThemeMode.light);
    expect(theme.mode, ThemeMode.light);
    expect(theme.error, 'themeError');
    store.failWrites = false;
    await theme.retry();
    expect(store.values['theme'], 'light');
    expect(theme.error, isNull);
    theme.dispose();
    restored.dispose();
  });

  testWidgets('Settings switches the complete app between dark and light', (
    tester,
  ) async {
    final store = MemoryStore();
    await tester.pumpWidget(
      MyApp(apiService: TestApi()..loggedIn = true, localStore: store),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('System default').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Appearance'))).brightness,
      Brightness.dark,
    );
    expect(store.values['theme'], 'dark');
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light').last);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Appearance'))).brightness,
      Brightness.light,
    );
    final service = tester
        .element(find.byType(MaterialApp))
        .read<ThemeService>();
    await service.setMode(ThemeMode.system);
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
