import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../category/domain/models/category/category.dart';
import '../../../../category/domain/models/category/category_display_x.dart';
import '../../../../category/presentation/bloc/categories_bloc/categories_bloc.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../scanner/domain/pending_receipt_draft_store.dart';
import '../../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../bloc/review_bloc/review_bloc.dart';
import 'widgets/review_category_card.dart';
import 'widgets/review_header.dart';
import 'widgets/review_item_edit_row.dart';
import 'widgets/review_item_row.dart';
import 'widgets/review_store_card.dart';
import 'widgets/review_totals_card.dart';

/// `ReviewPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell, reached when the Scanner's `ParsedReceipt` is ready.
///
/// `ReviewBloc` is screen-scoped (`registerFactory` semantics: built here in
/// `initState`, closed in `dispose` — BLoC rule A3.8), loading its data from
/// `PendingReceiptDraftStore` rather than a router `extra` payload (see that
/// store's own doc comment for why).
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late final ReviewBloc _reviewBloc = ReviewBloc(
    draftStore: getIt<PendingReceiptDraftStore>(),
    receiptRepository: getIt<IReceiptLocalRepository>(),
    receiptItemRepository: getIt<IReceiptItemLocalRepository>(),
    productRepository: getIt<IProductLocalRepository>(),
  )..add(const ReviewEvent.load());

  final Map<String, TextEditingController> _editControllers = {};

  @override
  void dispose() {
    for (final controller in _editControllers.values) {
      controller.dispose();
    }
    _reviewBloc.close();
    super.dispose();
  }

  TextEditingController _controllerFor(String itemId, String initialText) {
    final existing = _editControllers[itemId];
    if (existing != null) return existing;
    final created = TextEditingController(text: initialText);
    _editControllers[itemId] = created;
    return created;
  }

  void _onBack() => context.pop();

  void _onRetake() {
    getIt<PendingReceiptDraftStore>().clear();
    context.pop();
  }

  void _onStartEditItem(String itemId) =>
      _reviewBloc.add(ReviewEvent.startEditItem(itemId));

  void _onDoneEditingItem(String itemId) {
    final controller = _editControllers[itemId];
    if (controller != null) {
      _reviewBloc.add(ReviewEvent.commitEditedName(controller.text));
    }
    _reviewBloc.add(const ReviewEvent.stopEditItem());
  }

  Future<void> _onPickCategory(BuildContext context) async {
    final pickedId = await CategoriesPageRoute().push<String>(context);
    if (pickedId == null || !context.mounted) return;
    _reviewBloc.add(ReviewEvent.setCategory(pickedId));
  }

  void _onSave(BuildContext context) {
    final lo = AppLocalizations.of(context);
    _reviewBloc.add(const ReviewEvent.save());
    UiMessageService.showSuccess(lo.tSaved(lo.reviewReceipt));
  }

  void _onCorrect() => _reviewBloc.add(const ReviewEvent.saveAndCorrect());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewBloc>.value(
      value: _reviewBloc,
      child: MultiBlocListener(
        listeners: [
          // Two DISTINCT terminal statuses, two DISTINCT navigations — a
          // shared `saved` status here would fire the wrong route for one
          // of the two exit paths (see `ReviewState`'s doc comment).
          BlocListener<ReviewBloc, ReviewState>(
            listenWhen: (previous, current) =>
                !previous.isSaved && current.isSaved,
            listener: (context, state) => HomePageRoute().go(context),
          ),
          BlocListener<ReviewBloc, ReviewState>(
            listenWhen: (previous, current) =>
                !previous.isSavedThenCorrect && current.isSavedThenCorrect,
            listener: (context, state) {
              final receiptId = state.savedReceiptId;
              if (receiptId == null) return;
              EditReceiptPageRoute(receiptId: receiptId).go(context);
            },
          ),
        ],
        child: _ReviewScaffold(
          controllerFor: _controllerFor,
          onBack: _onBack,
          onRetake: _onRetake,
          onStartEditItem: _onStartEditItem,
          onDoneEditingItem: _onDoneEditingItem,
          onPickCategory: () => _onPickCategory(context),
          onSave: () => _onSave(context),
          onCorrect: _onCorrect,
        ),
      ),
    );
  }
}

class _ReviewScaffold extends StatelessWidget {
  final TextEditingController Function(String itemId, String initialText)
  controllerFor;
  final VoidCallback onBack;
  final VoidCallback onRetake;
  final void Function(String itemId) onStartEditItem;
  final void Function(String itemId) onDoneEditingItem;
  final VoidCallback onPickCategory;
  final VoidCallback onSave;
  final VoidCallback onCorrect;

  const _ReviewScaffold({
    required this.controllerFor,
    required this.onBack,
    required this.onRetake,
    required this.onStartEditItem,
    required this.onDoneEditingItem,
    required this.onPickCategory,
    required this.onSave,
    required this.onCorrect,
  });

  Category? _findCategory(List<Category> categories, String? categoryId) {
    if (categoryId == null) return null;
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);
    final state = context.watch<ReviewBloc>().state;
    final categories = context.watch<CategoriesBloc>().state.categories;

    if (!state.isReady && !state.isSaved) {
      return Scaffold(backgroundColor: scheme.bg, body: const SizedBox.shrink());
    }

    final category = _findCategory(categories, state.categoryId);
    final itemsTotal = state.itemsTotal;
    final total = state.printedTotal ?? itemsTotal;
    const discount = 0.0;
    final subtotal = itemsTotal;

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
                    ReviewHeader(
                      title: lo.reviewReceipt,
                      retakeLabel: lo.retake,
                      onBack: onBack,
                      onRetake: onRetake,
                    ),
                    ReviewStoreCard(
                      storeName: state.storeName ?? lo.catOther,
                      dateTimeLabel: DateFormat.yMMMd().add_jm().format(
                        state.purchasedAt ?? DateTime.now(),
                      ),
                      autoDetectedLabel: lo.autoDetected,
                    ),
                    _ReviewItemsCard(
                      state: state,
                      controllerFor: controllerFor,
                      onStartEditItem: onStartEditItem,
                      onDoneEditingItem: onDoneEditingItem,
                    ),
                    ReviewTotalsCard(
                      subtotalLabel: lo.subtotal,
                      subtotal: subtotal,
                      discountLabel: lo.discount,
                      discount: discount,
                      totalLabel: lo.total,
                      total: total,
                      currencyCode: 'MDL',
                      isReconciled: state.isReconciled,
                      matchLabel: lo.itemsMatch,
                      mismatchLabel: lo.itemsDiffer(
                        (state.reconciliationDifference ?? 0.0)
                            .toStringAsFixed(2),
                      ),
                    ),
                    ReviewCategoryCard(
                      sectionLabel: lo.category,
                      dotColor: category == null
                          ? null
                          : AppColorScheme.categoryColor(category.id),
                      categoryLabel: category?.displayName(lo) ?? lo.category,
                      changeLabel: lo.change,
                      onTap: onPickCategory,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 44.0,
              child: Row(
                spacing: 12.0,
                children: [
                  SizedBox(
                    width: 120.0,
                    child: _CorrectButton(label: lo.correct, onTap: onCorrect),
                  ),
                  Expanded(
                    child: GradientCtaButton(
                      label: lo.saveReceipt,
                      enabled: true,
                      onTap: onSave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CorrectButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
        // textScaleFactor — this button carries the "Correct" label text,
        // so MIN-HEIGHT only.
        constraints: const BoxConstraints(minHeight: 56.0),
        child: AppContainer(
          color: scheme.field,
          border: Border.all(color: scheme.field2),
          borderRadius: BorderRadius.circular(16.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.headline17.copyWith(
              color: scheme.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewItemsCard extends StatelessWidget {
  final ReviewState state;
  final TextEditingController Function(String itemId, String initialText)
  controllerFor;
  final void Function(String itemId) onStartEditItem;
  final void Function(String itemId) onDoneEditingItem;

  const _ReviewItemsCard({
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
