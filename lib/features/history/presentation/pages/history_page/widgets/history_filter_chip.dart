import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One segment of [HistoryFilterRow] — its own file per the project's
/// "one widget class per file, no private widget classes" rule (A2).
class HistoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const HistoryFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppContainer(
        height: 36.0,
        alignment: Alignment.center,
        color: isSelected ? scheme.field2 : null,
        borderRadius: BorderRadius.circular(9.0),
        child: Text(
          label,
          style: textTheme.subhead15.copyWith(
            color: isSelected ? scheme.ink : scheme.ter,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
