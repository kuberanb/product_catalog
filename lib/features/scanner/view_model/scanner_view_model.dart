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
    error = null;
    isCameraOn = true;
    cameraAttempt++;
    _changed();
  }

  void stopCamera() {
    isCameraOn = false;
    _changed();
  }

  void reset() {
    isCameraOn = false;
    error = null;
    codeController.clear();
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

  ScanResult? submit(String emptyCodeError, String invalidCodeError) {
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
    final uri = Uri.tryParse(value);
    final path = uri?.pathSegments ?? [];
    final catalogueCode =
        uri != null &&
        uri.scheme == 'catalogue' &&
        uri.host == 'product' &&
        uri.userInfo.isEmpty &&
        !uri.hasPort &&
        !uri.hasQuery &&
        !uri.hasFragment &&
        path.length == 1 &&
        RegExp(r'^[0-9]+$').hasMatch(path.single);
    final urlId = catalogueCode ? int.tryParse(path.single) : null;
    final number = int.tryParse(value);
    final id =
        product?.id ??
        urlId ??
        (number != null && number > 0 && number < 100000 ? number : null);
    isCameraOn = false;
    if (id == null || id <= 0) {
      error = invalidCodeError;
      _changed();
      return null;
    }
    if (product == null) {
      for (final candidate in AppServices.cachedProducts) {
        if (candidate.id == id) {
          product = candidate;
          break;
        }
      }
    }
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
