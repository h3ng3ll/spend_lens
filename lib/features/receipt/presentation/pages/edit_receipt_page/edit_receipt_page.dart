import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../bloc/edit_receipt_bloc/edit_receipt_bloc.dart';
import 'widgets/edit_receipt_scaffold.dart';

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
        child: EditReceiptScaffold(
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
