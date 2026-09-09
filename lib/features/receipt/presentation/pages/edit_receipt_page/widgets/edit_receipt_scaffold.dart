import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../product/domain/models/product/e_unit.dart';
import '../../../bloc/edit_receipt_bloc/edit_receipt_bloc.dart';
import 'edit_item_row.dart';

/// The Edit Receipt screen's scaffold — one widget per file
/// (`developer.md` A2). Reads [EditReceiptBloc] state only; every mutation
/// is dispatched by [EditReceiptPage] and passed down as a callback, so this
/// widget never touches the bloc directly.
class EditReceiptScaffold extends StatelessWidget {
  final TextEditingController Function(String itemId, String initialText)
  nameControllerFor;
  final TextEditingController Function(String itemId, String initialText)
  quantityControllerFor;
  final TextEditingController Function(String itemId, String initialText)
  priceControllerFor;
  final TextEditingController printedTotalController;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final VoidCallback onPickStore;
  final void Function(String itemId) onRemoveItem;
  final VoidCallback onAddItem;
  final void Function(String itemId, String value) onItemNameChanged;
  final void Function(String itemId, String value) onItemQuantityChanged;
  final void Function(String itemId) onCycleItemUnit;
  final void Function(String itemId, String value) onItemPriceChanged;
  final ValueChanged<String> onPrintedTotalChanged;

  const EditReceiptScaffold({
    super.key,
    required this.nameControllerFor,
    required this.quantityControllerFor,
    required this.priceControllerFor,
    required this.printedTotalController,
    required this.onCancel,
    required this.onDone,
    required this.onPickStore,
    required this.onRemoveItem,
    required this.onAddItem,
    required this.onItemNameChanged,
    required this.onItemQuantityChanged,
    required this.onCycleItemUnit,
    required this.onItemPriceChanged,
    required this.onPrintedTotalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final state = context.watch<EditReceiptBloc>().state;

    // The printed-total controller is seeded EXACTLY ONCE by a
    // `BlocListener` in `EditReceiptPage.build()` (never here, never
    // deferred) — this widget only ever READS `state`/`printedTotalController`.

    if (!state.isReady && !state.isSaved) {
      return Scaffold(
        backgroundColor: scheme.bg,
        body: const SizedBox.shrink(),
      );
    }

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 24.0, bottom: 130.0),
              child: HorizontalPadding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16.0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: onCancel,
                          child: ConstrainedBox(
                            // ⛔ sig:developer-derived-fixed-dp-cell-
                            // height-ignores-textScaleFactor — carries the
                            // "Cancel" label, so MIN-WIDTH/MIN-HEIGHT only.
                            constraints: const BoxConstraints(
                              minWidth: 64.0,
                              minHeight: 40.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                lo.cancel,
                                style: textTheme.subhead15.copyWith(
                                  color: scheme.sec,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          lo.correctReceipt,
                          style: textTheme.headline17Semi.copyWith(
                            color: scheme.ink,
                          ),
                        ),
                        GestureDetector(
                          onTap: onDone,
                          child: ConstrainedBox(
                            // ⛔ sig:developer-derived-fixed-dp-cell-
                            // height-ignores-textScaleFactor — carries the
                            // "Done" label, so MIN-WIDTH/MIN-HEIGHT only.
                            constraints: const BoxConstraints(
                              minWidth: 64.0,
                              minHeight: 40.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                lo.done,
                                style: textTheme.subhead15.copyWith(
                                  color: scheme.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      lo.editIntro,
                      style: textTheme.footnote13.copyWith(color: scheme.ter),
                    ),
                    AppContainer(
                      color: scheme.card,
                      border: Border.all(color: scheme.line, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.0,
                        children: [
                          Text(
                            lo.store,
                            style: textTheme.subhead15.copyWith(
                              color: scheme.sec,
                            ),
                          ),
                          GestureDetector(
                            onTap: onPickStore,
                            child: ConstrainedBox(
                              // ⛔ sig:developer-derived-fixed-dp-cell-
                              // height-ignores-textScaleFactor — carries
                              // the store name / "Change" text, so
                              // MIN-HEIGHT only.
                              constraints: const BoxConstraints(
                                minHeight: 48.0,
                              ),
                              child: AppContainer(
                                color: scheme.field,
                                borderRadius: BorderRadius.circular(14.0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.storeName.isEmpty
                                            ? lo.store
                                            : state.storeName,
                                        style: textTheme.body17.copyWith(
                                          color: scheme.ink,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      lo.change,
                                      style: textTheme.subhead15.copyWith(
                                        color: scheme.accent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppContainer(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lo.itemsLabel,
                                  style: textTheme.sectionLabel12.copyWith(
                                    color: scheme.ter,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onAddItem,
                                  child: Text(
                                    lo.addItem,
                                    style: textTheme.subhead15.copyWith(
                                      color: scheme.accent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (final item in state.items)
                            EditItemRow(
                              nameController: nameControllerFor(
                                item.id,
                                item.name,
                              ),
                              quantityController: quantityControllerFor(
                                item.id,
                                item.quantity.toStringAsFixed(2),
                              ),
                              priceController: priceControllerFor(
                                item.id,
                                item.lineTotal.toStringAsFixed(2),
                              ),
                              // A weighed item's quantity IS its weight, so
                              // the field must say so — labelling `0.488 kg`
                              // as "Qty" reads as 0.488 pieces.
                              qtyLabel: switch (item.unit) {
                                EUnit.kilogram => lo.qtyKg,
                                EUnit.liter => lo.qtyL,
                                EUnit.piece => lo.qty,
                              },
                              priceLabel: lo.price,
                              rawLine: item.rawName,
                              onRemove: () => onRemoveItem(item.id),
                              onNameChanged: (value) =>
                                  onItemNameChanged(item.id, value),
                              onQuantityChanged: (value) =>
                                  onItemQuantityChanged(item.id, value),
                              onCycleUnit: () => onCycleItemUnit(item.id),
                              onPriceChanged: (value) =>
                                  onItemPriceChanged(item.id, value),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lo.itemsTotal,
                                  style: textTheme.subhead15.copyWith(
                                    color: scheme.sec,
                                  ),
                                ),
                                Text(
                                  '${state.itemsTotal.toStringAsFixed(2)} MDL',
                                  style: textTheme.statValue20.copyWith(
                                    color: scheme.ink,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppContainer(
                      color: scheme.card,
                      border: Border.all(color: scheme.line, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6.0,
                        children: [
                          Text(
                            lo.printedTotal,
                            style: textTheme.subhead15.copyWith(
                              color: scheme.sec,
                            ),
                          ),
                          ConstrainedBox(
                            // ⛔ sig:developer-derived-fixed-dp-cell-
                            // height-ignores-textScaleFactor — this box
                            // hosts an editable text field, so MIN-HEIGHT
                            // only.
                            constraints: const BoxConstraints(minHeight: 56.0),
                            child: AppContainer(
                              color: scheme.field,
                              borderRadius: BorderRadius.circular(14.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: printedTotalController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      style: textTheme.screenTitle28.copyWith(
                                        color: scheme.ink,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onChanged: onPrintedTotalChanged,
                                    ),
                                  ),
                                  Text(
                                    'MDL',
                                    style: textTheme.subhead15.copyWith(
                                      color: scheme.sec,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 44.0,
              child: GradientCtaButton(
                label: lo.applyCorrections,
                enabled: true,
                onTap: onDone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
