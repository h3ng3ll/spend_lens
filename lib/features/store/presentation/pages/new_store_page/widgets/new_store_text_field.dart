import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The New-store name/alias fields (design_spendlens.md's New-store
/// artboard): a plain filled `--field` input, no visible border. Shared by
/// both fields since they use the identical shell — only the placeholder
/// and controller differ per call site.
class NewStoreTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;

  const NewStoreTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return CustomTextField(
      controller: controller,
      hintText: hintText,
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
