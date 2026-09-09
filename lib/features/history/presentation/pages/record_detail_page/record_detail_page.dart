import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_colors.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/permission_requester.dart';
import '../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../bloc/record_detail_bloc/record_detail_bloc.dart';
import 'widgets/record_detail_body.dart';
import 'widgets/record_detail_header.dart';
import 'widgets/record_detail_view_data.dart';

/// `RecordDetailPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing one History record.
///
/// Renders BOTH branches of the design's Record detail artboard, selected by
/// `Expense.source`:
///
/// - **receipt** — main card, Items card, Receipt photo card, an Edit action
///   routing to `EditReceiptPageRoute`, and a "Delete receipt" row.
/// - **cash** — main card, Note card, and a "Delete expense" row. No Edit
///   action: `CashExpensePageRoute` takes no id and only CREATES, so there
///   is no edit-cash destination to push, and a control that only echoed a
///   toast back would be a dead control shipped as if it worked. That gap is
///   reported rather than papered over — adding an edit-cash route is a new
///   flow, which is escalated, never auto-added.
///
/// The receipt branch resolves by id identity:
/// `CreateExpenseFromReceiptUseCase` writes the mirrored `Expense` with
/// `id: receipt.id` expressly so this screen's single `recordId` finds the
/// receipt it came from — see [RecordDetailBloc].
///
/// [RecordDetailBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class RecordDetailPage extends StatefulWidget {
  final String recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late final RecordDetailBloc _recordDetailBloc = RecordDetailBloc(
    recordId: widget.recordId,
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
    receiptLocalRepository: getIt<IReceiptLocalRepository>(),
    receiptItemLocalRepository: getIt<IReceiptItemLocalRepository>(),
  )..add(const RecordDetailEvent.watch());

  @override
  void dispose() {
    _recordDetailBloc.close();
    super.dispose();
  }

  void _onClose() {
    context.goBack();
  }

  /// The design's `dEdit`. Receipts only — see the class doc.
  void _onEdit() {
    EditReceiptPageRoute(receiptId: widget.recordId).push<void>(context);
  }

  /// The design's `openPhoto` — opens the saved photo full-screen.
  ///
  /// This is the first in-app caller of `ReceiptPhotoPageRoute`: the route
  /// and its screen already existed and were fully implemented, but nothing
  /// navigated to them, so the photo was unreachable.
  void _onViewPhoto() {
    ReceiptPhotoPageRoute(receiptId: widget.recordId).push<void>(context);
  }

  /// The design's `retakePhoto` — re-captures this receipt's photo with the
  /// camera and stores it against the existing receipt.
  ///
  /// Replaces the IMAGE only; it does not re-run the scan pipeline.
  /// `ScannerPage` takes no receipt id (it always starts a fresh scan into
  /// the pending-draft store), so routing there would create a second,
  /// unrelated receipt instead of updating this one.
  Future<void> _onRetakePhoto() async {
    final File? file = await getIt<PermissionRequester>().onPickCamera(context);
    await _replacePhoto(file);
  }

  /// The design's `choosePhoto`.
  Future<void> _onChoosePhoto() async {
    final File? file = await getIt<PermissionRequester>().onPickGallery(
      context,
    );
    await _replacePhoto(file);
  }

  /// Writes [file] as this receipt's photo.
  ///
  /// `ReceiptImageStore.save` uses the STABLE `receipt_<id>.jpg` filename,
  /// so a replace overwrites in place and leaks no orphan — which is also
  /// why the preview's `FutureBuilder` is keyed on the filename.
  Future<void> _replacePhoto(File? file) async {
    if (file == null) return;

    final receiptRepository = getIt<IReceiptLocalRepository>();
    final receipt = await receiptRepository.getById(widget.recordId);
    if (receipt == null) return;

    final filename = await getIt<ReceiptImageStore>().save(
      receiptId: widget.recordId,
      bytes: await file.readAsBytes(),
    );

    await receiptRepository.save(receipt.copyWith(imagePath: filename));
  }

  bool _listenWhenNotFound(
    RecordDetailState previous,
    RecordDetailState current,
  ) {
    return !previous.isNotFound && current.isNotFound;
  }

  /// The record vanished from the watched stream — either this screen's own
  /// delete action succeeded, or it was deleted elsewhere. Either way, the
  /// detail page has nothing left to show and exits.
  void _onNotFound(BuildContext context, RecordDetailState state) {
    context.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent.value,
        body: BlocProvider<RecordDetailBloc>.value(
          value: _recordDetailBloc,
          child: BlocListener<RecordDetailBloc, RecordDetailState>(
            listenWhen: _listenWhenNotFound,
            listener: _onNotFound,
            child: SafeArea(
              child: BlocBuilder<RecordDetailBloc, RecordDetailState>(
                builder: (context, state) {
                  // Resolved ONCE per build and handed to both the header
                  // and the body — the header needs the type label and the
                  // Edit availability, the body needs the same object for
                  // its cards.
                  final viewData = _resolve(context, state);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RecordDetailHeader(
                        // Falls back to the neutral cash label while the
                        // record is still loading, so the header never
                        // renders an empty title.
                        typeLabel: viewData?.typeLabel ??
                            AppLocalizations.of(context).cashType,
                        onClose: _onClose,
                        onEdit: (viewData?.isReceipt ?? false)
                            ? _onEdit
                            : null,
                      ),
                      Expanded(
                        child: RecordDetailBody(
                          state: state,
                          viewData: viewData,
                          onViewPhoto: _onViewPhoto,
                          onRetakePhoto: _onRetakePhoto,
                          onChoosePhoto: _onChoosePhoto,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Resolves the snapshot into everything both the header and the body
  /// render, or null while the record is not ready yet.
  RecordDetailViewData? _resolve(
    BuildContext context,
    RecordDetailState state,
  ) {
    final snapshot = state.snapshot;
    final expense = snapshot?.expense;
    if (!state.isReady || snapshot == null || expense == null) return null;

    return RecordDetailViewData.resolve(
      expense: expense,
      categories: snapshot.categories,
      stores: snapshot.stores,
      receipt: snapshot.receipt,
      lo: AppLocalizations.of(context),
    );
  }
}
