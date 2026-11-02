import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../product_detail/view/product_detail_view.dart';
import '../../product_detail/view_model/product_detail_view_model.dart';
import '../../search/view/search_view.dart';
import '../../search/view_model/search_view_model.dart';
import '../view_model/scanner_view_model.dart';
import 'widgets/scanner_camera_view.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  void _submit(
    BuildContext context,
    ScannerViewModel scanner,
    AppLocalizations t,
  ) {
    final result = scanner.submit(t.enterCode);
    if (result == null) return;
    if (result.productId != null) {
      final details = context.read<ProductDetailViewModel>();
      details.selectProduct(
        id: result.productId!,
        selectedProduct: result.product,
      );
      details.load();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProductDetailView()));
    } else {
      context.read<SearchViewModel>().search(result.query);
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SearchView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ScannerViewModel>();
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.scanner)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t.scannerHint, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: model.isCameraOn
                  ? ScannerCameraView(
                      attempt: model.cameraAttempt,
                      onDetect: model.onDetected,
                      onCameraError: () =>
                          model.cameraUnavailable(t.cameraError),
                      onRetry: model.retryCamera,
                    )
                  : ColoredBox(
                      color: AppColors.surface,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code_scanner,
                              size: 72,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: model.startCamera,
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: Text(t.startCamera),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: model.codeController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: t.productCode,
              hintText: t.codeHint,
              errorText: model.error,
            ),
            onChanged: (_) => model.clearError(),
            onSubmitted: (_) => _submit(context, model, t),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _submit(context, model, t),
            child: Text(t.findProduct),
          ),
        ],
      ),
    );
  }
}
