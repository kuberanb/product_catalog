import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../view_model/products_view_model.dart';
import 'widgets/product_tile.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<ProductsViewModel>();
    final t = AppLocalizations.of(context)!;
    if (model.isLoading && model.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: () => model.load(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification &&
              (notification.scrollDelta ?? 0) > 0 &&
              notification.metrics.extentAfter < 300 &&
              model.hasMore &&
              !model.isLoading &&
              model.error == null) {
            model.load();
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: model.products.isEmpty ? 1 : model.products.length + 1,
          itemBuilder: (context, index) {
            if (index < model.products.length) {
              return ProductTile(
                key: ValueKey(model.products[index].id),
                product: model.products[index],
              );
            }
            if (model.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (model.error != null) {
              return ErrorView(error: model.error!, onRetry: model.retry);
            }
            if (model.products.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(48),
                child: Text(t.noProducts, textAlign: TextAlign.center),
              );
            }
            if (model.hasMore) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: model.load,
                  child: Text(t.loadMore),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(t.allProductsLoaded, textAlign: TextAlign.center),
            );
          },
        ),
      ),
    );
  }
}
