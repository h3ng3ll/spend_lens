import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// History's rounded search pill (design_spendlens.md — History artboard's
/// search row). A thin wrapper over the shared [CustomTextField] supplying
/// only this screen's icon/placeholder/shape — the query itself lives in
/// `HistoryPage`'s local `State`, never bloc state (BLoC rule A3.1).
class HistorySearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const HistorySearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return CustomTextField(
      hintText: lo.searchPh,
      onChanged: onChanged,
      style: textTheme.body17.copyWith(color: scheme.ink),
      hintStyle: textTheme.body17.copyWith(color: scheme.ter),
      fillColor: scheme.card,
      filled: true,
      isDense: true,
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.only(right: 14.0, top: 10.0, bottom: 10.0),
      // `prefixIcon` WITHOUT `prefixIconConstraints` gets Material's 48x48
      // minimum touch-target box, and the SVG scales up to fill it — which
      // is why the glyph rendered far larger than the design's 14dp mark
      // despite the size argument below. The constraints pin the box to the
      // icon, and the horizontal inset restores the design's `gap:8px`
      // between the mark and the placeholder text.
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 8.0),
        child: AppSvgIcon(
          asset: AppIcons.search,
          color: scheme.ter,
          size: 14.0,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 0.0,
        minHeight: 0.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: scheme.line, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: scheme.line, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: scheme.line2, width: 1.0),
      ),
    );
  }
}
