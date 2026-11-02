import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/locale_service.dart';
import '../../favourites/view/favourites_view.dart';
import '../../settings/view/settings_view.dart';
import '../../../l10n/app_localizations.dart';
import '../view_model/bottom_nav_view_model.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key, required this.localeService});

  final LocaleService localeService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BottomNavViewModel(),
      child: Consumer<BottomNavViewModel>(
        builder: (context, model, _) {
          final l10n = AppLocalizations.of(context)!;
          final titles = [l10n.products, l10n.favourites, l10n.settings];
          final pages = [
            _TabPage(title: l10n.products, icon: Icons.inventory_2_outlined),
            const FavouritesView(),
            SettingsView(localeService: localeService),
          ];

          return Scaffold(
            appBar: AppBar(title: Text(titles[model.selectedIndex])),
            body: IndexedStack(index: model.selectedIndex, children: pages),
            bottomNavigationBar: NavigationBar(
              selectedIndex: model.selectedIndex,
              onDestinationSelected: model.selectTab,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: l10n.products,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.favorite_border),
                  label: l10n.favourites,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  label: l10n.settings,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TabPage extends StatelessWidget {
  const _TabPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    ),
  );
}
