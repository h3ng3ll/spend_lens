import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/circle_back_btn.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Store Detail's header (design_spendlens.md's Stores artboard,
/// `hasStoreSel` branch): a circular back button, the centered store name,
/// and a 40px spacer for symmetric balance (matching the artboard's
/// `<div style="width:40px">`).
class StoreDetailHeader extends StatelessWidget {
  final String storeName;
  final VoidCallback onClose;

  const StoreDetailHeader({
    super.key,
    required this.storeName,
    required this.onClose,
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
            const SizedBox(width: 40.0),
          ],
        ),
      ),
    );
  }
}
