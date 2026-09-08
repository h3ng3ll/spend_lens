import 'dart:ui';

import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/colors/app_gradients.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';

/// The designed toast pill (design_spendlens.md §4.5 / §10 — verified at
/// `SpendLens Prototype.dc.html`'s "TOAST" block): a 44dp-tall pill, a small
/// gradient dot, 24px backdrop blur, shown for 2200ms.
///
/// CHRONIC BUG GUARD (`db:toast-pinned-to-hardcoded-top-offset-collides-
/// with-header`): this widget is positioned from the BOTTOM
/// (`bottom: 124.0`, clearing the 5-tab pill), never from a hardcoded `top:`
/// offset that could collide with a screen's own header/app bar. It is also
/// wrapped in [SafeArea] so the bottom system inset is respected on every
/// device.
///
/// Wraps its content in a transparent [Material]: it is inserted directly
/// into the ROOT navigator's overlay, where there is no `Scaffold` and hence
/// no `Material` ancestor, and un-parented `Text` renders with the default
/// debug style instead of the designed pill.
///
/// Purely presentational — [UiMessageService] owns the overlay lifecycle
/// (insert/remove/duration/queueing); this widget only renders one message.
class AppToast extends StatelessWidget {
  final String message;

  const AppToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Positioned(
      left: 20.0,
      right: 20.0,
      bottom: 124.0,
      child: IgnorePointer(
        child: SafeArea(
          // [UiMessageService] inserts this straight into the ROOT
          // navigator's overlay, which has no `Scaffold` and therefore no
          // `Material` ancestor. Without one the pill renders unthemed —
          // `Text` falls back to the default red-on-transparent debug style
          // and the pill loses its Material surface. `type: transparency`
          // supplies the missing Material WITHOUT painting a background of
          // its own, so `AppContainer`'s `toastBg` and the `BackdropFilter`
          // stay exactly as designed.
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              // `AppContainer`'s own `clipBehavior` (default `Clip.antiAlias`)
              // constrains the `BackdropFilter` to the pill's rounded shape —
              // no `ClipRRect` needed (hard ban, per CLAUDE.md).
              child: AppContainer(
                height: 44.0,
                color: scheme.toastBg,
                borderRadius: BorderRadius.circular(22.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.0,
                      children: [
                        AppContainer(
                          width: 8.0,
                          height: 8.0,
                          shape: BoxShape.circle,
                          gradient: AppGradients.accentGradient,
                        ),
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.subhead15.copyWith(
                              color: scheme.toastInk,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
