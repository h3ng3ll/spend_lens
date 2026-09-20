import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/settings/domain/models/app_settings/app_settings.dart';
import 'package:spend_lens/features/settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/models/store_detail_snapshot/store_detail_snapshot.dart';
import 'package:spend_lens/features/store/presentation/bloc/stores_bloc/stores_bloc.dart';
import 'package:spend_lens/features/store/presentation/pages/store_detail_page/widgets/store_detail_body.dart';

/// REGRESSION: the Store Detail screen rendered as a BLACK SCREEN.
///
/// `StoreStatsRow` was given `CrossAxisAlignment.stretch` to equalise the
/// Visits/Spent/Products card heights. But the row sits inside a
/// `SingleChildScrollView`, so its cross axis is UNBOUNDED — stretching against
/// that passes `h=Infinity` to every card and `performLayout` throws
/// "BoxConstraints forces an infinite height", taking the whole screen down.
///
/// `flutter analyze` cannot see this: it is a layout-constraint contract, not a
/// type error. Only pumping the real widget catches it, which is what this
/// test does.
void main() {
  testWidgets('renders without throwing, with a wrapping amount', (
    tester,
  ) async {
    final snapshot = StoreDetailSnapshot(
      store: Store(
        id: '1',
        name: 'Fidesco Putnei 28',
        updatedAt: DateTime(2026, 9, 19),
      ),
      expenses: const [],
      products: const [],
      priceObservations: const [],
      stores: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [AppColorScheme.dark(), AppTextTheme.base()],
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SettingsBloc>(create: (_) => _FakeSettingsBloc()),
            // `StoreDeleteSection` listens to this one; without it the body
            // throws `ProviderNotFoundException` instead of rendering.
            BlocProvider<StoresBloc>(create: (_) => _FakeStoresBloc()),
          ],
          child: Scaffold(
            body: StoreDetailBody(
              snapshot: snapshot,
              onClose: () {},
              onEdit: () {},
              onOpenProduct: (_) {},
              onAddProduct: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Fidesco Putnei 28'), findsOneWidget);
  });
}

class _FakeSettingsBloc extends Cubit<SettingsState> implements SettingsBloc {
  _FakeSettingsBloc()
    : super(
        const SettingsState(
          status: ESettingsStatus.ready,
          settings: AppSettings(),
        ),
      );

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStoresBloc extends Cubit<StoresState> implements StoresBloc {
  _FakeStoresBloc() : super(const StoresState());

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
