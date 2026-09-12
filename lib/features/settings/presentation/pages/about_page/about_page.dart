import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import 'widgets/about_body.dart';

/// `AboutPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. Reached from Settings → About.
///
/// Per project rules, the app NAME is never rendered anywhere on screen —
/// this page shows only the version number (via `package_info_plus`,
/// already a project dependency) and a generic, honest description.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.about)),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingDataWidget();
          }

          return AboutBody(
            versionLabel:
                '${snapshot.data!.version} ${snapshot.data!.buildNumber}',
          );
        },
      ),
    );
  }
}
