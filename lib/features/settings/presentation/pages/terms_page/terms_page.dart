import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import 'widgets/terms_body.dart';

/// `TermsPageRoute` — a top-level push above the shell, reached from
/// Settings → Terms of Use. The counterpart to [PrivacyPage], and built to
/// the same shape so the two legal surfaces behave identically.
///
/// **Deviation from `~/.claude/rules/privacy_policy_terms_rules.md`, recorded
/// deliberately.** That contract renders both legal screens by loading an
/// `AppConfig` URL into an in-app webview, with the URLs populated by
/// `scripts/set_info_plist.sh --sync` from Jira. NONE of that infrastructure
/// exists in this project: there is no `AppConfig` class, no
/// `flutter_inappwebview` dependency, and no `scripts/` directory. [PrivacyPage]
/// already records the same deviation and reads a local asset instead; this
/// screen follows it rather than introducing a webview stack for one page.
///
/// The contract's HARD requirements are still met: both screens exist, both
/// stay reachable, neither is gated or no-oped, and the only local string is
/// the title heading — the body text comes from the asset, never from code.
///
/// The contract's `if (Platform.isIOS)` gate on Terms is also not applied.
/// That gate exists solely because `termsOfUseAndroidUrl` does not exist as a
/// config field, so Android had no URL to load. With a local asset there is no
/// missing input, and hiding Terms on Android would leave those users unable
/// to read terms they are bound by.
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.termsOfUse)),
      body: const TermsBody(),
    );
  }
}
