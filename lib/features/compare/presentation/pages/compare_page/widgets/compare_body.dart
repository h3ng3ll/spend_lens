import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../product/domain/models/product/product.dart';
import '../../../../../product/presentation/utils/product_price_points.dart';
import '../../../../domain/models/compare_snapshot/compare_snapshot.dart';
import '../../../utils/compare_lists.dart';
import 'compare_column.dart';

/// Two stores side by side, each with its own product list.
///
/// Both halves scroll as one page rather than independently: with two short
/// lists a shared scroll keeps the store selectors aligned at the top, which
/// is what makes the two columns readable as a comparison.
class CompareBody extends StatelessWidget {
  final CompareSnapshot snapshot;
  final String? leftStoreId;
  final String? rightStoreId;
  final VoidCallback onPickLeft;
  final VoidCallback onPickRight;
  final ValueChanged<Product> onOpenProduct;

  const CompareBody({
    super.key,
    required this.snapshot,
    required this.leftStoreId,
    required this.rightStoreId,
    required this.onPickLeft,
    required this.onPickRight,
    required this.onOpenProduct,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    if (snapshot.stores.length < 2) {
      return Center(
        child: HorizontalPadding(
          child: AppEmptyState(
            icon: AppIcons.store,
            title: lo.compareNeedsTwoStoresTitle,
            body: lo.compareNeedsTwoStoresBody,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [
              Expanded(
                child: CompareColumn(
                  storeId: leftStoreId,
                  storeName: storeNameFor(snapshot.stores, leftStoreId),
                  products: productsForStore(snapshot.products, leftStoreId),
                  observations: snapshot.observations,
                  onPickStore: onPickLeft,
                  onOpenProduct: onOpenProduct,
                ),
              ),
              Expanded(
                child: CompareColumn(
                  storeId: rightStoreId,
                  storeName: storeNameFor(snapshot.stores, rightStoreId),
                  products: productsForStore(snapshot.products, rightStoreId),
                  observations: snapshot.observations,
                  onPickStore: onPickRight,
                  onOpenProduct: onOpenProduct,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
