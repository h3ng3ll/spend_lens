import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The Cash-expense optional "Note" field (design_spendlens.md's
/// Cash-expense artboard): a plain filled `--field` input, no visible
/// border, placeholder `L.optional`. Thin [CustomTextField] wrapper
/// matching `HistorySearchField`'s established call-site pattern.
class CashNoteField extends StatelessWidget {
  final TextEditingController controller;

  const CashNoteField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return CustomTextField(
      controller: controller,
      hintText: lo.optional,
      style: textTheme.body17.copyWith(color: scheme.ink),
      hintStyle: textTheme.body17.copyWith(color: scheme.ter),
      fillColor: scheme.field,
      filled: true,
      isDense: true,
      textInputAction: TextInputAction.done,
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }
}
