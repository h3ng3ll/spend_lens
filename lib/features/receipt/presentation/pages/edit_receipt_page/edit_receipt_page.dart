import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../bloc/edit_receipt_bloc/edit_receipt_bloc.dart';
import 'widgets/edit_item_row.dart';

/// `EditReceiptPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for correcting an already-saved receipt (store/date/items/
/// totals), reached from Review's "Correct" action or from the scan-failed
/// sheet's "Enter Manually" action (which first creates a blank [Receipt]
/// so this screen always has an id to load).
///
/// [EditReceiptBloc] is screen-scoped (`registerFactory` semantics — built
/// here in `initState`, closed in `dispose` — BLoC rule A3.8). `load` is a
/// deliberate ONE-SHOT read (hive_rules.md §6's form-bloc exemption) — this
/// is a form seeded once, not a live display.
class EditReceiptPage extends StatefulWidget {
  final String receiptId;

  const EditReceiptPage({super.key, required this.receiptId});

  @override
  State<EditReceiptPage> createState() => _EditReceiptPageState();
}

class _EditReceiptPageState extends State<EditReceiptPage> {
  late final EditReceiptBloc _bloc = EditReceiptBloc(
    receiptRepository: getIt<IReceiptLocalRepository>(),
    receiptItemRepository: getIt<IReceiptItemLocalRepository>(),
    productRepository: getIt<IProductLocalRepository>(),
    storeRepository: getIt<IStoreLocalRepository>(),
  )..add(EditReceiptEvent.load(widget.receiptId));

  final Map<String, TextEditingController> _nameControllers = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, TextEditingController> _priceControllers = {};
  late final TextEditingController _printedTotalController;

  @override
  void initState() {
    super.initState();
    _printedTotalController = TextEditingController();
  }

  @override
  void dispose() {
    for (final controller in _nameControllers.values) {
      controller.dispose();
    }
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (final controller in _priceControllers.values) {
      controller.dispose();
    }
    _printedTotalController.dispose();
    _bloc.close();
    super.dispose();
  }

  TextEditingController _controller(
    Map<String, TextEditingController> pool,
    String itemId,
    String initialText,
  ) {
    final existing = pool[itemId];
    if (existing != null) return existing;
    final created = TextEditingController(text: initialText);
    pool[itemId] = created;
    return created;
  }

  void _onCancel() => context.pop();

  void _onDone() {
    _bloc.add(const EditReceiptEvent.save());
  }

  Future<void> _onPickStore(BuildContext context) async {
    final pickedId = await ChooseStorePageRoute().push<String>(context);
    if (pickedId == null || !context.mounted) return;
    _bloc.add(EditReceiptEvent.pickStore(pickedId));
  }

  void _onRemoveItem(String itemId) {
    _nameControllers.remove(itemId)?.dispose();
    _quantityControllers.remove(itemId)?.dispose();
    _priceControllers.remove(itemId)?.dispose();
    _bloc.add(EditReceiptEvent.removeItem(itemId));
  }

  void _onAddItem() => _bloc.add(const EditReceiptEvent.addItem());

  void _onPrintedTotalChanged(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    _bloc.add(EditReceiptEvent.setPrintedTotal(parsed));
  }

  /// Seeds [_printedTotalController] EXACTLY ONCE, the first time the bloc
  /// reaches `ready` — via a `BlocListener`, never from `build()` or a
  /// deferred `addPostFrameCallback`
  /// (`form-selector-state-reseeded-in-build-or-wrong-initial-value`: the
  /// recorded defect is a seed that RE-QUEUES on every rebuild because its
  /// one-shot flag is flipped only inside the deferred callback; a
  /// `listenWhen` firing once on a status transition has no such
  /// re-entrancy — later rebuilds while `ready` never re-trigger it).
  void _onReadyForTheFirstTime(EditReceiptState state) {
    _printedTotalController.text = state.printedTotal?.toStringAsFixed(2) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditReceiptBloc>.value(
      value: _bloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditReceiptBloc, EditReceiptState>(
            listenWhen: (previous, current) =>
                !previous.isSaved && current.isSaved,
            listener: (context, state) => context.pop(),
          ),
          BlocListener<EditReceiptBloc, EditReceiptState>(
            listenWhen: (previous, current) =>
                !previous.isReady && current.isReady,
            listener: (context, state) => _onReadyForTheFirstTime(state),
          ),
          // A save that fails was previously silent — this is the same
          // class of defect fixed on Review (`isFailed` reachable but
          // nothing read it).
          BlocListener<EditReceiptBloc, EditReceiptState>(
            listenWhen: (previous, current) =>
                !previous.isFailed && current.isFailed,
            listener: (context, state) => UiMessageService.showError(
              AppLocalizations.of(context).tSaveFailedGeneric,
            ),
          ),
        ],
        child: _EditReceiptScaffold(
          nameControllerFor: (id, text) =>
              _controller(_nameControllers, id, text),
          quantityControllerFor: (id, text) =>
              _controller(_quantityControllers, id, text),
          priceControllerFor: (id, text) =>
              _controller(_priceControllers, id, text),
          printedTotalController: _printedTotalController,
          onCancel: _onCancel,
          onDone: _onDone,
          onPickStore: () => _onPickStore(context),
          onRemoveItem: _onRemoveItem,
          onAddItem: _onAddItem,
          onItemNameChanged: (id, value) =>
              _bloc.add(EditReceiptEvent.updateItemName(id, value)),
          onItemQuantityChanged: (id, value) {
            final parsed = double.tryParse(value.replaceAll(',', '.'));
            if (parsed != null) {
              _bloc.add(EditReceiptEvent.updateItemQuantity(id, parsed));
            }
          },
          onItemPriceChanged: (id, value) {
            final parsed = double.tryParse(value.replaceAll(',', '.'));
            if (parsed != null) {
              _bloc.add(EditReceiptEvent.updateItemPrice(id, parsed));
            }
          },
          onPrintedTotalChanged: _onPrintedTotalChanged,
        ),
      ),
    );
  }
}

class _EditReceiptScaffold extends StatelessWidget {
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
  final void Function(String itemId, String value) onItemPriceChanged;
  final ValueChanged<String> onPrintedTotalChanged;

  const _EditReceiptScaffold({
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
                              qtyLabel: lo.qty,
                              priceLabel: lo.price,
                              rawLine: item.rawName,
                              onRemove: () => onRemoveItem(item.id),
                              onNameChanged: (value) =>
                                  onItemNameChanged(item.id, value),
                              onQuantityChanged: (value) =>
                                  onItemQuantityChanged(item.id, value),
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
