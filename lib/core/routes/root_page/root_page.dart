import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../resources/app_icons.dart';
import '../../resources/colors/app_color_scheme.dart';
import '../../resources/localization/gen/app_localizations.dart';
import '../../widgets/app_container.dart';
import 'widgets/shell_tab_item.dart';

/// The 5-branch shell (design_spendlens.md §5): Home, Analytics, Stores,
/// History, Settings.
///
/// **Tab-bar visibility is structural, not a flag.** The pill is built ONLY
/// here, inside the shell's `builder` — a screen pushed with
/// `parentNavigatorKey: rootNavigatorKey` (e.g. `StoreDetailPageRoute`) is
/// rendered on the ROOT navigator, above this whole widget, so the bar is
/// automatically absent for it. There is no `hideTabBar` boolean anywhere in
/// this app; adding one would be redundant with — and could drift from —
/// this structural guarantee.
///
/// Inset ownership, stated precisely (recorded global bug
/// `missing-safearea-top-inset-header-behind-statusbar`):
///
/// - BOTTOM inset: owned HERE, once. The pill row is wrapped in `SafeArea`,
///   and NO branch page wraps a `SafeArea` of its own, so the inset is
///   applied exactly once rather than twice.
/// - TOP inset: owned by `Scaffold`, not by this shell and not by an explicit
///   `SafeArea`. Each of the 5 branch pages is a full `Scaffold` that passes
///   `CustomAppBar` in the `appBar:` slot, and `CustomAppBar` returns a real
///   Material `AppBar`. `Scaffold` applies the top padding to the `appBar:`
///   slot itself, so the header never sits under the status bar.
///
/// There is deliberately NO `SafeArea` in any branch page: adding one would
/// double-pad the top. If a future branch page renders a header WITHOUT the
/// `appBar:` slot, that page must handle the top inset itself — the guarantee
/// above comes from `Scaffold`'s appBar contract, not from this widget.
class RootPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootPage({super.key, required this.navigationShell});

  void _goBranch(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    final tabs = <(String, String)>[
      (AppIcons.tabHome, lo.tabHome),
      (AppIcons.tabAnalytics, lo.tabAnalytics),
      (AppIcons.tabStores, lo.tabStores),
      (AppIcons.tabHistory, lo.tabHistory),
      (AppIcons.tabSettings, lo.tabSettings),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: AppContainer(
            height: 64.0,
            color: scheme.bar,
            borderRadius: BorderRadius.circular(24.0),
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++)
                  ShellTabItem(
                    asset: tabs[i].$1,
                    label: tabs[i].$2,
                    isSelected: navigationShell.currentIndex == i,
                    onTap: () => _goBranch(context, i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
