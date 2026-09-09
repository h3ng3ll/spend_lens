import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The storage-quota bar (`usedBarStyle` in the Profile artboard): a 6dp
/// track with an accent-gradient fill.
///
/// `AppContainer` + a measured width rather than `LinearProgressIndicator`,
/// whose track/fill styling cannot be expressed through `AppColorScheme` and
/// would smuggle raw Material colors onto the screen.
class StorageUsageBar extends StatelessWidget {
  /// 0.0–1.0, already clamped by `SyncState.usedFraction`.
  final double fraction;

  const StorageUsageBar({super.key, required this.fraction});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final fillWidth = trackWidth * fraction.clamp(0.0, 1.0);

        return AppContainer(
          width: trackWidth,
          height: 6.0,
          color: scheme.field,
          borderRadius: BorderRadius.circular(3.0),
          alignment: Alignment.centerLeft,
          child: fillWidth <= 0
              ? null
              : AppContainer(
                  width: fillWidth,
                  height: 6.0,
                  gradient: scheme.accentGradient,
                  borderRadius: BorderRadius.circular(3.0),
                ),
        );
      },
    );
  }
}
