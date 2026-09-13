import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The first/last-name inputs: a plain filled `--field` input with no visible
/// border, matching `NewStoreTextField`'s shell so the two form surfaces are
/// visually identical.
class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return CustomTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      style: textTheme.body17.copyWith(color: scheme.ink),
      hintStyle: textTheme.body17.copyWith(color: scheme.ter),
      fillColor: scheme.field,
      filled: true,
      isDense: true,
      textInputAction: textInputAction,
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }
}
