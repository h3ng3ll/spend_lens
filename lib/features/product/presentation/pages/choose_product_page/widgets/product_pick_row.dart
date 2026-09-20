import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/build_product_image.dart';
import '../../../../domain/models/product/product.dart';

/// One pickable product: its name, and the store it belongs to.
///
/// The store line is not decoration — products are per-store, so two rows
/// can legitimately carry the SAME name and differ only by shop. Without it
/// the list would look like it contained duplicates.
class ProductPickRow extends StatelessWidget {
  /// Matches the 36dp box `InitialTile` drew here before the photo
  /// existed, so the row's geometry is unchanged.
  static const double _imageSize = 36.0;

  final Product product;
  final String? storeName;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductPickRow({
    super.key,
    required this.product,
    required this.storeName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            BuildProductImage(
              filename: product.imageFilename ?? '',
              productName: product.displayName,
              size: _imageSize,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2.0,
                children: [
                  Text(
                    product.displayName,
                    style: textTheme.body17.copyWith(color: scheme.ink),
                  ),
                  Text(
                    storeName ?? lo.generalPurpose,
                    style: textTheme.footnote13.copyWith(color: scheme.ter),
                  ),
                ],
              ),
            ),
            if (isSelected)
              AppSvgIcon(
                asset: AppIcons.check,
                color: scheme.accent,
                size: 18.0,
              ),
          ],
        ),
      ),
    );
  }

}
