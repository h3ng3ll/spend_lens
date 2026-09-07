import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import 'scanner_spinner.dart';
import 'scanner_step_row.dart';

/// The bottom processing panel — "Reading text…" + the 4-step checklist
/// (`SpendLens.dc.html`'s "Scanner processing" artboard). [processingStep]
/// is the count of REAL pipeline stages that have completed
/// (design_spendlens.md §8), never a simulated percentage — each row is
/// rendered done / in-progress / pending purely from that integer.
///
/// This is a docked panel, not a `showModalBottomSheet` — it is mounted
/// only while `EScannerStatus.processing` (see `ScannerBody.build`), so its
/// `slUp` entrance is the natural consequence of being inserted into the
/// tree, not a controller this widget must own or dispose itself.
class ScannerProcessingSheet extends StatelessWidget {
  final int processingStep;

  const ScannerProcessingSheet({super.key, required this.processingStep});

  static const _stepCount = 4;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final stepLabels = [lo.steps0, lo.steps1, lo.steps2, lo.steps3];
    final currentTitle = processingStep < stepLabels.length
        ? stepLabels[processingStep]
        : stepLabels.last;

    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: AppContainer(
        color: scheme.sheet,
        border: Border(top: BorderSide(color: scheme.line2, width: 1.0)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.value.withValues(alpha: 0.4),
            blurRadius: 60.0,
            offset: const Offset(0.0, -20.0),
          ),
        ],
        padding: EdgeInsets.only(
          top: 24.0,
          bottom: 56.0 + bottomInset,
        ),
        child: HorizontalPadding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 22.0,
            children: [
              Center(
                child: AppContainer(
                  width: 36.0,
                  height: 5.0,
                  borderRadius: BorderRadius.circular(3.0),
                  color: scheme.dim,
                ),
              ),
              Row(
                spacing: 12.0,
                children: [
                  const ScannerSpinner(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTitle,
                          style: textTheme.headline17Semi.copyWith(
                            color: scheme.ink,
                          ),
                        ),
                        Text(
                          lo.onDevice(lo.thisDevice),
                          style: textTheme.footnote13.copyWith(
                            color: scheme.ter,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14.0,
                children: List.generate(_stepCount, (index) {
                  final label = stepLabels[index];
                  return ScannerStepRow(
                    label: label,
                    isDone: index < processingStep,
                    isCurrent: index == processingStep,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
