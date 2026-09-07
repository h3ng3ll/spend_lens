import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/circle_back_btn.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Record Detail's header (design_spendlens.md — Record detail artboard): a
/// circular back button and the centered record-type label (`{{ dType }}`).
///
/// M5 scope boundary: no Edit action is rendered here — there is no
/// dedicated edit-cash-expense route in `init_router.dart` at this
/// milestone (verified: only `CashExpensePageRoute` exists, and it creates
/// a NEW expense), and inventing one is outside this screen's scope. A
/// control that only echoed its own label back as a toast was removed
/// rather than shipped as a dead stub. See `RecordDetailPage`'s doc
/// comment.
class RecordDetailHeader extends StatelessWidget {
  final String typeLabel;
  final VoidCallback onClose;

  const RecordDetailHeader({
    super.key,
    required this.typeLabel,
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
                typeLabel,
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
