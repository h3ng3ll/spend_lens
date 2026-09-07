import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Back-navigation helper shared across the app.
///
/// Note: sinergy_hub's version also exposed `isAuthRoute(location)` against a
/// hardcoded list of that app's auth-flow route classes. SpendLens has no
/// router yet (it lands in M5 with `go_router_builder` typed routes), so that
/// helper is dropped here rather than carried forward with dead references —
/// re-add it against SpendLens's own routes if a screen needs it.
extension GoRouterX on BuildContext {
  void goBack() {
    if (kIsWeb) {
      if (canPop()) {
        pop();
        return;
      }
      final router = GoRouter.of(
        this,
      );
      final uri = router.routeInformationProvider.value.uri;

      final segments = uri.pathSegments;

      if (segments.isEmpty) {
        go('/');
        return;
      }

      final newSegments = List<String>.from(
        segments,
      )..removeLast();

      final newPath = '/${newSegments.join('/')}';

      go(
        newPath.isEmpty ? '/' : newPath,
      );
    } else {
      if (canPop()) {
        pop();
      } else {
        go('/');
      }
    }
  }
}
