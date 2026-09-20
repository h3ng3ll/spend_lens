import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/create_new_row.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../store/domain/models/store/store.dart';
import '../../../../domain/models/product/product.dart';
import '../../../utils/product_price_points.dart';
import 'product_pick_row.dart';
import 'product_search_field.dart';

/// Narrows [products] to the ones this picker may offer — a pure function,
/// never a bloc state field (BLoC rule A3.1: no `filteredX` in state).
List<Product> scopeProducts(
  List<Product> products, {
  String? storeId,
}) {
  return products.where((product) {
    if (product.deletedAt != null) return false;
    if (storeId == null) return true;
    // Scoped to a store: its own products, plus the general-purpose ones,
    // which belong to no store and so are offerable anywhere — the same
    // candidate rule `ProductNormalizer` applies when matching.
    return product.storeId == storeId || product.storeId == null;
  }).toList();
}

/// Filters [products] by [query] against the display name AND the aliases —
/// aliases are the spellings a receipt actually printed, so searching them
/// is what lets a user find a product by the text they saw on paper.
List<Product> filterProducts(List<Product> products, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return products;

  return products.where((product) {
    if (product.displayName.toLowerCase().contains(normalized)) return true;
    return product.aliases.any(
      (alias) => alias.toLowerCase().contains(normalized),
    );
  }).toList();
}

/// Populated / empty presentation for `ChooseProductPage` — search field,
/// quick-create row, and the filtered list.
///
/// The search field and the create affordance stay visible even when the
/// list is empty, so the create path is always reachable — the same
/// discipline `ChooseStoreBody` documents.
class ChooseProductBody extends StatelessWidget {
  final List<Product> products;
  final List<Store> stores;
  final TextEditingController searchController;
  final VoidCallback onQuickCreate;
  final ValueChanged<Product> onPick;

  const ChooseProductBody({
    super.key,
    required this.products,
    required this.stores,
    required this.searchController,
    required this.onQuickCreate,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final query = searchController.text;
    final filtered = filterProducts(products, query);
    final trimmedQuery = query.trim();
    final showCreate = trimmedQuery.isNotEmpty && filtered.isEmpty;

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            ProductSearchField(controller: searchController),
            if (showCreate)
              CreateNewRow(
                title: '${lo.create} "$trimmedQuery"',
                subtitle: lo.newProductHint,
                onTap: onQuickCreate,
              ),
            if (filtered.isNotEmpty)
              AppSectionCard(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final product in filtered)
                      ProductPickRow(
                        product: product,
                        storeName: storeNameFor(stores, product.storeId),
                        isSelected: false,
                        onTap: () => onPick(product),
                      ),
                  ],
                ),
              )
            else
              Center(
                child: Text(
                  lo.noMatchingProduct,
                  textAlign: TextAlign.center,
                  style: textTheme.subhead15.copyWith(color: scheme.ter),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
