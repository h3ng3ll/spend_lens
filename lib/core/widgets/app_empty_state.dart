import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';
import 'app_svg_icon.dart';

/// The shared empty-state shell (design_spendlens.md §10, ported from v1's
/// "Empty state" component — `SpendLens.dc.html`).
///
/// Used for BOTH truly-empty conditions (Home/History "no records yet") and,
/// with different copy, a filter/search miss — callers must pass in copy
/// that is DISTINCT for each case
/// (`sig:filter-miss-empty-state-absent-only-the-unfiltered-empty-state-exists`).
/// This widget does not know which case it is rendering; that decision is
/// the caller's, and is why `title`/`body` are required rather than baked
/// in here.
class AppEmptyState extends StatelessWidget {
  final String icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(16.0),
      padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10.0,
        children: [
          AppSvgIcon(asset: icon, color: scheme.ter, size: 40.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headline17Semi.copyWith(color: scheme.ink),
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: textTheme.subhead15.copyWith(color: scheme.sec),
          ),
          if (actionLabel != null && onAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: GestureDetector(
                onTap: onAction,
                child: AppContainer(
                  color: scheme.ink,
                  borderRadius: BorderRadius.circular(14.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    actionLabel!,
                    style: textTheme.subhead15.copyWith(
                      color: scheme.bg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
