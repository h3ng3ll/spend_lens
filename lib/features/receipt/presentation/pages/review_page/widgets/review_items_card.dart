import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../bloc/review_bloc/review_bloc.dart';
import 'review_item_edit_row.dart';
import 'review_item_row.dart';

/// The Review screen's items card — one widget per file (`developer.md`
/// A2). Renders each item as either its display row or its inline-edit row,
/// depending on [ReviewState.editingItemId].
class ReviewItemsCard extends StatelessWidget {
  final ReviewState state;
  final TextEditingController Function(String itemId, String initialText)
  controllerFor;
  final void Function(String itemId) onStartEditItem;
  final void Function(String itemId) onDoneEditingItem;

  const ReviewItemsCard({
    super.key,
    required this.state,
    required this.controllerFor,
    required this.onStartEditItem,
    required this.onDoneEditingItem,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              lo.items(state.items.length),
              style: textTheme.sectionLabel12.copyWith(color: scheme.ter),
            ),
          ),
          for (var i = 0; i < state.items.length; i++)
            state.editingItemId == state.items[i].id
                ? ReviewItemEditRow(
                    controller: controllerFor(
                      state.items[i].id,
                      state.items[i].name,
                    ),
                    hintLabel: lo.lowConf,
                    doneLabel: lo.done,
                    onDone: () => onDoneEditingItem(state.items[i].id),
                  )
                : ReviewItemRow(
                    name: state.items[i].name,
                    quantity: state.items[i].quantity,
                    unit: state.items[i].unit,
                    unitPrice: state.items[i].unitPrice,
                    lineTotal: state.items[i].lineTotal,
                    isLowConfidence: state.items[i].isLowConfidence,
                    isManuallyAdded: state.items[i].isManuallyAdded,
                    showBottomBorder: i < state.items.length - 1,
                    addedManuallyLabel: lo.addedManually,
                    onTap: () => onStartEditItem(state.items[i].id),
                  ),
        ],
      ),
    );
  }
}
