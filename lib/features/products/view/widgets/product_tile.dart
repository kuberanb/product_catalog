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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.price(product.price.toStringAsFixed(2)),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.rating(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          semanticsLabel: t.rating(
                            product.rating.toStringAsFixed(1),
                          ),
                          style: TextStyle(color: AppColors.muted(context)),
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
                  color: saved
                      ? AppColors.favourite(context)
                      : AppColors.muted(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
