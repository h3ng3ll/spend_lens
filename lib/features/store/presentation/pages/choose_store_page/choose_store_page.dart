import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../domain/models/store/e_store_type.dart';
import '../../../domain/models/store/store.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
import '../../bloc/stores_bloc/stores_bloc.dart';
import 'widgets/choose_store_body.dart';

/// `ChooseStorePageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for picking (or creating) the store attached to an expense
/// being edited. Tapping a row pops back with that store's id —
/// `CashExpensePage` awaits `ChooseStorePageRoute().push<String>(context)`.
///
/// [StoresBloc] is an app-lifetime, `registerLazySingleton` bloc dispatched
/// once from `main()` (BLoC rule A3.8) — this page reads the EXISTING
/// instance via `context.watch`, it never constructs its own.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the search
/// field sits at the TOP of the scrollable body (`ChooseStoreBody`), well
/// above any keyboard inset, and the `Scaffold` keeps its default
/// `resizeToAvoidBottomInset: true`.
class ChooseStorePage extends StatefulWidget {
  const ChooseStorePage({super.key});

  @override
  State<ChooseStorePage> createState() => _ChooseStorePageState();
}

class _ChooseStorePageState extends State<ChooseStorePage> {
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

  void _onPick(BuildContext context, Store store) => context.pop(store.id);

  Future<void> _onOpenNewStore(BuildContext context) async {
    await NewStorePageRoute().push<String>(context);
  }

  /// The Choose-store artboard's quick-create row: creates the typed query
  /// as a new store directly (one repository write), then pops with its id
  /// — the simpler of the two acceptable designs, avoiding a second
  /// navigation into `NewStorePage` that would just re-collect the same text
  /// the user already typed here.
  Future<void> _onQuickCreate(BuildContext context) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final now = DateTime.now();
    final store = Store(
      id: now.microsecondsSinceEpoch.toString(),
      name: query,
      type: EStoreType.other,
      updatedAt: now,
    );

    await getIt<IStoreLocalRepository>().save(store);
    if (!context.mounted) return;

    context.pop(store.id);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);
    final state = context.watch<StoresBloc>().state;

    return Scaffold(
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
                  title: lo.chooseStore,
                  onClose: () => _onClose(context),
                ),
              ),
              Expanded(
                child: state.isInitial || state.isLoading
                    ? const LoadingDataWidget()
                    : state.isFailed
                        ? ErrorMessageWidget(message: state.errorMessage)
                        : ChooseStoreBody(
                            stores: state.stores,
                            selectedStoreId: null,
                            searchController: _searchController,
                            onQuickCreate: () => _onQuickCreate(context),
                            onOpenNewStore: () => _onOpenNewStore(context),
                            onPick: (store) => _onPick(context, store),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
