import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import 'app_container.dart';

/// The single "glass card" surface used throughout the manual-entry screens
/// (design_spendlens.md §10 — Home/Analytics/Stores/History/Settings all
/// group their rows in this exact card: translucent fill, 1px hairline,
/// 20dp radius).
///
/// Layout only (A6, Container Rule) — receives its children and lets the
/// caller decide what goes inside; this widget owns only the shared shell.
class AppSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppSectionCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(20.0),
      padding: padding,
      child: child,
    );
  }
}
