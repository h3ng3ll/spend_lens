import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';
import '../../../../../auth/presentation/pages/profile_page/widgets/cloud_sync_row.dart';
import '../../../../../sync/presentation/bloc/sync_bloc/sync_bloc.dart';

/// Settings' Sync card: the current cloud-sync status, and an explicit
/// action to run a cycle now.
///
/// A manual retry already existed — tapping Profile's status row — but it
/// carried no affordance saying so, which made it undiscoverable. A user
/// whose records were not synchronized had no visible way to do anything
/// about it.
///
/// [CloudSyncRow] is reused verbatim rather than reimplemented: it is a
/// self-contained `BlocBuilder<SyncBloc, SyncState>` taking no arguments,
/// and having one widget own the status wording keeps the two screens from
/// drifting apart.
class SyncCard extends StatelessWidget {
  const SyncCard({super.key});

  /// `fullResync: true` — this is the user asking for a repair, not a
  /// routine cycle. An incremental pull only asks for records newer than the
  /// stored cursor, so anything the cursor has already passed is invisible
  /// to it no matter how many times the button is tapped.
  void _onSyncNow(BuildContext context) => context.read<SyncBloc>().add(
        const SyncEvent.syncNow(fullResync: true),
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CloudSyncRow(),
          BlocBuilder<SyncBloc, SyncState>(
            buildWhen: (previous, current) =>
                previous.isSyncing != current.isSyncing ||
                previous.isDisabled != current.isDisabled,
            builder: (context, state) {
              // Nothing to sync against while signed out, and a second
              // dispatch mid-cycle is dropped by the bloc anyway — so the
              // control is disabled rather than dead on tap.
              final isEnabled = !state.isSyncing && !state.isDisabled;

              return SettingsRow(
                label: lo.syncNow,
                labelColor: isEnabled ? scheme.accent : scheme.dim,
                showChevron: false,
                showBottomDivider: false,
                onTap: isEnabled ? () => _onSyncNow(context) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
