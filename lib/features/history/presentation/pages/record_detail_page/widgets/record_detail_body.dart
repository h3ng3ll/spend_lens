import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/record_detail_bloc/record_detail_bloc.dart';
import 'record_detail_card.dart';
import 'record_detail_delete_button.dart';
import 'record_detail_not_found.dart';
import 'record_detail_note_card.dart';
import 'record_detail_view_data.dart';

/// Populated / loading / not-found / error presentation below
/// [RecordDetailHeader] — everything `RecordDetailPage`'s `Scaffold` body
/// needs besides the header itself.
///
/// M5 scope boundary: renders ONLY the cash-expense branch (amount, date,
/// category badge, note, delete) — no items list, no receipt photo section.
/// Every record in History at this milestone is `source: cash`; the
/// receipt-detail branch is new code a later milestone adds once receipts
/// exist, never a commented-out stub here (`no_commented_code_rules.md`).
class RecordDetailBody extends StatelessWidget {
  final RecordDetailState state;

  const RecordDetailBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isFailed) {
      return ErrorMessageWidget(message: state.errorMessage);
    }

    if (state.isNotFound) {
      return const Center(child: RecordDetailNotFound());
    }

    final expense = state.snapshot?.expense;
    if (!state.isReady || expense == null) {
      return const LoadingDataWidget();
    }

    final lo = AppLocalizations.of(context);
    final viewData = RecordDetailViewData.resolve(
      expense: expense,
      categories: state.snapshot!.categories,
      stores: state.snapshot!.stores,
      lo: lo,
    );
    final note = viewData.note;

    return SingleChildScrollView(
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
              typeLabel: lo.cashType,
              categoryLabel: viewData.categoryLabel,
              categoryDotColor: viewData.categoryDotColor,
            ),
            if (note != null && note.trim().isNotEmpty)
              RecordDetailNoteCard(note: note),
            RecordDetailDeleteButton(recordId: expense.id),
          ],
        ),
      ),
    );
  }
}
