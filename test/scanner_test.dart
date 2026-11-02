import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:product_catalog/core/app_services.dart';
import 'package:product_catalog/features/scanner/view/scanner_view.dart';
import 'package:product_catalog/features/scanner/view/widgets/scanner_camera_view.dart';
import 'package:product_catalog/features/scanner/view_model/scanner_view_model.dart';
import 'package:product_catalog/features/product_detail/view/product_detail_view.dart';
import 'package:product_catalog/features/products/model/product.dart';
import 'package:product_catalog/l10n/app_localizations.dart';
import 'package:product_catalog/main.dart';
import 'test_support.dart';

void main() {
  setUp(() {
    AppServices.useProducts(() => []);
    AppServices.useFavourites(() => []);
  });

  for (final id in [3, 15, 9999]) {
    test('Parses supplied QR catalogue://product/$id', () {
      final model = ScannerViewModel();
      addTearDown(model.dispose);
      model.codeController.text = 'catalogue://product/$id';
      expect(model.submit('empty', 'invalid')!.productId, id);
      expect(model.error, isNull);
    });
  }

  test('Rejects wrong codes and malformed product links', () {
    final model = ScannerViewModel();
    addTearDown(model.dispose);
    for (final value in [
      'https://example.com',
      'https://example.com/products/3',
      'catalogue://product/0',
      'catalogue://product/-3',
      'catalogue://product/3/extra',
      'catalogue://product/abc',
      'catalogue://product/3?next=4',
      'catalogue://product/3#other',
      'catalogue://other/3',
      'random text',
    ]) {
      model.codeController.text = value;
      expect(model.submit('empty', 'invalid'), isNull, reason: value);
      expect(model.error, 'invalid');
    }
    model.codeController.clear();
    expect(model.submit('empty', 'invalid'), isNull);
    expect(model.error, 'empty');
  });

  test(
    'Catalogue QR resolves an already cached product for offline detail',
    () {
      const cached = Product(
        id: 3,
        title: 'Cached product',
        price: 10,
        rating: 4,
        image: '',
      );
      AppServices.useProducts(() => [cached]);
      final model = ScannerViewModel();
      addTearDown(model.dispose);
      model.codeController.text = ' catalogue://product/3 ';
      expect(model.submit('empty', 'invalid')!.product, same(cached));
    },
  );

  test('Camera capture accepts only the first code until restarted', () {
    final model = ScannerViewModel();
    addTearDown(model.dispose);
    final capture = BarcodeCapture(
      barcodes: [
        const Barcode(rawValue: 'catalogue://product/3'),
        const Barcode(rawValue: 'catalogue://product/15'),
      ],
    );
    model.onDetected(capture);
    expect(model.codeController.text, isEmpty);
    model.startCamera();
    model.onDetected(capture);
    expect(model.codeController.text, 'catalogue://product/3');
    expect(model.isCameraOn, isFalse);
    model.reset();
    expect(model.codeController.text, isEmpty);
    expect(model.isCameraOn, isFalse);
  });

  for (final entry in {
    'catalogue://product/3': 'Product 3',
    'catalogue://product/15': 'Product 15',
    'catalogue://product/9999': 'Product not found.',
    'https://example.com': 'This QR code is not a product.',
  }.entries) {
    testWidgets('Supplied QR manual entry ${entry.key}', (tester) async {
      await tester.pumpWidget(
        MyApp(
          apiService: TestApi()..loggedIn = true,
          localStore: MemoryStore(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Scanner'));
      await tester.pumpAndSettle();
      expect(find.byType(MobileScanner), findsNothing);
      await tester.tap(find.text('Type code instead'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), entry.key);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
      if (entry.key == 'https://example.com') {
        expect(find.byType(ScannerView), findsOneWidget);
        expect(find.byType(ProductDetailView), findsNothing);
      } else {
        expect(find.byType(ProductDetailView), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Camera capture opens details without Find product tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(apiService: TestApi()..loggedIn = true, localStore: MemoryStore()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scanner'));
    await tester.pumpAndSettle();
    expect(find.byType(MobileScanner), findsNothing);
    await tester.tap(find.text('Start camera'));
    await tester.pump();
    final camera = tester.widget<ScannerCameraView>(
      find.byType(ScannerCameraView),
    );
    camera.onDetect(
      BarcodeCapture(
        barcodes: [const Barcode(rawValue: 'catalogue://product/15')],
      ),
    );
    // Repeated detections must not push another route.
    camera.onDetect(
      BarcodeCapture(
        barcodes: [const Barcode(rawValue: 'catalogue://product/3')],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Product 15'), findsOneWidget);
    expect(find.byType(MobileScanner), findsNothing);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(ScannerView), findsOneWidget);
    expect(find.byType(MobileScanner), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Denied permission explains and opens native settings', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    const channel = MethodChannel('product_catalog/settings');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call);
      return null;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      MyApp(apiService: TestApi()..loggedIn = true, localStore: MemoryStore()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scanner'));
    await tester.pumpAndSettle();
    expect(find.byType(MobileScanner), findsNothing);
    await tester.tap(find.text('Start camera'));
    await tester.pump();
    final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));
    final context = tester.element(find.byType(MobileScanner));
    final errorWidget = scanner.errorBuilder!(
      context,
      const MobileScannerException(
        errorCode: MobileScannerErrorCode.permissionDenied,
      ),
    );
    // Render the plugin's actual permission error UI without a physical camera.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(width: 320, height: 280, child: errorWidget),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Camera permission was denied.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
    // The callback belongs to the scanner and invokes the platform channel.
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(calls.single.method, 'openSettings');
    await tester.pumpWidget(const SizedBox());
  });
}
