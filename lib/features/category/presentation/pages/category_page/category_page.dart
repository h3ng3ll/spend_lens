import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/categories_bloc/categories_bloc.dart';
import 'widgets/category_body.dart';

/// `CategoriesPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for managing categories (rename/add/delete custom ones).
///
/// [CategoriesBloc] is an app-lifetime, `registerLazySingleton` bloc
/// dispatched once from `main()` (BLoC rule A3.8) — this page reads the
/// EXISTING instance via `context.read`, it never constructs its own.
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.categories)),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const LoadingDataWidget();
          }
          if (state.isFailed) {
            return ErrorMessageWidget(message: state.errorMessage);
          }
          return CategoryBody(state: state);
        },
      ),
    );
  }
}
