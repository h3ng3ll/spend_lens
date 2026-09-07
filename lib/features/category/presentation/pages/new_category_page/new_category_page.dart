import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `NewCategoryPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for creating a custom category.
///
/// M4 minimal placeholder — the real form (name + color swatch, wired to
/// [ICategoryLocalRepository]) is M5.
class NewCategoryPage extends StatelessWidget {
  const NewCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.newCategory)),
    );
  }
}
