import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/stores_bloc/stores_bloc.dart';

/// Populated / empty presentation for `StorePage` (M4 minimal placeholder —
/// the real cards + price-comparison rows are M5).
class StoreBody extends StatelessWidget {
  final StoresState state;

  const StoreBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (state.stores.isEmpty) {
      return Center(
        child: Text(
          lo.storesIntro,
          textAlign: TextAlign.center,
          style: textTheme.body17.copyWith(color: scheme.sec),
        ),
      );
    }

    return HorizontalPadding(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: state.stores.length,
        itemBuilder: (context, index) {
          final store = state.stores[index];
          return Text(
            store.name,
            style: textTheme.body17.copyWith(color: scheme.ink),
          );
        },
      ),
    );
  }
}
