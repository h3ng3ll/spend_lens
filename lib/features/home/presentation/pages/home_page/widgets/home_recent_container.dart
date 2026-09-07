import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../domain/models/home_snapshot.dart';
import '../../../utils/home_calculations.dart';
import 'home_recent_card.dart';

/// Resolves the [kHomeRecentCount] most-recent expenses from [snapshot]
/// into fully-formatted [HomeRecentEntry] rows and hands them to
/// [HomeRecentCard]. Renders nothing if there is no expense yet — reachable
/// only in the degenerate case of a month-scoped filter elsewhere ever being
/// added; today [snapshot] is only non-empty here because the caller
/// already excluded the truly-empty state one level up.
class HomeRecentContainer extends StatelessWidget {
  final HomeSnapshot snapshot;

  const HomeRecentContainer({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final recent = recentExpenses(snapshot.expenses);

    if (recent.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final entries = buildRecentEntries(
          lo,
          recent,
          snapshot.categories,
          snapshot.stores,
          settingsState.settings.currencyCode,
        );

        return HomeRecentCard(entries: entries);
      },
    );
  }
}
