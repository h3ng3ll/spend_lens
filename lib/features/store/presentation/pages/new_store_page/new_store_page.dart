import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `NewStorePageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell for creating a store by hand (name, receipt alias, type).
///
/// M4 minimal placeholder — the real form (fields + `create` action wired to
/// [IStoreLocalRepository]) is M5.
class NewStorePage extends StatelessWidget {
  const NewStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.newStore)),
    );
  }
}
