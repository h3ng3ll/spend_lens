import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/settings_row.dart';
import '../../../../../sync/presentation/bloc/sync_bloc/sync_bloc.dart';

/// The Profile artboard's `cloudSync` row, driven by REAL sync state.
///
/// This row previously rendered a hardcoded `lo.upToDate`, so it claimed
/// "Up to date" with nothing uploaded and no engine behind it — the exact
/// "wired-looking but dead" defect this codebase's comments warn about.
///
/// Tappable, because `failed` and `offline` otherwise dead-end: the user can
/// see something is wrong with no way to act on it.
class CloudSyncRow extends StatelessWidget {
  const CloudSyncRow({super.key});

  void _onRetry(BuildContext context) {
    context.read<SyncBloc>().add(const SyncEvent.syncNow());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        // `pendingCount` is shown rather than a bare "not synced": "3
        // pending" tells the user what is actually outstanding.
        final (String text, Color color) = switch (state.status) {
          ESyncUiStatus.syncing => (lo.syncing, scheme.sec),
          ESyncUiStatus.upToDate => (lo.upToDate, scheme.accent2),
          ESyncUiStatus.offline => (lo.offline, scheme.sec),
          ESyncUiStatus.failed => (lo.syncError, scheme.warn),
          ESyncUiStatus.disabled => (lo.syncDisabled, scheme.sec),
          ESyncUiStatus.idle =>
            state.hasPendingChanges
                ? (lo.syncPending(state.pendingCount), scheme.sec)
                : (lo.upToDate, scheme.accent2),
        };

        return SettingsRow(
          label: lo.cloudSync,
          trailingText: text,
          trailingTextColor: color,
          showChevron: false,
          // No retry while a cycle is already running, and none when sync is
          // disabled (signed out) — there is nothing to retry against.
          onTap: state.isSyncing || state.isDisabled
              ? null
              : () => _onRetry(context),
        );
      },
    );
  }
}
