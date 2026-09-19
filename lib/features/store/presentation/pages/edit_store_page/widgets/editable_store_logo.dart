import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/build_store_logo.dart';

/// The edit sheet's logo: the current image (or the initial-letter tile) with
/// a small edit badge, tappable to open the source sheet.
///
/// The badge is what makes the affordance discoverable — a bare circular tile
/// gives no hint that it is editable.
class EditableStoreLogo extends StatelessWidget {
  /// FILENAME of the image to show — never its bytes. See
  /// `StoreLogoImageStore`.
  final String filename;

  /// Drawn as the initial when there is no logo.
  final String storeName;
  final VoidCallback onTap;

  /// While true the logo shows a spinner instead of the edit badge, and the
  /// tap target is removed. The image being uploaded is the one on screen, so
  /// the progress belongs ON it rather than only under the button.
  final bool isUploading;

  const EditableStoreLogo({
    super.key,
    required this.filename,
    required this.storeName,
    required this.onTap,
    this.isUploading = false,
  });

  static const double _size = 96.0;
  static const double _badgeSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    final logo = SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: [
          BuildStoreLogo(
            filename: filename,
            storeName: storeName,
            size: _size,
            border: Border.all(color: scheme.line2, width: 3.0),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: AppContainer(
              width: _badgeSize,
              height: _badgeSize,
              color: scheme.accent,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.sheet, width: 2.0),
              alignment: Alignment.center,
              child: isUploading
                  ? SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          scheme.onAccent,
                        ),
                      ),
                    )
                  : AppSvgIcon(
                      asset: AppIcons.edit,
                      color: scheme.onAccent,
                      size: 16.0,
                    ),
            ),
          ),
        ],
      ),
    );

    // No tap target while the upload runs: re-opening the picker mid-upload
    // would stage a second image against a save already in flight.
    if (isUploading) return logo;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: logo,
    );
  }
}
