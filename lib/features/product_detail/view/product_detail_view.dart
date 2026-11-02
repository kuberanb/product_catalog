import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../favourites/view_model/favourites_view_model.dart';
import '../../products/view/widgets/product_image.dart';
import '../view_model/product_detail_view_model.dart';
import 'widgets/product_detail_row.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ProductDetailViewModel>();
    final favourites = context.watch<FavouritesViewModel>();
    final t = AppLocalizations.of(context)!;
    final item = model.product;
    final productId = model.productId ?? item?.id;
    final saved = productId != null && favourites.contains(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.productDetails),
        actions: [
          if (item != null)
            IconButton(
              tooltip: saved ? t.removeFavourite : t.addFavourite,
              onPressed: favourites.isLoading || favourites.isSaving
                  ? null
                  : () => favourites.toggle(item),
              icon: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? AppColors.favourite : AppColors.muted,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (model.isLoading) const LinearProgressIndicator(),
          if (model.error != null)
            ErrorView(error: model.error!, onRetry: model.load),
          if (favourites.error != null)
            ErrorView(error: favourites.error!, onRetry: favourites.retry),
          if (item != null)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    height: 230,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ProductImage(url: item.image),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.price(item.price.toStringAsFixed(2)),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.rating),
                      const SizedBox(width: 6),
                      Text(t.rating(item.rating.toStringAsFixed(1))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.description,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description.isEmpty
                        ? t.noDescription
                        : item.description,
                  ),
                  const SizedBox(height: 24),
                  if (item.brand.isNotEmpty)
                    ProductDetailRow(label: t.brand, value: item.brand),
                  if (item.category.isNotEmpty)
                    ProductDetailRow(label: t.category, value: item.category),
                  ProductDetailRow(
                    label: t.availability,
                    value: item.stock > 0 ? t.inStock : t.outOfStock,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
