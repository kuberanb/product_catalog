import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:product_catalog/main.dart';
import 'package:product_catalog/core/locale_service.dart';
import 'package:product_catalog/features/search/view/search_view.dart';
import 'package:product_catalog/features/scanner/view/scanner_view.dart';
import 'package:product_catalog/features/product_detail/view/product_detail_view.dart';
import 'test_support.dart';

void main() {
  testWidgets(
    'Search action opens results and product detail with shared favourites',
    (tester) async {
      await tester.pumpWidget(
        MyApp(
          apiService: TestApi()..loggedIn = true,
          localStore: MemoryStore(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchView), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Product 1');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Product 1',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailView), findsOneWidget);
      expect(find.text('Description for product 1'), findsOneWidget);
      await tester.tap(find.byTooltip('Save to favourites'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove from favourites'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove from favourites'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Scanner action supports manual barcode lookup without camera access',
    (tester) async {
      await tester.pumpWidget(
        MyApp(
          apiService: TestApi()..loggedIn = true,
          localStore: MemoryStore(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Scanner'));
      await tester.pumpAndSettle();
      expect(find.byType(ScannerView), findsOneWidget);
      expect(find.text('Start camera'), findsOneWidget);
      await tester.ensureVisible(find.text('Find product'));
      await tester.tap(find.text('Find product'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a product code or ID.'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '12345678902');
      await tester.ensureVisible(find.text('Find product'));
      await tester.tap(find.text('Find product'));
      await tester.pumpAndSettle();
      expect(find.text('Product details'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Product tap opens detail and pushed routes remain RTL in Arabic',
    (tester) async {
      await tester.pumpWidget(
        MyApp(
          apiService: TestApi()..loggedIn = true,
          localStore: MemoryStore(),
        ),
      );
      await tester.pumpAndSettle();
      await tester
          .element(find.byType(MaterialApp))
          .read<LocaleService>()
          .setLocale(const Locale('ar'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Product 1',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailView), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(ProductDetailView))),
        TextDirection.rtl,
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('البحث'));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.byType(SearchView))),
        TextDirection.rtl,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
}
