import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/build_avatar.dart';

/// The edit screen's avatar: the current image (or the placeholder glyph) with
/// a small camera badge, tappable to open the source sheet.
///
/// The badge is what makes the affordance discoverable — a bare circular image
/// gives no hint that it is editable.
class EditableAvatar extends StatelessWidget {
  /// FILENAME of the image to show — never its bytes. See `AvatarImageStore`.
  final String filename;
  final VoidCallback onTap;

  /// While true the avatar shows a spinner instead of the edit badge, and the
  /// tap target is removed. The image being uploaded is the one on screen, so
  /// the progress belongs ON it rather than only under the button.
  final bool isUploading;

  const EditableAvatar({
    super.key,
    required this.filename,
    required this.onTap,
    this.isUploading = false,
  });

  static const double _size = 96.0;
  static const double _badgeSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    final avatar = SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: [
          BuildAvatar(
            filename: filename,
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
              border: Border.all(color: scheme.bg, width: 2.0),
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
    if (isUploading) return avatar;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: avatar,
    );
  }
}
