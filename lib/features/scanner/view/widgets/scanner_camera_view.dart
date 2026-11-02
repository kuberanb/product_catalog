import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ScannerCameraView extends StatelessWidget {
  const ScannerCameraView({
    super.key,
    required this.attempt,
    required this.onDetect,
    required this.onCameraError,
    required this.onRetry,
  });

  final int attempt;
  final ValueChanged<BarcodeCapture> onDetect;
  final VoidCallback onCameraError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MobileScanner(
      key: ValueKey(attempt),
      onDetect: onDetect,
      onDetectError: (_, _) => onCameraError(),
      placeholderBuilder: (_) => const ColoredBox(
        color: AppColors.cameraBackground,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorBuilder: (_, _) => _CameraErrorView(
        message: t.cameraError,
        retryLabel: t.retry,
        onRetry: onRetry,
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.surface,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: 40,
              color: AppColors.muted,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    ),
  );
}
