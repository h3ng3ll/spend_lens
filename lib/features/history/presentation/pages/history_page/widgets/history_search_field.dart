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
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      prefixIcon: AppSvgIcon(asset: AppIcons.search, color: scheme.ter, size: 18.0),
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
