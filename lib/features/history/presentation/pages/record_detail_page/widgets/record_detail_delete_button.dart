import 'package:flutter/material.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../expense/domain/repositories/i_expense_local_repository.dart';

/// The destructive delete-expense control (design_spendlens.md — Record
/// detail artboard's `dDelete` row).
///
/// CHRONIC BUG GUARD
/// (`db:handler-pops-and-listener-pops-destructive-confirm-pops-twice`):
/// [ConfirmDialog] pops its OWN route exactly once, internally, from its
/// `_onConfirm`/`_onCancel`. The `onConfirm` callback passed to it here is
/// therefore a PURE action — delete the expense, and record a local
/// `confirmed` flag — and never itself pops the dialog route. This screen's
/// own exit is a SEPARATE, deliberate second pop of a DIFFERENT route
/// (the detail page itself), performed only after `ConfirmDialog.show(...)`'s
/// returned future completes (i.e. after the dialog has already closed
/// itself) AND only when `confirmed` is true — two pops of two distinct
/// routes, never a double-pop of one. Cancel correctly leaves the detail
/// page open, because the dialog's future resolves on cancel too and
/// `confirmed` stays false in that case.
class RecordDetailDeleteButton extends StatelessWidget {
  final String recordId;

  const RecordDetailDeleteButton({super.key, required this.recordId});

  Future<void> _onDelete(BuildContext context) async {
    final lo = AppLocalizations.of(context);

    var confirmed = false;

    await ConfirmDialog.show(
      context,
      title: lo.deleteExpenseConfirmTitle,
      body: lo.deleteExpenseConfirmBody,
      confirmLabel: lo.deleteExpense,
      cancelLabel: lo.cancel,
      onConfirm: () {
        confirmed = true;
        getIt<IExpenseLocalRepository>().delete(recordId);
      },
    );

    if (!confirmed) return;

    // The dialog above has already popped ITSELF (see class doc comment).
    // This is the detail page's own, separate exit — a second pop of a
    // DIFFERENT route, performed only now that the dialog is confirmed gone.
    if (!context.mounted) return;
    context.goBack();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => _onDelete(context),
      child: AppContainer(
        height: 64.0,
        width: double.infinity,
        color: scheme.warnTint,
        border: Border.all(color: scheme.warn, width: 1.0),
        borderRadius: BorderRadius.circular(18.0),
        alignment: Alignment.center,
        child: Text(
          lo.deleteExpense,
          style: textTheme.headline17.copyWith(
            color: scheme.warn,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
