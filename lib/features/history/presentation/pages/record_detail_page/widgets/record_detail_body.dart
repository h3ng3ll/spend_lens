import 'package:flutter/material.dart';

import '../../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/record_detail_bloc/record_detail_bloc.dart';
import 'record_detail_card.dart';
import 'record_detail_delete_button.dart';
import 'record_detail_items_card.dart';
import 'record_detail_not_found.dart';
import 'record_detail_note_card.dart';
import 'record_detail_photo_card.dart';
import 'record_detail_view_data.dart';

/// Populated / loading / not-found / error presentation below
/// [RecordDetailHeader] — everything `RecordDetailPage`'s `Scaffold` body
/// needs besides the header itself.
///
/// Card order follows the artboard (line 309–345): the main card, then the
/// Items card (receipts), then the Note card (cash), then the Receipt photo
/// card (receipts), then the destructive delete row.
///
/// Which branch renders is DATA-driven — `viewData.isReceipt` comes from
/// `Expense.source`, and the receipt cards additionally require the receipt
/// to have actually resolved. A cash expense keeps exactly the card set it
/// had before this change.
class RecordDetailBody extends StatelessWidget {
  final RecordDetailState state;

  /// Resolved once by `RecordDetailPage` and shared with the header, so the
  /// snapshot is not mapped twice per build. Null until the record is
  /// ready, which the status branches below handle first anyway.
  final RecordDetailViewData? viewData;

  final VoidCallback onViewPhoto;
  final Future<void> Function() onRetakePhoto;
  final Future<void> Function() onChoosePhoto;

  const RecordDetailBody({
    super.key,
    required this.state,
    required this.viewData,
    required this.onViewPhoto,
    required this.onRetakePhoto,
    required this.onChoosePhoto,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isFailed) {
      return ErrorMessageWidget(message: state.errorMessage);
    }

    if (state.isNotFound) {
      return const Center(child: RecordDetailNotFound());
    }

    final snapshot = state.snapshot;
    final expense = snapshot?.expense;
    final viewData = this.viewData;
    if (!state.isReady ||
        snapshot == null ||
        expense == null ||
        viewData == null) {
      return const LoadingDataWidget();
    }

    final receipt = snapshot.receipt;
    final note = viewData.note;
    final items = snapshot.items;
    final products = snapshot.products;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            RecordDetailCard(
              initial: viewData.initial,
              tileBackground: viewData.tileBackground,
              tileForeground: viewData.tileForeground,
              name: viewData.name,
              dateText: viewData.dateText,
              amountText: viewData.amountText,
              currencyCode: viewData.currencyCode,
              typeLabel: viewData.typeLabel,
              categoryLabel: viewData.categoryLabel,
              categoryDotColor: viewData.categoryDotColor,
              syncLabel: viewData.syncLabel,
              syncDotColor: viewData.syncDotColor,
            ),
            if (items.isNotEmpty)
              RecordDetailItemsCard(items: items, products: products),
            if (note != null && note.trim().isNotEmpty)
              RecordDetailNoteCard(note: note),
            if (receipt != null)
              RecordDetailPhotoCard(
                filename: receipt.imagePath,
                onView: onViewPhoto,
                onRetake: onRetakePhoto,
                onChooseLibrary: onChoosePhoto,
              ),
            RecordDetailDeleteButton(
              label: viewData.deleteLabel,
            ),
          ],
        ),
      ),
    );
  }
}
