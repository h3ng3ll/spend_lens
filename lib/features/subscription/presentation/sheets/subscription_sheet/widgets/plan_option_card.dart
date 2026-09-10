import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One selectable billing-period card on the premium upgrade sheet.
///
/// Selection is shown with the accent border + tint rather than a checkmark
/// so the two cards read as a single either/or control at a glance. The
/// optional [badge] carries the yearly card's "Best value" pill.
///
/// Layout only (A6) — [onTap] is supplied by the sheet, which owns the bloc
/// dispatch (A2).
class PlanOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String? note;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const PlanOptionCard({
    super.key,
    required this.title,
    required this.price,
    this.note,
    this.badge,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final noteText = note;
    final badgeText = badge;

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        color: selected ? scheme.accentTint : scheme.field,
        border: Border.all(
          color: selected ? scheme.accent : scheme.line2,
          width: selected ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Row(
          spacing: 12.0,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2.0,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headline17Semi.copyWith(
                            color: scheme.ink,
                          ),
                        ),
                      ),
                      if (badgeText != null)
                        AppContainer(
                          height: 22.0,
                          gradient: scheme.accentGradient,
                          borderRadius: BorderRadius.circular(999.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            badgeText,
                            style: textTheme.sectionLabel12.copyWith(
                              color: scheme.onAccent,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    price,
                    style: textTheme.subhead15.copyWith(color: scheme.sec),
                  ),
                  if (noteText != null)
                    Text(
                      noteText,
                      style: textTheme.footnote13.copyWith(
                        color: scheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            AppContainer(
              width: 22.0,
              height: 22.0,
              shape: BoxShape.circle,
              color: selected ? scheme.accent : null,
              border: Border.all(
                color: selected ? scheme.accent : scheme.line2,
                width: 2.0,
              ),
              alignment: Alignment.center,
              child: selected
                  ? AppContainer(
                      width: 8.0,
                      height: 8.0,
                      shape: BoxShape.circle,
                      color: scheme.onAccent,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
