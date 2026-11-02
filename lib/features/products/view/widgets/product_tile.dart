import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../favourites/view_model/favourites_view_model.dart';
import '../../model/product.dart';
import '../../../product_detail/view/product_detail_view.dart';
import '../../../product_detail/view_model/product_detail_view_model.dart';
import 'product_image.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesViewModel>();
    final saved = favourites.contains(product.id);
    final t = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final detail = context.read<ProductDetailViewModel>();
          detail.selectProduct(id: product.id, selectedProduct: product);
          detail.load();
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ProductDetailView()));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: ProductImage(url: product.image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.price(product.price.toStringAsFixed(2)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.rating,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          semanticsLabel: t.rating(
                            product.rating.toStringAsFixed(1),
                          ),
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved ? t.removeFavourite : t.addFavourite,
                onPressed: favourites.isLoading || favourites.isSaving
                    ? null
                    : () => favourites.toggle(product),
                icon: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  color: saved ? AppColors.favourite : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
