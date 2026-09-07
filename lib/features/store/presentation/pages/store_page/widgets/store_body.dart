import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../../core/resources/app_icons.dart';
import '../../../../domain/models/store_page_snapshot/store_page_snapshot.dart';
import 'store_list_card.dart';

/// Populated / empty presentation for `StorePage`
/// (design_spendlens.md's Stores artboard, `noStoreSel` branch).
class StoreBody extends StatelessWidget {
  final StorePageSnapshot? snapshot;

  const StoreBody({super.key, this.snapshot});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    final stores = snapshot?.stores ?? const [];
    final expenses = snapshot?.expenses ?? const [];

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Text(
              lo.storesIntro,
              style: textTheme.footnote13.copyWith(color: scheme.ter),
            ),
            if (stores.isEmpty)
              AppEmptyState(
                icon: AppIcons.store,
                title: lo.storesEmptyTitle,
                body: lo.storesEmptyBody,
              )
            else
              StoreListCard(stores: stores, expenses: expenses),
          ],
        ),
      ),
    );
  }
}
