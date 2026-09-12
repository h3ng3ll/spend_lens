import 'package:flutter/material.dart';

import '../../models/e_sync_status.dart';
import '../../resources/colors/app_color_scheme.dart';
import '../../resources/localization/gen/app_localizations.dart';

/// Maps [ESyncStatus] to the label and dot colour the UI shows for it.
///
/// A service, not a widget helper: the mapping is display POLICY (which
/// states are worth distinguishing to a user, and which read as "fine"
/// versus "not yet"), and the project keeps that out of the widget layer.
/// It also means one switch governs every surface that ever shows sync
/// state, instead of each widget inventing its own.
///
/// The switches are exhaustive over the enum deliberately — adding a state
/// to [ESyncStatus] should fail to compile here rather than silently
/// rendering a blank badge.
class SyncStatusPresenter {
  const SyncStatusPresenter();

  /// `pendingCreate` and `pendingUpdate` share one label on purpose. The
  /// difference between "never uploaded" and "edited since upload" is a
  /// sync-engine detail; to the user both mean "not on the server yet", and
  /// two labels would be noise.
  String label(ESyncStatus status, AppLocalizations lo) {
    switch (status) {
      case ESyncStatus.synced:
        return lo.synced;
      case ESyncStatus.pendingCreate:
      case ESyncStatus.pendingUpdate:
        return lo.syncPendingUpload;
      case ESyncStatus.pendingDelete:
        return lo.syncPendingDelete;
    }
  }

  /// `accent2` (the teal brand accent) marks the settled state rather than
  /// `trendDown`: that token is the analytics "spending fell" green and
  /// carries a meaning unrelated to sync. Everything still in flight uses
  /// `warn`, the same amber the app already uses for "needs attention".
  Color color(ESyncStatus status, AppColorScheme scheme) {
    switch (status) {
      case ESyncStatus.synced:
        return scheme.accent2;
      case ESyncStatus.pendingCreate:
      case ESyncStatus.pendingUpdate:
      case ESyncStatus.pendingDelete:
        return scheme.warn;
    }
  }
}
