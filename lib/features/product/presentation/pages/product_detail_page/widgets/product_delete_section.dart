import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/confirm_dialog.dart';

/// Deletes the product and, with it, every price point that priced it.
///
/// The confirm body names the price-point count through a real ICU plural,
/// so the user knows exactly what goes — a delete that understates its own
/// blast radius is how history disappears unnoticed.
class ProductDeleteSection extends StatelessWidget {
  final int pricePointCount;
  final VoidCallback onDelete;

  const ProductDeleteSection({
    super.key,
    required this.pricePointCount,
    required this.onDelete,
  });

  Future<void> _onTap(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    await ConfirmDialog.show(
      context,
      title: lo.deleteProduct,
      body: lo.deleteProductConfirm(pricePointCount),
      confirmLabel: lo.deleteProduct,
      cancelLabel: lo.cancel,
      // A pure action — it never pops. `ConfirmDialog` pops itself exactly
      // once, and popping again here is the recorded double-pop defect.
      onConfirm: onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: AppContainer(
        height: 56.0,
        width: double.infinity,
        color: scheme.warnTint,
        border: Border.all(color: scheme.warn, width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
        alignment: Alignment.center,
        child: Text(
          lo.deleteProduct,
          style: textTheme.headline17.copyWith(
            color: scheme.warn,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
