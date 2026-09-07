import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/models/e_sync_status.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../receipt/domain/models/receipt/receipt.dart';
import '../../../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../domain/pending_receipt_draft_store.dart';
import '../../../../presentation/bloc/scanner_bloc/scanner_bloc.dart';
import 'camera_preview_layer.dart';
import 'scanner_failed_sheet.dart';
import 'scanner_processing_sheet.dart';
import 'scanner_top_controls.dart';

/// The scanner's four (five, counting `failed`) sub-states as one body
/// (design_spendlens.md §5): [CameraPreviewLayer] owns the camera +
/// pipeline orchestration and paints the searching/detected/capturing
/// overlays; [ScannerProcessingSheet] slides up only while
/// `EScannerStatus.processing`; [ScannerFailedSheet] shows only while
/// `EScannerStatus.failed` (spec §8/§66 — Try Again / Enter Manually,
/// never a dead end, and the captured image is NEVER discarded).
///
/// Reads [SettingsBloc] via an explicit `BlocBuilder` (never a raw
/// `context.watch`/`.read` inside `build()`, per BLoC rule A3.6) for the
/// persisted flash preference — flash is a device-level setting owned by
/// the app-lifetime `SettingsBloc`, not scanner-screen state.
class ScannerBody extends StatelessWidget {
  const ScannerBody({super.key});

  void _onTryAgain(BuildContext context) {
    // A fresh attempt is starting — the previous failed parse (if any) is
    // superseded, not carried forward. This does NOT violate "never
    // discard the captured image" (spec §66): that guarantee protects a
    // failed scan the user has not yet retried or exited, not a scan the
    // user has explicitly asked to redo.
    getIt<PendingReceiptDraftStore>().clear();
    context.read<ScannerBloc>().add(const ScannerEvent.reset());
  }

  /// Enter Manually creates a blank [Receipt] (empty items, zero total) so
  /// `EditReceiptPageRoute` — which requires a `receiptId` — always has a
  /// real record to load, then pushes it. The captured image is preserved
  /// on the draft store; this path does not need it (a manual entry starts
  /// from a blank form), but it is NEVER cleared/discarded here either
  /// (spec §66) — only a completed Review save or an explicit Retake clears
  /// it.
  Future<void> _onEnterManually(BuildContext context) async {
    final now = DateTime.now();
    final receipt = Receipt(
      id: '${now.microsecondsSinceEpoch}',
      purchasedAt: now,
      itemsTotal: 0.0,
      currencyCode: 'MDL',
      itemIds: const [],
      updatedAt: now,
      syncStatus: ESyncStatus.pendingCreate,
    );
    await getIt<IReceiptLocalRepository>().save(receipt);
    if (!context.mounted) return;
    EditReceiptPageRoute(receiptId: receipt.id).go(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.settings.flashMode != current.settings.flashMode,
      builder: (context, settingsState) {
        return BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreviewLayer(
                  state: state,
                  flashMode: settingsState.settings.flashMode,
                ),
                ScannerTopControls(
                  flashMode: settingsState.settings.flashMode,
                ),
                if (state.isProcessing)
                  ScannerProcessingSheet(processingStep: state.processingStep),
                if (state.isFailed)
                  ScannerFailedSheet(
                    onTryAgain: () => _onTryAgain(context),
                    onEnterManually: () => _onEnterManually(context),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
