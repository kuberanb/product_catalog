import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/error_view.dart';
import '../../../core/locale_service.dart';
import '../../../core/session_service.dart';
import '../../../l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final session = context.watch<SessionService>();
    final t = AppLocalizations.of(context)!;
    if (locale.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (session.isLoading) const LinearProgressIndicator(),
        Text('Language', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey(locale.locale.languageCode),
          value: locale.locale.languageCode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Language',
          ),
          items: [
            const DropdownMenuItem(value: 'en', child: Text('English')),
            const DropdownMenuItem(value: 'ar', child: Text('Arabic')),
          ],
          onChanged: (code) {
            if (code != null) locale.setLocale(Locale(code));
          },
        ),
        if (locale.error != null)
          ErrorView(error: locale.error!, onRetry: locale.retry),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: session.isLoading ? null : session.logout,
          icon: const Icon(Icons.logout),
          label: Text(t.logout),
        ),
        if (session.error != null)
          ErrorView(error: session.error!, onRetry: session.logout),
      ],
    );
  }
}
