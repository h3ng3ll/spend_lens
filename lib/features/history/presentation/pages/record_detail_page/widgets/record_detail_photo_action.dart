import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One of the two secondary actions beneath Record Detail's receipt-photo
/// preview (design_spendlens.md — the artboard's `retakePhoto` /
/// `choosePhoto` pair): a 40dp `--field` pill with a centered label.
class RecordDetailPhotoAction extends StatelessWidget {
  final String label;
  final Future<void> Function() onTap;

  const RecordDetailPhotoAction({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        height: 40.0,
        color: scheme.field,
        borderRadius: BorderRadius.circular(12.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.center,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textTheme.subhead15.copyWith(
            color: scheme.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
