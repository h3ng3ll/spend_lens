import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import 'e_record_detail_menu_action.dart';

/// Record Detail's header menu — the kebab icon that replaced the plain
/// "Edit" text action, now that the screen has more than one thing to offer.
///
/// This is the FIRST `PopupMenuButton` in the app, so every visual is passed
/// explicitly rather than inherited: Material's defaults would paint their
/// own surface colour and text styles, which is exactly the drift
/// `AppColorScheme`/`AppTextTheme` exist to prevent. The icon is an
/// `AppSvgIcon` because `Icon(Icons.*)` is banned project-wide and enforced
/// by `test/regression/no_material_icon_test.dart`.
class RecordDetailMenuButton extends StatelessWidget {
  static const _iconSize = 22.0;
  static const _menuRadius = 16.0;

  final ValueChanged<ERecordDetailMenuAction> onSelected;

  const RecordDetailMenuButton({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final itemStyle = textTheme.body17.copyWith(color: scheme.ink);

    return PopupMenuButton<ERecordDetailMenuAction>(
      onSelected: onSelected,
      color: scheme.cardSolid,
      surfaceTintColor: scheme.cardSolid,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_menuRadius),
        side: BorderSide(color: scheme.line2, width: 1.0),
      ),
      // The header reserves a 40dp cell for this control; the default
      // Material padding would push the glyph off that centre.
      padding: EdgeInsets.zero,
      icon: AppSvgIcon(
        asset: AppIcons.moreVertical,
        size: _iconSize,
        color: scheme.ink,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<ERecordDetailMenuAction>(
          value: ERecordDetailMenuAction.edit,
          child: Text(lo.edit, style: itemStyle),
        ),
        PopupMenuItem<ERecordDetailMenuAction>(
          value: ERecordDetailMenuAction.storageDetails,
          child: Text(lo.storageDetails, style: itemStyle),
        ),
      ],
    );
  }
}
