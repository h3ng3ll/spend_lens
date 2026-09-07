import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Renders `assets/legal/privacy_policy.md` literally, as a scrollable
/// `Text` — "plain markdown" here names the SOURCE format, not that it must
/// be parsed/styled (design_spendlens.md's "Conflicts resolved" table: this
/// row gets a real destination, unlike the inert prototype row). There is
/// no markdown-renderer dependency in this project, so this shows the raw
/// file content honestly rather than adding one for a single screen.
class PrivacyBody extends StatelessWidget {
  const PrivacyBody({super.key});

  static const String _assetPath = 'assets/legal/privacy_policy.md';

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return FutureBuilder<String>(
      future: rootBundle.loadString(_assetPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingDataWidget();
        }

        return SingleChildScrollView(
          child: HorizontalPadding(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                snapshot.data!,
                style: textTheme.subhead15.copyWith(
                  color: scheme.ink,
                  height: 1.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
