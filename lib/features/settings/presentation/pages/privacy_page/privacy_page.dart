import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `PrivacyPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. Reached from Settings → Privacy.
///
/// Per design_spendlens.md's "Conflicts resolved" table: unlike the
/// prototype (where this row is inert), it gets a real destination —
/// plain-markdown policy read from `assets/`. M4 minimal placeholder: the
/// actual copy is listed under design_spendlens.md §12 ("Needs to come from
/// the user … Privacy + About copy | M10 | design shows the rows, not the
/// text"), so it is NOT invented here.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.privacy)),
    );
  }
}
