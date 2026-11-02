import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../products/view/widgets/product_tile.dart';
import '../view_model/favourites_view_model.dart';

class FavouritesView extends StatelessWidget {
  const FavouritesView({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<FavouritesViewModel>();
    final t = AppLocalizations.of(context)!;
    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        if (model.isSaving) const LinearProgressIndicator(),
        if (model.error != null)
          ErrorView(error: model.error!, onRetry: model.retry),
        Expanded(
          child: model.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_border, size: 56),
                        const SizedBox(height: 16),
                        Text(
                          t.noFavourites,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(t.favouritesHint, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: model.products.length,
                  itemBuilder: (_, i) => ProductTile(
                    key: ValueKey(model.products[i].id),
                    product: model.products[i],
                  ),
                ),
        ),
      ],
    );
  }
}
