import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/categories_bloc/categories_bloc.dart';

/// Populated / empty presentation for `CategoryPage` (M4 minimal placeholder
/// — the full add/edit/delete UI is M5; this list just proves the reactive
/// bloc → repository wiring and the four-state contract).
class CategoryBody extends StatelessWidget {
  final CategoriesState state;

  const CategoryBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (state.categories.isEmpty) {
      return Center(
        child: Text(
          lo.categoryEmpty,
          style: textTheme.body17.copyWith(color: scheme.sec),
        ),
      );
    }

    return HorizontalPadding(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          return Text(
            category.name,
            style: textTheme.body17.copyWith(color: scheme.ink),
          );
        },
      ),
    );
  }
}
