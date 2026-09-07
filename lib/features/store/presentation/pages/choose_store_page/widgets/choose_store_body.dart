import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/create_new_row.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../domain/models/store/store.dart';
import 'create_new_store_row.dart';
import 'store_pick_row.dart';
import 'store_search_field.dart';

/// Filters [stores] by [query] against the store name — a pure function,
/// never a bloc state field (BLoC rule A3.1: no `filteredX` anywhere in
/// state).
List<Store> filterStores(List<Store> stores, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return stores;

  return stores
      .where((s) => s.name.toLowerCase().contains(normalized))
      .toList();
}

/// Populated / empty presentation for `ChooseStorePage`
/// (design_spendlens.md's Choose-store artboard) — search field,
/// quick-create row, the filtered list (or "no matching store" copy), and
/// the pinned "Create new store" row. The search field and create-new
/// affordance stay visible even when [stores] is completely empty, so the
/// create path is always reachable.
class ChooseStoreBody extends StatelessWidget {
  final List<Store> stores;
  final String? selectedStoreId;
  final TextEditingController searchController;
  final VoidCallback onQuickCreate;
  final VoidCallback onOpenNewStore;
  final ValueChanged<Store> onPick;

  const ChooseStoreBody({
    super.key,
    required this.stores,
    required this.selectedStoreId,
    required this.searchController,
    required this.onQuickCreate,
    required this.onOpenNewStore,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final query = searchController.text;
    final filtered = filterStores(stores, query);
    final trimmedQuery = query.trim();
    final canCreate = trimmedQuery.isNotEmpty && filtered.isEmpty;

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            StoreSearchField(controller: searchController),
            if (canCreate)
              CreateNewRow(
                title: '${lo.create} "$trimmedQuery"',
                subtitle: lo.newStoreHint,
                onTap: onQuickCreate,
              ),
            if (filtered.isNotEmpty)
              AppSectionCard(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final store in filtered)
                      StorePickRow(
                        store: store,
                        isSelected: store.id == selectedStoreId,
                        onTap: () => onPick(store),
                      ),
                  ],
                ),
              )
            else
              Center(
                child: Text(
                  lo.noMatch,
                  style: textTheme.subhead15.copyWith(color: scheme.ter),
                ),
              ),
            CreateNewStoreRow(onTap: onOpenNewStore),
          ],
        ),
      ),
    );
  }
}
