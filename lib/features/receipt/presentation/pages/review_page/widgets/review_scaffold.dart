import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../../category/domain/models/category/category_display_x.dart';
import '../../../../../category/presentation/bloc/categories_bloc/categories_bloc.dart';
import '../../../bloc/review_bloc/review_bloc.dart';
import 'correct_button.dart';
import 'review_category_card.dart';
import 'review_header.dart';
import 'review_items_card.dart';
import 'review_store_card.dart';
import 'review_totals_card.dart';
import 'review_failed_state.dart';

/// The Review screen's scaffold — one widget per file (`developer.md` A2).
/// Reads [ReviewBloc] and [CategoriesBloc] state only; every mutation is
/// dispatched by [ReviewPage] and passed down as a callback, so this widget
/// never touches either bloc directly.
class ReviewScaffold extends StatelessWidget {
  final TextEditingController Function(String itemId, String initialText)
  controllerFor;
  final VoidCallback onBack;
  final VoidCallback onRetake;
  final void Function(String itemId) onStartEditItem;
  final void Function(String itemId) onDoneEditingItem;
  final VoidCallback onPickCategory;
  final VoidCallback onSave;
  final VoidCallback onCorrect;

  const ReviewScaffold({
    super.key,
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

    // A non-ready state is NEVER an empty screen. This used to return
    // `SizedBox.shrink()` for every status that was not ready/saved, which
    // made a failed load (an unusable parse, a cleared draft) render a
    // literally blank page with no spinner, no message and no way out —
    // and because the scanner reaches this route with `.go()`, the stack was
    // replaced, so there was nothing left to pop back to either. The user
    // was stranded on black.
    if (state.isFailed) {
      return Scaffold(
        backgroundColor: scheme.bg,
        body: ReviewFailedState(onRetake: onRetake),
      );
    }

    if (!state.hasContent) {
      return Scaffold(
        backgroundColor: scheme.bg,
        body: const Center(child: CircularProgressIndicator()),
      );
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
                    ReviewItemsCard(
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
                        (state.reconciliationDifference ?? 0.0).toStringAsFixed(
                          2,
                        ),
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
                    child: CorrectButton(label: lo.correct, onTap: onCorrect),
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
