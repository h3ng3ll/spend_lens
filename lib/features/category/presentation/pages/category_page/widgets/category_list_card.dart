import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../domain/models/category/category.dart';
import 'category_row.dart';

/// The card wrapping the (filtered) category list (design_spendlens.md's
/// Categories artboard) — layout only (A6): receives the already-filtered
/// list and the three row callbacks, and lets [CategoryRow] render each one.
///
/// Deliberately shows the simpler `catDefault`/`catCustom` meta line rather
/// than a per-category usage COUNT (`catUsed`) — computing "is this category
/// used" needs a one-shot `IExpenseLocalRepository.getAll()` scan that this
/// screen would otherwise have to keep live-reactive to stay honest per
/// hive_rules.md §6; the Developer's own documented call is that the
/// honest-but-plain fallback (built-in vs. custom) is preferable to a count
/// that can go stale while this screen is open.
class CategoryListCard extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category> onPick;
  final ValueChanged<Category> onRename;
  final ValueChanged<Category> onDelete;

  const CategoryListCard({
    super.key,
    required this.categories,
    required this.onPick,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final category in categories)
            CategoryRow(
              category: category,
              meta: category.isBuiltIn ? lo.catDefault : lo.catCustom,
              isCustom: !category.isBuiltIn,
              isDeletable: !category.isBuiltIn,
              onPick: () => onPick(category),
              onRename: () => onRename(category),
              onDelete: () => onDelete(category),
            ),
        ],
      ),
    );
  }
}
