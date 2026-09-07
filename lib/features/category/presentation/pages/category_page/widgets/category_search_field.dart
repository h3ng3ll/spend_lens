import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The Categories picker's search-or-create field (design_spendlens.md's
/// Categories artboard): a translucent `--card` pill with a leading dot
/// placeholder (matching the artboard's plain ring glyph, not a search
/// icon), filtering the list client-side as the user types.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): this field
/// sits near the TOP of `CategoryPage`'s scrollable column, so it is never
/// at risk of being covered — verified per-field in that page's doc
/// comment.
class CategorySearchField extends StatelessWidget {
  final TextEditingController controller;

  const CategorySearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppContainer(
      height: 48.0,
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10.0,
        children: [
          AppContainer(
            width: 14.0,
            height: 14.0,
            shape: BoxShape.circle,
            border: Border.all(color: scheme.ter, width: 2.0),
          ),
          Expanded(
            child: CustomTextField(
              controller: controller,
              hintText: lo.searchCatPh,
              style: textTheme.body17.copyWith(color: scheme.ink),
              hintStyle: textTheme.body17.copyWith(color: scheme.ter),
              filled: false,
              isDense: true,
              textInputAction: TextInputAction.search,
              padding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
