import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/category_dot.dart';

/// Home's top row: the current month/year label, plus a sync-status pill
/// (design_spendlens.md — Home artboard's `curMonthYear` + `syncLabel` row).
///
/// M5 has no real auth/sync (that lands at M9), so the pill is rendered
/// permanently in the "on-device" state — never a working profile/sync
/// flow. Tapping it only navigates to [ProfilePageRoute], which already
/// exists in the router.
class HomeHeaderRow extends StatelessWidget {
  final String monthYearLabel;

  const HomeHeaderRow({super.key, required this.monthYearLabel});

  void _onTapProfile(BuildContext context) => ProfilePageRoute().push(context);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthYearLabel,
          style: textTheme.subhead15.copyWith(
            color: scheme.sec,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () => _onTapProfile(context),
          child: AppContainer(
            height: 26.0,
            color: scheme.card,
            border: Border.all(color: scheme.line, width: 1.0),
            borderRadius: BorderRadius.circular(999.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6.0,
              children: [
                CategoryDot(color: scheme.sec, size: 6.0),
                Text(
                  lo.onDeviceShort,
                  style: textTheme.footnote13.copyWith(
                    color: scheme.sec,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
