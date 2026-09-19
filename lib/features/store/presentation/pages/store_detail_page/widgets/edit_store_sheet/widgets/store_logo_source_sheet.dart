import 'package:flutter/material.dart';

import '../../../../../../../../core/resources/app_icons.dart';
import '../../../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../../../core/widgets/app_container.dart';
import '../../../../../../../../core/widgets/sheet_close_header.dart';
import '../../../../../../../auth/presentation/pages/edit_profile_page/widgets/avatar_source_row.dart';
import 'e_store_logo_source.dart';

/// Picks where the new store logo comes from — or removes the current one.
///
/// Returns the choice rather than acting on it, so the staging decision stays
/// in [EditStoreBloc]: remove is staged, never committed on tap. The sheet
/// itself deletes nothing.
class StoreLogoSourceSheet extends StatelessWidget {
  /// Whether a logo currently exists. Gates the Remove row — it is offered
  /// ONLY when there is something to remove.
  final bool hasLogo;

  const StoreLogoSourceSheet({super.key, required this.hasLogo});

  static Future<EStoreLogoSource?> show(
    BuildContext context, {
    required bool hasLogo,
  }) {
    return showModalBottomSheet<EStoreLogoSource>(
      context: context,
      // Root navigator, above the 5-tab shell — matching `AvatarSourceSheet`.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => StoreLogoSourceSheet(hasLogo: hasLogo),
    );
  }

  void _onClose(BuildContext context) => Navigator.of(context).pop();

  void _onPick(BuildContext context, EStoreLogoSource source) =>
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
                title: lo.changeStoreLogo,
                onClose: () => _onClose(context),
              ),
              AvatarSourceRow(
                icon: AppIcons.scanFrame,
                label: lo.takePhoto,
                onTap: () => _onPick(context, EStoreLogoSource.camera),
              ),
              AvatarSourceRow(
                icon: AppIcons.receipt,
                label: lo.chooseFromGallery,
                onTap: () => _onPick(context, EStoreLogoSource.gallery),
              ),
              if (hasLogo)
                AvatarSourceRow(
                  icon: AppIcons.trash,
                  label: lo.removeStoreLogo,
                  onTap: () => _onPick(context, EStoreLogoSource.remove),
                  isDestructive: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
