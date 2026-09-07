import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../domain/models/category/category.dart';
import '../../../domain/models/category/category_display_x.dart';
import '../../bloc/categories_bloc/categories_bloc.dart';
import 'widgets/category_body.dart';
import 'widgets/rename_category_dialog.dart';

/// `CategoriesPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell serving TWO purposes at once, per the router: it is both a
/// PICKER (tapping a row pops back with that category's id — `CashExpensePage`
/// awaits `CategoriesPageRoute().push<String>(context)`) and a MANAGER
/// (rename/delete for custom categories, "+ New category"). The router
/// registers exactly one no-argument `CategoriesPageRoute` (no query param
/// for a picker-only mode), so both roles live on this one screen rather
/// than two.
///
/// [CategoriesBloc] is an app-lifetime, `registerLazySingleton` bloc
/// dispatched once from `main()` (BLoC rule A3.8) — this page reads the
/// EXISTING instance via `context.watch`, it never constructs its own or
/// re-dispatches `watch()`.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the search
/// field sits at the TOP of the scrollable body (`CategoryBody`), well above
/// any keyboard inset, and the `Scaffold` keeps its default
/// `resizeToAvoidBottomInset: true` — the list below it simply shrinks/
/// scrolls, never covering the field itself.
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchControllerChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchControllerChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchControllerChanged() => setState(() {});

  void _onClose(BuildContext context) => context.pop();

  void _onPick(BuildContext context, Category category) =>
      context.pop(category.id);

  Future<void> _onOpenNewCategory(BuildContext context) async {
    await NewCategoryPageRoute().push<String>(context);
  }

  /// The Categories artboard's quick-create row: dispatches the typed query
  /// as an intent — `CategoriesBloc` owns the write and the id/color
  /// derivation. The `BlocListener` below pops with the resulting id once
  /// [CategoriesState.lastCreatedId] arrives.
  void _onQuickCreate(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.read<CategoriesBloc>().add(CategoriesEvent.quickCreate(query));
  }

  Future<void> _onRename(BuildContext context, Category category) async {
    final lo = AppLocalizations.of(context);
    final bloc = context.read<CategoriesBloc>();

    await RenameCategoryDialog.show(
      context,
      initialName: category.displayName(lo),
      onRenamed: (newName) =>
          bloc.add(CategoriesEvent.rename(category, newName)),
    );
  }

  Future<void> _onDelete(BuildContext context, Category category) async {
    final lo = AppLocalizations.of(context);
    final bloc = context.read<CategoriesBloc>();

    await ConfirmDialog.show(
      context,
      title: lo.deleteCategory,
      body: lo.deleteCategoryConfirm(category.displayName(lo)),
      confirmLabel: lo.deleteCategory,
      cancelLabel: lo.cancel,
      onConfirm: () => bloc.add(CategoriesEvent.delete(category.id)),
    );
  }

  bool _listenWhenCreated(CategoriesState previous, CategoriesState current) {
    return current.lastCreatedId != null &&
        previous.lastCreatedId != current.lastCreatedId;
  }

  void _onCreated(BuildContext context, CategoriesState state) {
    final createdId = state.lastCreatedId;
    if (createdId == null) return;
    context.pop(createdId);
  }

  bool _listenWhenWriteFailed(
    CategoriesState previous,
    CategoriesState current,
  ) {
    return !previous.isWriteFailed && current.isWriteFailed;
  }

  void _onWriteFailed(BuildContext context, CategoriesState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);
    final state = context.watch<CategoriesBloc>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<CategoriesBloc, CategoriesState>(
          listenWhen: _listenWhenCreated,
          listener: _onCreated,
        ),
        BlocListener<CategoriesBloc, CategoriesState>(
          listenWhen: _listenWhenWriteFailed,
          listener: _onWriteFailed,
        ),
      ],
      child: Scaffold(
        backgroundColor: scheme.bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: [
                HorizontalPadding(
                  child: SheetCloseHeader(
                    title: lo.categories,
                    onClose: () => _onClose(context),
                  ),
                ),
                Expanded(
                  child: state.isInitial || state.isLoading
                      ? const LoadingDataWidget()
                      : state.isFailed
                      ? ErrorMessageWidget(message: state.errorMessage)
                      : CategoryBody(
                          categories: state.categories,
                          searchController: _searchController,
                          onQuickCreate: () => _onQuickCreate(context),
                          onOpenNewCategory: () => _onOpenNewCategory(context),
                          onPick: (category) => _onPick(context, category),
                          onRename: (category) => _onRename(context, category),
                          onDelete: (category) => _onDelete(context, category),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
