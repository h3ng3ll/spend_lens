import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../bloc/scanner_bloc/scanner_bloc.dart';

/// The scanner's four sub-states as one body (design_spendlens.md §5). M4
/// minimal placeholder — the camera preview, detection outline animation
/// and step-tick labels (spec §8: real events, never the prototype's fixed
/// timer chain) are M7/M8.
class ScannerBody extends StatelessWidget {
  final ScannerState state;

  const ScannerBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final label = switch (state.status) {
      EScannerStatus.searching => lo.looking,
      EScannerStatus.detected => lo.receiptDetected,
      EScannerStatus.capturing => lo.capturing,
      EScannerStatus.processing => lo.steps0,
      EScannerStatus.failed => lo.blurry,
    };

    return Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: textTheme.body17.copyWith(color: scheme.ink),
      ),
    );
  }
}
