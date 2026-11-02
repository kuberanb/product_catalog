import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:product_catalog/main.dart';

import '../test/test_support.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Native scanner decodes all four supplied QR images', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    final file = File('${Directory.systemTemp.path}/catalogue_test_qrs.png');
    final image = await rootBundle.load(
      'integration_test/fixtures/test_qr_codes.png',
    );
    await file.writeAsBytes(
      image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes),
    );
    final controller = MobileScannerController(autoStart: false);
    try {
      final capture = await controller.analyzeImage(file.path);
      expect(capture, isNotNull);
      expect(
        capture!.barcodes.map((b) => b.rawValue).toSet(),
        containsAll([
          'catalogue://product/3',
          'catalogue://product/15',
          'catalogue://product/9999',
          'https://example.com',
        ]),
      );
    } finally {
      await controller.dispose();
      await file.delete();
    }
  });

  testWidgets('All four supplied codes have the expected Android navigation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(apiService: TestApi()..loggedIn = true, localStore: MemoryStore()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scanner'));
    await tester.pumpAndSettle();
    expect(find.byType(MobileScanner), findsNothing);
    for (final entry in {
      'catalogue://product/3': 'Product 3',
      'catalogue://product/15': 'Product 15',
      'catalogue://product/9999': 'Product not found.',
      'https://example.com': 'This QR code is not a product.',
    }.entries) {
      await tester.tap(find.text('Type code instead'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), entry.key);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
      if (entry.key != 'https://example.com') {
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      }
      expect(find.byType(MobileScanner), findsNothing);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
