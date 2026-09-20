import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation_origin_x.dart';
import '../../../utils/product_price_points.dart';

/// One price point: when, where, and how much.
///
/// EVERY row is tappable, but they lead to different places, because a price
/// is only ever editable where it is DEFINED:
///
///  * a receipt-derived price opens its RECEIPT. The receipt is what
///    describes that price, and `RecordPriceObservationsUseCase` rebuilds
///    the observation from the receipt's lines on every correction save — so
///    editing the observation here would be overwritten the next time the
///    user touched that receipt. Sending them to the receipt makes the
///    correction durable instead of momentary.
///  * a manual price has no receipt behind it, so it opens the small price
///    editor and is the only kind that carries a delete control.
class ProductPriceRow extends StatelessWidget {
  final PriceObservation observation;
  final String? storeName;
  /// Edits a MANUAL price in place.
  final VoidCallback onEdit;

  /// Opens the receipt a scanned price came from.
  final VoidCallback onOpenReceipt;

  final VoidCallback onDelete;
  final bool showBottomDivider;

  const ProductPriceRow({
    super.key,
    required this.observation,
    required this.storeName,
    required this.onEdit,
    required this.onOpenReceipt,
    required this.onDelete,
    required this.showBottomDivider,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final isManual = observation.isManual;
    final meta = storeName ?? lo.productNoStore;

    return GestureDetector(
      onTap: isManual ? onEdit : onOpenReceipt,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: showBottomDivider
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: scheme.line, width: 1.0),
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2.0,
                children: [
                  Text(
                    _formatDate(observation.observedAt),
                    style: textTheme.body17.copyWith(color: scheme.ink),
                  ),
                  Text(
                    isManual ? meta : '$meta · ${lo.fromReceipt}',
                    style: textTheme.footnote13.copyWith(color: scheme.ter),
                  ),
                ],
              ),
            ),
            Text(
              '${formatPrice(observation.comparableUnitPrice)} '
              '${observation.currencyCode}',
              style: textTheme.body17.copyWith(color: scheme.ink),
            ),
            if (isManual)
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AppSvgIcon(
                    asset: AppIcons.trash,
                    color: scheme.ter,
                    size: 16.0,
                  ),
                ),
              )
            else
              AppSvgIcon(
                asset: AppIcons.chevronRight,
                color: scheme.ter,
                size: 16.0,
              ),
          ],
        ),
      ),
    );
  }

  /// `dd.MM.yyyy` — a plain, locale-neutral numeric date. The app has no
  /// shared date formatter for this surface, and a numeric form avoids
  /// inventing month-name plumbing the ARB does not yet carry for prices.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}
