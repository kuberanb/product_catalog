import 'app_colors.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'messages.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          errorText(context, error),
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.error(context)),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: Icon(Icons.refresh),
          label: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    ),
  );
}
