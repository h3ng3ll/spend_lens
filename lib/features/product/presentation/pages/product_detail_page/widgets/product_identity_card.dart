import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/build_product_image.dart';
import '../../../../domain/models/product/product.dart';

/// The product's identity: name, owning store (or the general-purpose
/// label), and the initial tile.
///
/// "General purpose" is `storeId == null` rendered — there is no separate
/// flag, so the label and the data can never disagree.
class ProductIdentityCard extends StatelessWidget {
  /// Matches the 36dp box `InitialTile` drew here before the photo existed,
  /// so the row's geometry is unchanged.
  static const double _imageSize = 36.0;

  final Product product;
  final String? storeName;

  /// Opens the edit sheet for name, store, category and unit.
  ///
  /// A VISIBLE icon, not just a tappable card: this card shipped inert, and
  /// an affordance nobody can see is why the name could not be corrected and
  /// the product could not be tied to a store.
  final VoidCallback onEdit;

  const ProductIdentityCard({
    super.key,
    required this.product,
    required this.storeName,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final resolvedStoreName = storeName;
    final metaText = product.storeId == null || resolvedStoreName == null
        ? lo.generalPurpose
        : resolvedStoreName;

    return GestureDetector(
      onTap: onEdit,
      behavior: HitTestBehavior.opaque,
      child: AppSectionCard(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            // The product's photo, falling back to its initial when there is
            // none — `BuildProductImage` owns that choice, so this card never
            // has to hold image bytes to show a mark.
            BuildProductImage(
              filename: product.imageFilename ?? '',
              productName: product.displayName,
              size: _imageSize,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    product.displayName,
                    style: textTheme.headline17Semi.copyWith(color: scheme.ink),
                  ),
                  Text(
                    metaText,
                    style: textTheme.footnote13.copyWith(
                      color: product.storeId == null ? scheme.ter : scheme.sec,
                    ),
                  ),
                ],
              ),
            ),
            AppSvgIcon(
              asset: AppIcons.edit,
              color: scheme.ter,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }

}
