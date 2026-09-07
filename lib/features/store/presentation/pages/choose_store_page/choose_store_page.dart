import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `ChooseStorePageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for picking (or creating) the store attached to a receipt/
/// expense being edited.
///
/// M4 minimal placeholder — the search-or-create list wired to
/// [IStoreLocalRepository] is M5.
class ChooseStorePage extends StatelessWidget {
  const ChooseStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.chooseStore)),
    );
  }
}
