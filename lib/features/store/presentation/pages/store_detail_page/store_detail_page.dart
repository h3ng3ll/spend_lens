import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `StoreDetailPageRoute` (design_spendlens.md §5) — a TOP-LEVEL push above
/// the shell (`parentNavigatorKey: rootNavigatorKey`), never a branch-2
/// child, because the design hides the bottom pill once a store is
/// selected. That hiding is structural: the pill is built only inside the
/// shell's `builder` (see `root_page.dart`), and a root-navigator push sits
/// above the whole shell widget, so it is absent here by construction.
///
/// M4 minimal placeholder — the visits/spend/products stats and the
/// cross-store price-comparison rows (design_spendlens.md §"Conflicts
/// resolved" → Price history) are M5/M6.
class StoreDetailPage extends StatelessWidget {
  final String storeId;

  const StoreDetailPage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: const CustomAppBar(),
      body: Center(
        child: Text(
          storeId,
          style: textTheme.body17.copyWith(color: scheme.ink),
        ),
      ),
    );
  }
}
