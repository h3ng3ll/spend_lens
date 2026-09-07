import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One pill badge on Record Detail's card (design_spendlens.md's `dType` /
/// `dCat`+`dCatDot` badges row): a rounded `--field` pill with the label,
/// optionally preceded by a small colored dot ([dotColor], used for the
/// category badge; omitted for the plain type badge).
class RecordDetailBadge extends StatelessWidget {
  final String label;
  final Color? dotColor;

  const RecordDetailBadge({super.key, required this.label, this.dotColor});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final dot = dotColor;

    return AppContainer(
      height: 26.0,
      color: scheme.field,
      borderRadius: BorderRadius.circular(999.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6.0,
        children: [
          if (dot != null)
            AppContainer(width: 8.0, height: 8.0, color: dot, shape: BoxShape.circle),
          Text(
            label,
            style: textTheme.sectionLabel12.copyWith(
              color: scheme.sec,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
