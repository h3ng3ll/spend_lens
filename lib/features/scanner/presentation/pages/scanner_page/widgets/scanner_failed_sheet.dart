import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// The v1 scan-failed sheet (design_spendlens.md §8/§66,
/// `SpendLens.dc.html`'s "Error state · scan failed" card): three tips,
/// **Try Again** and **Enter Manually** — never a dead end.
///
/// This is a DOCKED panel mounted only while `EScannerStatus.failed` (same
/// shape as [ScannerProcessingSheet] for `processing`) rather than a
/// `showModalBottomSheet`, so it never needs `isScrollControlled`/height-cap
/// handling of its own — it is sized by its own content inside the fixed
/// scanner viewport, which is always tall enough for three short tip lines
/// and two 44dp buttons.
///
/// The captured image is NEVER discarded when this sheet shows (spec
/// §66/§8) — [PendingReceiptDraftStore] already retained it before this
/// state was reached (see `CameraPreviewLayer._runProcessingPipeline`), and
/// [onEnterManually] carries it forward rather than dropping it.
class ScannerFailedSheet extends StatelessWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onEnterManually;

  const ScannerFailedSheet({
    super.key,
    required this.onTryAgain,
    required this.onEnterManually,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
        padding: EdgeInsets.only(top: 24.0, bottom: 32.0 + bottomInset),
        child: HorizontalPadding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20.0,
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
                  AppContainer(
                    width: 32.0,
                    height: 32.0,
                    shape: BoxShape.circle,
                    color: scheme.warnTint,
                    alignment: Alignment.center,
                    child: AppSvgIcon(
                      asset: AppIcons.warning,
                      size: 18.0,
                      color: scheme.warn,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      lo.scanFailedTitle,
                      style: textTheme.headline17Semi.copyWith(
                        color: scheme.ink,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                lo.scanFailedTips,
                style: textTheme.body17.copyWith(color: scheme.sec),
              ),
              Row(
                spacing: 10.0,
                children: [
                  Expanded(
                    child: _FailedActionButton(
                      label: lo.tryAgain,
                      isPrimary: true,
                      onTap: onTryAgain,
                    ),
                  ),
                  Expanded(
                    child: _FailedActionButton(
                      label: lo.enterManually,
                      isPrimary: false,
                      onTap: onEnterManually,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FailedActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _FailedActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
        // textScaleFactor — this button carries the "Try Again"/"Enter
        // Manually" label text, so MIN-HEIGHT only (the drag handle and
        // the icon-only warning badge above, on this same sheet, are the
        // correct FIXED-size decorative cases for comparison).
        constraints: const BoxConstraints(minHeight: 44.0),
        child: AppContainer(
          color: isPrimary ? scheme.ink : null,
          border: isPrimary ? null : Border.all(color: scheme.line2),
          borderRadius: BorderRadius.circular(14.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.subhead15.copyWith(
              fontWeight: FontWeight.w600,
              color: isPrimary ? scheme.onAccent : scheme.accent,
            ),
          ),
        ),
      ),
    );
  }
}
