import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/sheet_close_header.dart';
import 'avatar_source_row.dart';
import 'e_avatar_source.dart';

/// Picks where the new avatar comes from — or removes the current one.
///
/// Returns the choice rather than acting on it, so the staging decision stays
/// in [EditProfileBloc] (`edit_profile_screen_rules.md` rule 3: remove is
/// staged, never committed on tap). The sheet itself deletes nothing.
class AvatarSourceSheet extends StatelessWidget {
  /// Whether an avatar currently exists. Gates the Remove row — per rule 2 it
  /// is offered ONLY when there is something to remove.
  final bool hasAvatar;

  const AvatarSourceSheet({super.key, required this.hasAvatar});

  static Future<EAvatarSource?> show(
    BuildContext context, {
    required bool hasAvatar,
  }) {
    return showModalBottomSheet<EAvatarSource>(
      context: context,
      // Root navigator, above the 5-tab shell — matching `LanguageSheet.show`.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => AvatarSourceSheet(hasAvatar: hasAvatar),
    );
  }

  void _onClose(BuildContext context) => Navigator.of(context).pop();

  void _onPick(BuildContext context, EAvatarSource source) =>
      Navigator.of(context).pop(source);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return SafeArea(
      child: AppContainer(
        color: scheme.sheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SheetCloseHeader(
                title: lo.changePhoto,
                onClose: () => _onClose(context),
              ),
              AvatarSourceRow(
                icon: AppIcons.scanFrame,
                label: lo.takePhoto,
                onTap: () => _onPick(context, EAvatarSource.camera),
              ),
              AvatarSourceRow(
                icon: AppIcons.receipt,
                label: lo.chooseFromGallery,
                onTap: () => _onPick(context, EAvatarSource.gallery),
              ),
              if (hasAvatar)
                AvatarSourceRow(
                  icon: AppIcons.trash,
                  label: lo.removePhoto,
                  onTap: () => _onPick(context, EAvatarSource.remove),
                  isDestructive: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
