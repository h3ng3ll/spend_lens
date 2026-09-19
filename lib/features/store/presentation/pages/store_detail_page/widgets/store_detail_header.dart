import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/circle_back_btn.dart';
import '../../../../../../core/widgets/btn/circle_edit_btn.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Store Detail's header (design_spendlens.md's Stores artboard,
/// `hasStoreSel` branch): a circular back button, the centered store name,
/// and a trailing 40px slot.
///
/// That slot is the artboard's `<div style="width:40px">` spacer when there
/// is nothing to edit, and a width-identical [CircleEditBtn] when [onEdit] is
/// given — so the title stays centred either way and the header does not
/// shift as the store loads.
class StoreDetailHeader extends StatelessWidget {
  final String storeName;
  final VoidCallback onClose;

  /// Opens the edit-store sheet. Null on the loading/error frames, where
  /// there is no store to edit yet — the spacer is rendered instead, so a tap
  /// can never reach a sheet for a record that has not loaded.
  final VoidCallback? onEdit;

  const StoreDetailHeader({
    super.key,
    required this.storeName,
    required this.onClose,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return HorizontalPadding(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleBackBtn(onTap: onClose),
            Expanded(
              child: Text(
                storeName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headline17Semi.copyWith(color: scheme.ink),
              ),
            ),
            if (onEdit == null)
              const SizedBox(width: 40.0)
            else
              CircleEditBtn(onTap: onEdit!),
          ],
        ),
      ),
    );
  }
}
