import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `ReviewPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell, reached when the Scanner's `ParsedReceipt` is ready. Shows the
/// parsed items for correction before Save.
///
/// M4 minimal placeholder — the real item list (rawName/normalizedName,
/// low-confidence flags, reconciliation + duplicate-detector warnings) is
/// M8.
class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.reviewReceipt)),
    );
  }
}
