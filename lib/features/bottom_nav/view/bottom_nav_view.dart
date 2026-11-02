import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../favourites/view/favourites_view.dart';
import '../../favourites/view_model/favourites_view_model.dart';
import '../../products/view/products_view.dart';
import '../../products/view_model/products_view_model.dart';
import '../../search/view/search_view.dart';
import '../../search/view_model/search_view_model.dart';
import '../../scanner/view/scanner_view.dart';
import '../../scanner/view_model/scanner_view_model.dart';
import '../../settings/view/settings_view.dart';
import '../view_model/bottom_nav_view_model.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BottomNavViewModel>();
    final products = context.watch<ProductsViewModel>();
    final favourites = context.watch<FavouritesViewModel>();
    final t = AppLocalizations.of(context)!;
    final titles = [t.products, t.favourites, t.settings];
    final pages = [
      const ProductsView(),
      const FavouritesView(),
      const SettingsView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[model.selectedIndex]),
        actions: model.selectedIndex == 0
            ? [
                IconButton(
                  tooltip: t.search,
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<SearchViewModel>().search('');
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchView()),
                    );
                  },
                ),
                IconButton(
                  tooltip: t.scanner,
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    context.read<ScannerViewModel>().reset();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ScannerView()),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          if (products.isOffline)
            Material(
              color: AppColors.offline,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off),
                    const SizedBox(width: 12),
                    Expanded(child: Text(t.offline)),
                    TextButton(
                      onPressed: () => products.load(refresh: true),
                      child: Text(t.retry),
                    ),
                  ],
                ),
              ),
            ),
          if (model.selectedIndex == 0 && favourites.error != null)
            ErrorView(error: favourites.error!, onRetry: favourites.retry),
          Expanded(
            child: IndexedStack(index: model.selectedIndex, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: model.selectedIndex,
        onDestinationSelected: model.selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            label: t.products,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            label: t.favourites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: t.settings,
          ),
        ],
      ),
    );
  }
}
