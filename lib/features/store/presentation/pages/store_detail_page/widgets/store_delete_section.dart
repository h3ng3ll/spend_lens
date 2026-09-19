import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/ui_message_service.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/confirm_dialog.dart';
import '../../../../domain/use_cases/delete_store_use_case.dart';
import '../../../bloc/stores_bloc/stores_bloc.dart';

/// The destructive delete-store control (design_spendlens.md's Stores
/// artboard, `hasStoreSel` branch's `storeCanDelete` block).
///
/// **Always shown.** It used to render `SizedBox.shrink()` whenever any
/// expense referenced the store, which meant a store the user had actually
/// shopped at could never be deleted and the feature simply looked missing —
/// create and edit existed, delete did not. The guard was protecting against
/// dangling `storeId` references; [DeleteStoreUseCase] now removes the
/// referencing records too, so the guard is no longer what keeps the data
/// consistent and only hid a working feature.
///
/// The consequence is stated BEFORE the write, with a real count: the impact
/// is measured first, so the dialog says "3 linked records" because three
/// rows were found — not as a guess, and not as vague copy the user has to
/// interpret. A store nothing references gets the plain confirmation.
///
/// The actual delete write and its outcome are owned entirely by
/// [StoresBloc]. [ConfirmDialog] still pops its OWN route exactly once,
/// internally, from its `_onConfirm`/`_onCancel` — the `onConfirm` callback
/// passed to it here is a PURE action: dispatch the delete intent, never
/// itself pop a route
/// (`db:handler-pops-and-listener-pops-destructive-confirm-pops-twice`).
///
/// SUCCESS never navigates from here: once the write lands, this store
/// drops out of every repository the reactive `StoreDetailBloc` combines,
/// which already flips it to `EStoreDetailStatus.notFound` —
/// `StoreDetailPage`'s existing `BlocListener` on that transition is what
/// actually exits the detail page. This widget only surfaces FAILURE, via
/// its own `BlocListener` on [StoresState.lastWriteFailed].
class StoreDeleteSection extends StatelessWidget {
  final String storeId;

  const StoreDeleteSection({super.key, required this.storeId});

  Future<void> _onDelete(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    final bloc = context.read<StoresBloc>();

    // Counted before the dialog is built so the copy can name the real
    // number. `impact` is read-only — nothing is removed by asking.
    final impact = await getIt<DeleteStoreUseCase>().impact(storeId);
    if (!context.mounted) return;

    final total = impact.expenses + impact.receipts;

    await ConfirmDialog.show(
      context,
      title: lo.deleteStore,
      body: impact.hasRecords
          ? lo.deleteStoreBody(total)
          : lo.deleteStoreBodyEmpty,
      confirmLabel: lo.deleteStore,
      cancelLabel: lo.cancel,
      onConfirm: () => bloc.add(StoresEvent.delete(storeId)),
    );
  }

  bool _listenWhenWriteFailed(StoresState previous, StoresState current) {
    return !previous.isWriteFailed && current.isWriteFailed;
  }

  void _onWriteFailed(BuildContext context, StoresState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return BlocListener<StoresBloc, StoresState>(
      listenWhen: _listenWhenWriteFailed,
      listener: _onWriteFailed,
      child: Column(
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
      ),
    );
  }
}
