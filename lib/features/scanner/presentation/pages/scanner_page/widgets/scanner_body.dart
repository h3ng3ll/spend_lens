import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/models/e_sync_status.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../receipt/domain/models/receipt/receipt.dart';
import '../../../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../presentation/bloc/scanner_bloc/scanner_bloc.dart';
import 'camera_preview_layer.dart';
import 'scanner_failed_sheet.dart';
import 'scanner_processing_sheet.dart';
import 'scanner_top_controls.dart';

/// The scanner's sub-states as one body (design_spendlens.md §5):
/// [CameraPreviewLayer] owns ONLY the camera-plugin lifecycle and paints the
/// searching/detected/capturing overlays — [ScannerBloc] owns the pipeline
/// orchestration itself; [ScannerProcessingSheet] slides up only while
/// `EScannerStatus.processing`; [ScannerFailedSheet] shows only while
/// `EScannerStatus.failed` (spec §8/§66 — Try Again / Enter Manually,
/// never a dead end, and the captured image is NEVER discarded). A
/// [BlocListener] reacts to `EScannerStatus.ready` — the pipeline's
/// successful terminal step — with the actual `ReviewPageRoute` navigation,
/// since navigation is a UI concern the bloc cannot perform itself.
///
/// Reads [SettingsBloc] via an explicit `BlocBuilder` (never a raw
/// `context.watch`/`.read` inside `build()`, per BLoC rule A3.6) for the
/// persisted flash preference — flash is a device-level setting owned by
/// the app-lifetime `SettingsBloc`, not scanner-screen state.
///
/// [_receiptLocalRepository] is resolved from `getIt` by `ScannerPage` and
/// threaded down here as a constructor param — no widget under
/// `presentation/pages/` calls `getIt` itself.
class ScannerBody extends StatelessWidget {
  final IReceiptLocalRepository _receiptLocalRepository;

  const ScannerBody({super.key, required this._receiptLocalRepository});

  void _onReady(BuildContext context) {
    // pushReplacement, NOT `.go()`: this REPLACES the scanner with Review
    // while KEEPING Home beneath it.
    //
    // `.go()` replaced the whole stack, leaving Review with nothing to pop
    // — so Android's back gesture fell through to the OS and exited the
    // app. It still must not be a plain `push`: backing into a finished
    // scanner session would hold a disposed camera controller. Replacing
    // just the scanner gives both — the camera route is gone, and back
    // lands on Home.
    ReviewPageRoute().pushReplacement(context);
  }

  void _onTryAgain(BuildContext context) {
    context.read<ScannerBloc>().add(const ScannerEvent.reset());
  }

  /// Enter Manually creates a blank [Receipt] (empty items, zero total) so
  /// `EditReceiptPageRoute` — which requires a `receiptId` — always has a
  /// real record to load, then REPLACES the scanner with it (keeping Home
  /// beneath, so Cancel and the back gesture both land there). The
  /// captured image is preserved
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
    await _receiptLocalRepository.save(receipt);
    if (!context.mounted) return;
    // Same reasoning as the Review handoff above: replace the scanner,
    // keep Home beneath, so back/Cancel has somewhere to land instead of
    // exiting the app.
    EditReceiptPageRoute(receiptId: receipt.id).pushReplacement(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.settings.flashMode != current.settings.flashMode,
      builder: (context, settingsState) {
        return BlocListener<ScannerBloc, ScannerState>(
          listenWhen: (previous, current) =>
              !previous.isReady && current.isReady,
          listener: (context, state) => _onReady(context),
          child: BlocBuilder<ScannerBloc, ScannerState>(
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
                    ScannerProcessingSheet(
                      processingStep: state.processingStep,
                    ),
                  if (state.isFailed)
                    ScannerFailedSheet(
                      onTryAgain: () => _onTryAgain(context),
                      onEnterManually: () => _onEnterManually(context),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
