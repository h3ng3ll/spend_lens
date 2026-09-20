import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/sheet_close_header.dart';
import '../../../../../auth/presentation/pages/edit_profile_page/widgets/avatar_source_row.dart';
import 'e_product_image_source.dart';

/// Picks where the new product photo comes from — or removes the current one.
///
/// Returns the choice rather than acting on it, so the staging decision stays
/// with the caller: remove is STAGED and takes effect on Save, never
/// committed on tap (`edit_profile_screen_rules.md`). The sheet itself
/// deletes nothing.
class ProductImageSourceSheet extends StatelessWidget {
  /// Whether a photo currently exists. Gates the Remove row — it is offered
  /// ONLY when there is something to remove.
  final bool hasImage;

  const ProductImageSourceSheet({super.key, required this.hasImage});

  static Future<EProductImageSource?> show(
    BuildContext context, {
    required bool hasImage,
  }) {
    return showModalBottomSheet<EProductImageSource>(
      context: context,
      // Root navigator, above the 5-tab shell — matching `AvatarSourceSheet`.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => ProductImageSourceSheet(hasImage: hasImage),
    );
  }

  void _onClose(BuildContext context) => Navigator.of(context).pop();

  void _onPick(BuildContext context, EProductImageSource source) =>
      Navigator.of(context).pop(source);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return SafeArea(
      child: AppContainer(
        color: scheme.sheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SheetCloseHeader(
                title: lo.changeProductImage,
                onClose: () => _onClose(context),
              ),
              AvatarSourceRow(
                icon: AppIcons.scanFrame,
                label: lo.takePhoto,
                onTap: () => _onPick(context, EProductImageSource.camera),
              ),
              AvatarSourceRow(
                icon: AppIcons.receipt,
                label: lo.chooseFromGallery,
                onTap: () => _onPick(context, EProductImageSource.gallery),
              ),
              if (hasImage)
                AvatarSourceRow(
                  icon: AppIcons.trash,
                  label: lo.removeProductImage,
                  onTap: () => _onPick(context, EProductImageSource.remove),
                  isDestructive: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
