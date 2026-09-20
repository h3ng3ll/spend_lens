import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The Choose-product picker's search-or-create field — the same shell as
/// `StoreSearchField` and `CategorySearchField`, scoped to this feature
/// since each slice owns its own picker.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): sits at the
/// TOP of `ChooseProductPage`'s scrollable body, clear of the keyboard
/// inset.
class ProductSearchField extends StatelessWidget {
  final TextEditingController controller;

  const ProductSearchField({super.key, required this.controller});

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
              hintText: lo.searchProductPh,
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
