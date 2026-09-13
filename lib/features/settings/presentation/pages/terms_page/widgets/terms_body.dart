import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Renders `assets/legal/terms_of_use.md` literally, as a scrollable `Text` —
/// the same treatment [PrivacyBody] gives the privacy policy, for the same
/// reason: "plain markdown" names the SOURCE format, and there is no
/// markdown-renderer dependency in this project to parse it with.
///
/// The asset is the authoritative text. Nothing here rewrites, filters, or
/// localizes the body — per `privacy_policy_terms_rules.md` §6.3, code shows
/// legal text, it never authors it.
class TermsBody extends StatelessWidget {
  const TermsBody({super.key});

  static const String _assetPath = 'assets/legal/terms_of_use.md';

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
