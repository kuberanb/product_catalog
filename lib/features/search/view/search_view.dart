import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../products/view/widgets/product_tile.dart';
import '../view_model/search_view_model.dart';
import 'widgets/search_message.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SearchViewModel>();
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.search)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              initialValue: model.query,
              textInputAction: TextInputAction.search,
              onChanged: model.setQuery,
              onFieldSubmitted: model.search,
              decoration: InputDecoration(
                hintText: t.searchHint,
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: t.search,
                  onPressed: () => model.search(model.query),
                  icon: Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
          if (model.isLoading) const LinearProgressIndicator(),
          if (model.isOffline)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      t.offline,
                      style: TextStyle(color: AppColors.muted(context)),
                    ),
                  ),
                  TextButton(onPressed: model.retry, child: Text(t.retry)),
                ],
              ),
            )
          else if (model.error != null)
            ErrorView(error: model.error!, onRetry: model.retry),
          Expanded(
            child: model.query.isEmpty
                ? SearchMessage(icon: Icons.search, message: t.searchPrompt)
                : model.products.isEmpty && !model.isLoading
                ? SearchMessage(
                    icon: Icons.search_off,
                    message: t.noSearchResults,
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification &&
                          (notification.scrollDelta ?? 0) > 0 &&
                          notification.metrics.extentAfter < 300 &&
                          model.hasMore &&
                          model.error == null) {
                        model.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount:
                          model.products.length + (model.hasMore ? 1 : 0),
                      itemBuilder: (_, index) => index < model.products.length
                          ? ProductTile(
                              key: ValueKey(model.products[index].id),
                              product: model.products[index],
                            )
                          : Center(
                              child: TextButton(
                                onPressed: model.isLoading
                                    ? null
                                    : model.loadMore,
                                child: Text(t.loadMore),
                              ),
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
