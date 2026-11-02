import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/app_services.dart';
import '../../products/model/product.dart';

class ScanResult {
  const ScanResult({
    required this.productId,
    required this.product,
    required this.query,
  });
  final int? productId;
  final Product? product;
  final String query;
}

class ScannerViewModel extends ChangeNotifier {
  final codeController = TextEditingController();
  bool isCameraOn = false;
  int cameraAttempt = 0;
  String? error;

  void _changed() => notifyListeners();

  void startCamera() {
    error = null;
    isCameraOn = true;
    _changed();
  }

  void retryCamera() {
    cameraAttempt++;
    _changed();
  }

  void cameraUnavailable(String message) {
    isCameraOn = false;
    error = message;
    _changed();
  }

  void onDetected(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (isCameraOn && value != null && value.isNotEmpty) {
        codeController.text = value;
        isCameraOn = false;
        error = null;
        _changed();
        return;
      }
    }
  }

  void clearError() {
    if (error == null) return;
    error = null;
    _changed();
  }

  ScanResult? submit(String emptyCodeError) {
    final value = codeController.text.trim();
    if (value.isEmpty) {
      error = emptyCodeError;
      _changed();
      return null;
    }

    Product? product;
    for (final candidate in AppServices.cachedProducts) {
      if (candidate.barcode == value ||
          candidate.sku == value ||
          '${candidate.id}' == value) {
        product = candidate;
        break;
      }
    }
    final path = Uri.tryParse(value)?.pathSegments ?? [];
    final urlId = path.length >= 2 && path[path.length - 2] == 'products'
        ? int.tryParse(path.last)
        : null;
    final number = int.tryParse(value);
    final id =
        product?.id ??
        urlId ??
        (number != null && number > 0 && number < 100000 ? number : null);
    isCameraOn = false;
    error = null;
    _changed();
    return ScanResult(productId: id, product: product, query: value);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
