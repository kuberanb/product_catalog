import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../view_model/favourites_view_model.dart';

class FavouritesView extends StatelessWidget {
  const FavouritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavouritesViewModel(),
      child: Consumer<FavouritesViewModel>(
        builder: (context, model, _) {
          final l10n = AppLocalizations.of(context)!;
          if (model.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noFavourites,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.favouritesHint,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            children: model.productIds
                .map(
                  (productId) => ListTile(
                    leading: const Icon(Icons.favorite),
                    title: Text(productId),
                    trailing: IconButton(
                      tooltip: l10n.removeFavourite,
                      icon: const Icon(Icons.favorite),
                      onPressed: () => model.toggle(productId),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
