import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The New-category name field (design_spendlens.md's New-category
/// artboard): a `--card` surface with a 2px accent inset ring (the design's
/// `box-shadow: 0 0 0 2px var(--accent) inset`), autofocused. The 20px/w600
/// input weight matches the artboard's `font-size:20px;font-weight:500`.
class NewCategoryNameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const NewCategoryNameField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      hintText: lo.newCatPh,
      style: textTheme.headline17Semi.copyWith(color: scheme.ink),
      hintStyle: textTheme.headline17Semi.copyWith(color: scheme.ter),
      fillColor: scheme.card,
      filled: true,
      isDense: true,
      textInputAction: TextInputAction.done,
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: scheme.accent, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: scheme.accent, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: scheme.accent, width: 2.0),
      ),
    );
  }
}
