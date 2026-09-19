import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/gradient_cta_button.dart';

/// The Save control, which becomes a progress indicator while the save runs.
///
/// Uploading a logo is network-bound and takes real time. Without this the
/// button simply greys out and nothing else happens — indistinguishable from a
/// dead button, which is what prompts a user to tap again or dismiss the sheet
/// mid-upload.
///
/// The label names the PHASE rather than saying "please wait": the upload is
/// the slow part, and telling the user which step they are waiting on is the
/// difference between a stall and progress.
class SaveStoreButton extends StatelessWidget {
  final bool isSaving;

  /// The OS picker is open, or its result is being staged.
  final bool isPickingLogo;
  final bool isUploadingLogo;
  final bool canSave;
  final VoidCallback onSave;

  const SaveStoreButton({
    super.key,
    required this.isSaving,
    required this.isPickingLogo,
    required this.isUploadingLogo,
    required this.canSave,
    required this.onSave,
  });

  /// Any work that should replace the button with progress.
  ///
  /// Picking is included even though it is not a save: it is slow, it is the
  /// direct result of a tap in this sheet, and leaving the button live during
  /// it invites a save that would commit the previous logo.
  bool get _isBusy => isSaving || isPickingLogo;

  static const double _height = 54.0;
  static const double _indicatorSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (!_isBusy) {
      return GradientCtaButton(
        label: lo.save,
        enabled: canSave,
        onTap: onSave,
      );
    }

    // No tap target at all while busy — not a disabled one. A save is in
    // flight and irreversible mid-upload, so there is nothing useful a second
    // tap could do.
    return AppContainer(
      height: _height,
      color: scheme.field,
      borderRadius: BorderRadius.circular(16.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.0,
        children: [
          SizedBox(
            width: _indicatorSize,
            height: _indicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.accent),
            ),
          ),
          Text(
            // Most specific phase first: picking and uploading are both slow
            // for different reasons, and a single "saving" would misreport
            // which one the user is waiting on.
            switch (true) {
              _ when isPickingLogo => lo.processingPhoto,
              _ when isUploadingLogo => lo.uploadingPhoto,
              _ => lo.savingStore,
            },
            style: textTheme.body17.copyWith(color: scheme.sec),
          ),
        ],
      ),
    );
  }
}
