import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/locale_service.dart';
import '../../../l10n/app_localizations.dart';
import '../view_model/settings_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
    required this.localeService,
  });

  final LocaleService localeService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(localeService: localeService),
      child: Consumer<SettingsViewModel>(
        builder: (context, model, _) {
          final l10n = AppLocalizations.of(context)!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: model.locale.languageCode,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.language,
                ),
                items: [
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                  DropdownMenuItem(value: 'hi', child: Text(l10n.hindi)),
                ],
                onChanged: (languageCode) {
                  if (languageCode != null) model.setLanguage(languageCode);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
