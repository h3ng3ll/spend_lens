import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One of the four grips the user drags to resize the scan window: the two
/// side grips change its WIDTH, the two top/bottom grips change its HEIGHT.
/// Drawn as a short pill centred on the edge it controls, laid out along
/// that edge — vertical on the left/right, horizontal on the top/bottom.
///
/// The visible pill is deliberately smaller than its touch target: the grip
/// reads as a thin 4pt bar but is wrapped in a [touchExtent]-wide
/// transparent box, so it clears the ~44pt minimum tap size without a
/// heavy-looking control sitting over the camera
/// (`control-rendered-inside-the-system-cutout-inset-is-untappable` is the
/// inverse failure — here the risk is a control that looks tappable at 4pt
/// and misses every drag that starts a few pixels off).
class ScannerFrameHandle extends StatelessWidget {
  final Color color;

  /// Which dimension this grip resizes. [Axis.horizontal] is a left/right
  /// side grip (drawn as a vertical pill); [Axis.vertical] is a top/bottom
  /// grip (drawn as a horizontal pill).
  final Axis axis;

  const ScannerFrameHandle({
    super.key,
    required this.color,
    required this.axis,
  });

  /// The touch box's extent ACROSS the edge — the direction the drag
  /// actually travels, so it is the dimension that must clear the minimum
  /// tap size.
  static const double touchExtent = 44.0;
  static const double _pillThickness = 4.0;
  static const double _pillLength = 52.0;

  /// The touch box's extent ALONG the edge. Sized so a grip is comfortably
  /// grabbable past the ends of its visible pill.
  static const double touchLength = touchExtent + _pillLength;

  @override
  Widget build(BuildContext context) {
    final isSideGrip = axis == Axis.horizontal;

    return SizedBox(
      width: isSideGrip ? touchExtent : touchLength,
      height: isSideGrip ? touchLength : touchExtent,
      child: Center(
        child: AppContainer(
          width: isSideGrip ? _pillThickness : _pillLength,
          height: isSideGrip ? _pillLength : _pillThickness,
          color: color,
          borderRadius: BorderRadius.circular(_pillThickness),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.value.withValues(alpha: 0.45),
              blurRadius: 6.0,
            ),
          ],
        ),
      ),
    );
  }
}
