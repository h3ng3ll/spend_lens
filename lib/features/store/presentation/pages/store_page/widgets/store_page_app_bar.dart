import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import 'new_store_pill_button.dart';

/// The Stores list header — title + "+ New Store" pill
/// (design_spendlens.md's Stores artboard, `noStoreSel` branch). A custom
/// `PreferredSizeWidget` rather than `CustomAppBar` because the design's
/// header is a bespoke title-plus-pill row, not a centered-title bar.
class StorePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StorePageAppBar({super.key});

  void _onNewStore(BuildContext context) {
    NewStorePageRoute().push(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return SafeArea(
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lo.tabStores,
                style: textTheme.screenTitle28.copyWith(color: scheme.ink),
              ),
              NewStorePillButton(onTap: () => _onNewStore(context)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
