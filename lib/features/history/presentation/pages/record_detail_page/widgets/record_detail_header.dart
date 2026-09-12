import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/circle_back_btn.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import 'e_record_detail_menu_action.dart';
import 'record_detail_menu_button.dart';

/// Record Detail's header (design_spendlens.md — Record detail artboard): a
/// circular back button, the centered record-type label (`{{ dType }}`), and
/// the trailing Edit action.
///
/// The menu appears ONLY when [onMenuAction] is non-null, which is the
/// receipt branch. It replaced a plain "Edit" text action once the screen
/// had a second thing to offer (storage details); Edit is now its first
/// entry and still routes to `EditReceiptPageRoute`
/// (`/receipt/:receiptId/edit`), the same screen the scan flow's "Correct"
/// button opens.
///
/// A cash expense has none: `CashExpensePageRoute` takes no id and only
/// CREATES a new expense, so there is no edit-cash route to push. Rather
/// than ship a control that echoes a toast back at the user, the action is
/// omitted for that branch and the gap reported. Adding an edit-cash route
/// would be a new flow, which is escalated, never auto-added
/// (CLAUDE.md's "no invented screens/routes/flows").
class RecordDetailHeader extends StatelessWidget {
  static const _actionWidth = 40.0;

  final String typeLabel;
  final VoidCallback onClose;
  final ValueChanged<ERecordDetailMenuAction>? onMenuAction;

  const RecordDetailHeader({
    super.key,
    required this.typeLabel,
    required this.onClose,
    this.onMenuAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final menuAction = onMenuAction;

    return HorizontalPadding(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
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
            // Matches the back button's 40dp so the title stays optically
            // centered whether or not Edit is present — the same
            // `width:40px` the design gives both header cells.
            SizedBox(
              width: _actionWidth,
              child: menuAction == null
                  ? null
                  : RecordDetailMenuButton(onSelected: menuAction),
            ),
          ],
        ),
      ),
    );
  }
}
