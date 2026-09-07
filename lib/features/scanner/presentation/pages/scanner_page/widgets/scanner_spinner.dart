import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';

/// The processing panel's indeterminate ring (`SpendLens.dc.html`'s
/// `slSpin` — 1s linear infinite). Backed by the framework's own
/// [CircularProgressIndicator] ticker rather than a hand-rolled
/// [AnimationController] — this widget owns no lifecycle to leak, and it is
/// only ever mounted while `EScannerStatus.processing`
/// (`ScannerProcessingSheet` is itself gated on that status), so the ticker
/// never runs above the router or outside this screen.
class ScannerSpinner extends StatelessWidget {
  const ScannerSpinner({super.key});

  static const _size = 36.0;
  static const _strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return SizedBox(
      width: _size,
      height: _size,
      child: CircularProgressIndicator(
        strokeWidth: _strokeWidth,
        backgroundColor: scheme.accent2Tint,
        valueColor: AlwaysStoppedAnimation(scheme.accent),
      ),
    );
  }
}
