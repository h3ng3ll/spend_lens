import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The Profile card's Plan badge (design_spendlens.md — the Profile
/// artboard's `planBadgeStyle`, `SpendLens Prototype.dc.html` line 911).
///
/// Premium renders the accent gradient pill; free renders a `--field` pill
/// with a hairline border — exactly the two branches the design specifies:
///
/// ```js
/// s.premium
///   ? 'background:linear-gradient(135deg,#C4B5FD,#8EE3F5);color:var(--onaccent)'
///   : 'background:var(--field);border:1px solid var(--line2);color:var(--sec)'
/// ```
///
/// Layout only — [isPremium] is resolved by the caller from `SyncBloc`, so
/// this widget never reads state itself.
class PlanBadge extends StatelessWidget {
  final String label;
  final bool isPremium;

  const PlanBadge({
    super.key,
    required this.label,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      height: 24.0,
      gradient: isPremium ? scheme.accentGradient : null,
      color: isPremium ? null : scheme.field,
      border: isPremium ? null : Border.all(color: scheme.line2, width: 1.0),
      borderRadius: BorderRadius.circular(999.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.center,
      child: Text(
        label,
        style: textTheme.sectionLabel12.copyWith(
          color: isPremium ? scheme.onAccent : scheme.sec,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
