import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import 'widgets/privacy_body.dart';

/// `PrivacyPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. Reached from Settings → Privacy.
///
/// Per design_spendlens.md's "Conflicts resolved" table: unlike the
/// prototype (where this row is inert), it gets a real destination —
/// plain-markdown policy read from `assets/legal/privacy_policy.md`. There
/// is no remote-URL / webview infrastructure in this project
/// (`~/.claude/rules/privacy_policy_terms_rules.md`'s default template does
/// not apply here — no `AppConfig` privacy field exists), so the body is
/// read from the local asset instead.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.privacy)),
      body: const PrivacyBody(),
    );
  }
}
