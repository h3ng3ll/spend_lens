import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/ui_message_service.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/confirm_dialog.dart';
import '../../../bloc/record_detail_bloc/record_detail_bloc.dart';

/// The destructive delete-expense control (design_spendlens.md — Record
/// detail artboard's `dDelete` row).
///
/// The actual delete write and its outcome are owned by [RecordDetailBloc]
/// now (BLoC-layer violation fix — this widget used to call
/// `getIt<IExpenseLocalRepository>().delete(...)` directly, fire-and-forget,
/// from inside `onConfirm`). [ConfirmDialog] still pops its OWN route
/// exactly once, internally, from its `_onConfirm`/`_onCancel` — the
/// `onConfirm` callback passed to it here is a PURE action: dispatch the
/// delete intent, never itself pop a route
/// (`db:handler-pops-and-listener-pops-destructive-confirm-pops-twice`).
///
/// SUCCESS never navigates from here: once the write lands, this record
/// drops out of the reactive stream `RecordDetailBloc._onWatch` combines,
/// which already flips it to `ERecordDetailStatus.notFound` —
/// `RecordDetailPage`'s `BlocListener` on that transition is what actually
/// exits the detail page. This widget only surfaces FAILURE, via its own
/// `BlocListener` on [RecordDetailState.isDeleteFailed].
class RecordDetailDeleteButton extends StatelessWidget {
  final String recordId;

  /// `dDeleteLabel` — "Delete receipt" for a receipt-sourced record,
  /// "Delete expense" for a cash one. Resolved by the caller so this widget
  /// stays branch-agnostic.
  final String label;

  const RecordDetailDeleteButton({
    super.key,
    required this.recordId,
    required this.label,
  });

  Future<void> _onDelete(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    final bloc = context.read<RecordDetailBloc>();

    await ConfirmDialog.show(
      context,
      title: lo.deleteExpenseConfirmTitle,
      body: lo.deleteExpenseConfirmBody,
      confirmLabel: label,
      cancelLabel: lo.cancel,
      onConfirm: () => bloc.add(RecordDetailEvent.deleteRecord(recordId)),
    );
  }

  bool _listenWhenDeleteFailed(
    RecordDetailState previous,
    RecordDetailState current,
  ) {
    return !previous.isDeleteFailed && current.isDeleteFailed;
  }

  void _onDeleteFailed(BuildContext context, RecordDetailState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return BlocListener<RecordDetailBloc, RecordDetailState>(
      listenWhen: _listenWhenDeleteFailed,
      listener: _onDeleteFailed,
      child: GestureDetector(
        onTap: () => _onDelete(context),
        child: AppContainer(
          height: 64.0,
          width: double.infinity,
          color: scheme.warnTint,
          border: Border.all(color: scheme.warn, width: 1.0),
          borderRadius: BorderRadius.circular(18.0),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.headline17.copyWith(
              color: scheme.warn,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
