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
    required this.onOpenSettings,
  });

  final int attempt;
  final ValueChanged<BarcodeCapture> onDetect;
  final VoidCallback onCameraError;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

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
      errorBuilder: (_, error) => _CameraErrorView(
        message: error.errorCode == MobileScannerErrorCode.permissionDenied
            ? t.cameraPermissionDenied
            : t.cameraError,
        retryLabel: t.retry,
        onRetry: onRetry,
        settingsLabel: t.openSettings,
        onOpenSettings:
            error.errorCode == MobileScannerErrorCode.permissionDenied
            ? onOpenSettings
            : null,
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    required this.settingsLabel,
    this.onOpenSettings,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  final String settingsLabel;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.surface(context),
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography_outlined,
              size: 40,
              color: AppColors.muted(context),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
                if (onOpenSettings != null)
                  TextButton(
                    onPressed: onOpenSettings,
                    child: Text(settingsLabel),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
