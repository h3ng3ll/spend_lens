import 'package:flutter/material.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../domain/repositories/i_store_local_repository.dart';

/// The destructive delete-store control (design_spendlens.md's Stores
/// artboard, `hasStoreSel` branch's `storeCanDelete` block): shown only when
/// no expense references this store — the design's "no receipts linked"
/// condition, mapped for M5's manual-entry data model to "no expenses have
/// this storeId" (there are no receipts yet at all in this milestone).
///
/// CHRONIC BUG GUARD
/// (`db:handler-pops-and-listener-pops-destructive-confirm-pops-twice`):
/// [ConfirmDialog] pops its OWN route exactly once, internally, from its
/// `_onConfirm`/`_onCancel`. The `onConfirm` callback passed to it here is
/// therefore a PURE action — delete the store, and record a local
/// `confirmed` flag — and never itself pops the dialog route. The detail
/// PAGE's own exit is a SEPARATE, deliberate second pop of a DIFFERENT
/// route, performed only after `ConfirmDialog.show(...)`'s returned future
/// completes (i.e. after the dialog has already closed itself) AND only
/// when `confirmed` is true — so this is two pops of two distinct routes,
/// never a double-pop of one, and Cancel correctly leaves the detail page
/// open (the dialog's future resolves on cancel too; without the flag,
/// cancelling would wrongly pop the detail page as well).
class StoreDeleteSection extends StatelessWidget {
  final String storeId;
  final List<Expense> expenses;

  const StoreDeleteSection({
    super.key,
    required this.storeId,
    required this.expenses,
  });

  bool get _canDelete => expenses.isEmpty;

  Future<void> _onDelete(BuildContext context) async {
    final lo = AppLocalizations.of(context);

    // A plain bool, set ONLY inside the pure onConfirm action (never a
    // navigation call there — see the class doc comment) so this method can
    // tell "confirmed" apart from "cancelled" once the dialog's own single
    // pop has already completed. Cancel must NOT exit the detail page.
    var confirmed = false;

    await ConfirmDialog.show(
      context,
      title: lo.deleteStore,
      body: lo.deleteStoreNote,
      confirmLabel: lo.deleteStore,
      cancelLabel: lo.cancel,
      onConfirm: () {
        confirmed = true;
        getIt<IStoreLocalRepository>().delete(storeId);
      },
    );

    if (!confirmed) return;

    // The dialog above has already popped ITSELF (see doc comment). This is
    // the detail page's own, separate exit — a second pop of a DIFFERENT
    // route, performed only now that the dialog is confirmed gone.
    if (!context.mounted) return;
    context.goBack();
  }

  @override
  Widget build(BuildContext context) {
    if (!_canDelete) return const SizedBox.shrink();

    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8.0,
      children: [
        GestureDetector(
          onTap: () => _onDelete(context),
          child: AppContainer(
            height: 56.0,
            width: double.infinity,
            color: scheme.warnTint,
            border: Border.all(color: scheme.warn, width: 1.0),
            borderRadius: BorderRadius.circular(16.0),
            alignment: Alignment.center,
            child: Text(
              lo.deleteStore,
              style: textTheme.headline17.copyWith(
                color: scheme.warn,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Text(
          lo.deleteStoreNote,
          textAlign: TextAlign.center,
          style: textTheme.sectionLabel12.copyWith(color: scheme.ter),
        ),
      ],
    );
  }
}
