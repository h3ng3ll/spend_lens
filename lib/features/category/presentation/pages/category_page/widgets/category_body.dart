import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/create_new_row.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../domain/models/category/category.dart';
import '../../../../domain/models/category/category_display_x.dart';
import 'category_list_card.dart';
import 'category_search_field.dart';
import 'new_category_row.dart';

/// Filters [categories] by [query] against the DISPLAYED name (resolved
/// i18n label for built-ins, literal text for custom ones) — a pure
/// function, never a bloc state field (BLoC rule A3.1: no `filteredX`
/// anywhere in state).
List<Category> filterCategories(
  List<Category> categories,
  String query,
  AppLocalizations lo,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return categories;

  return categories
      .where((c) => c.displayName(lo).toLowerCase().contains(normalized))
      .toList();
}

/// Populated / empty presentation for `CategoryPage` (design_spendlens.md's
/// Categories artboard) — search field, quick-create row, the filtered
/// list, "+ New category", and the footer note.
class CategoryBody extends StatelessWidget {
  final List<Category> categories;
  final TextEditingController searchController;
  final VoidCallback onQuickCreate;
  final VoidCallback onOpenNewCategory;
  final ValueChanged<Category> onPick;
  final ValueChanged<Category> onRename;
  final ValueChanged<Category> onDelete;

  const CategoryBody({
    super.key,
    required this.categories,
    required this.searchController,
    required this.onQuickCreate,
    required this.onOpenNewCategory,
    required this.onPick,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final query = searchController.text;
    final filtered = filterCategories(categories, query, lo);
    final trimmedQuery = query.trim();
    final canCreate = trimmedQuery.isNotEmpty && filtered.isEmpty;

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            CategorySearchField(controller: searchController),
            if (canCreate)
              CreateNewRow(
                title: '${lo.create} "$trimmedQuery"',
                subtitle: lo.newCatHint,
                onTap: onQuickCreate,
              ),
            if (categories.isEmpty)
              Center(
                child: Text(
                  lo.categoryEmpty,
                  style: textTheme.body17.copyWith(color: scheme.sec),
                ),
              )
            else
              CategoryListCard(
                categories: filtered,
                onPick: onPick,
                onRename: onRename,
                onDelete: onDelete,
              ),
            NewCategoryRow(onTap: onOpenNewCategory),
            Text(
              lo.catNote,
              style: textTheme.footnote13.copyWith(color: scheme.ter, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
