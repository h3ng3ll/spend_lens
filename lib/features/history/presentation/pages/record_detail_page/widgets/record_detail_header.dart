import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/circle_back_btn.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Record Detail's header (design_spendlens.md — Record detail artboard): a
/// circular back button, the centered record-type label (`{{ dType }}`),
/// and a text Edit action on the right.
///
/// M5 scope boundary: [onEdit] is wired by the page to an info toast, not a
/// real edit flow — there is no dedicated edit-cash-expense route in
/// `init_router.dart` at this milestone (verified: only `CashExpensePageRoute`
/// exists, and it creates a NEW expense), and inventing one is outside this
/// screen's scope. See `RecordDetailPage`'s doc comment.
class RecordDetailHeader extends StatelessWidget {
  final String typeLabel;
  final String editLabel;
  final VoidCallback onClose;
  final VoidCallback onEdit;

  const RecordDetailHeader({
    super.key,
    required this.typeLabel,
    required this.editLabel,
    required this.onClose,
    required this.onEdit,
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
            SizedBox(
              width: 40.0,
              child: GestureDetector(
                onTap: onEdit,
                child: Align(
                  child: Text(
                    editLabel,
                    style: textTheme.subhead15.copyWith(
                      color: scheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
