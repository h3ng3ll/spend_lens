import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../settings/domain/models/app_settings/e_flash_mode.dart';
import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';

/// The close button + flash pill floating over the camera preview
/// (`SpendLens.dc.html`'s three camera artboards, top row).
///
/// Positioned below the status-bar/notch inset via [MediaQuery.paddingOf] —
/// this screen is a top-level push, not a shell branch, so it owns its own
/// top inset entirely (chronic bugs
/// `missing-safearea-top-inset-header-behind-statusbar` and
/// `control-rendered-inside-the-system-cutout-inset-is-untappable`: a
/// control painted at `top: 0` would sit under the status bar and be
/// unreachable while its `onTap` is perfectly correct).
class ScannerTopControls extends StatelessWidget {
  final EFlashMode flashMode;

  const ScannerTopControls({super.key, required this.flashMode});

  void _onClose(BuildContext context) => context.goBack();

  void _onToggleFlash(BuildContext context) =>
      context.read<SettingsBloc>().add(const SettingsEvent.toggleFlashMode());

  String _flashLabel(AppLocalizations lo) => switch (flashMode) {
    EFlashMode.auto => lo.flashAuto,
    EFlashMode.on => lo.flashOn,
    EFlashMode.off => lo.flashOff,
  };

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final textTheme = AppTextTheme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final overlayFill = AppColors.white.value.withValues(alpha: 0.14);

    return Positioned(
      left: 20.0,
      right: 20.0,
      top: 20.0 + topInset,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _onClose(context),
            behavior: HitTestBehavior.opaque,
            child: AppContainer(
              width: 44.0,
              height: 44.0,
              shape: BoxShape.circle,
              color: overlayFill,
              alignment: Alignment.center,
              child: AppSvgIcon(
                asset: AppIcons.close,
                color: AppColors.white.value,
                size: 18.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onToggleFlash(context),
            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
              // A MINIMUM, not a hard clip — the pill is text-bearing
              // (`_flashLabel`), so it must be free to grow under a larger
              // textScaleFactor rather than clipping the label (chronic bug
              // `sig:developer-derived-fixed-dp-cell-height-cannot-absorb-textscalefactor`).
              constraints: const BoxConstraints(minHeight: 36.0),
              child: AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 6.0,
                ),
                borderRadius: BorderRadius.circular(999.0),
                color: overlayFill,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: [
                    AppSvgIcon(
                      asset: AppIcons.flash,
                      color: AppColors.white.value,
                      size: 12.0,
                    ),
                    Text(
                      _flashLabel(lo),
                      style: textTheme.footnote13.copyWith(
                        color: AppColors.white.value,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
