import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `AboutPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. Reached from Settings → About; also hosts the "Delete all
/// records" destructive control (`delete_all_records_rules.md`) and "Reset
/// catalog to samples" per this project's data-reset story.
///
/// M4 minimal placeholder — the version row, delete-all confirm-sheet flow
/// and reset-to-seed action are M5/M10 (copy source noted in `PrivacyPage`'s
/// doc comment applies here too).
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.about)),
    );
  }
}
