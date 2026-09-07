import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../domain/models/store/e_store_type.dart';
import '../../bloc/stores_bloc/stores_bloc.dart';
import 'widgets/new_store_text_field.dart';
import 'widgets/store_type_chip_row.dart';

/// `NewStorePageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell for creating a store by hand (name, receipt alias, type).
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the whole
/// form (header, note, name field, alias field, type row, Create button)
/// lives inside one [SingleChildScrollView] and the `Scaffold` keeps its
/// default `resizeToAvoidBottomInset: true` — the Create button is INSIDE
/// that same scroll region rather than pinned outside it, so both fields and
/// the button stay reachable once the keyboard opens for either one.
class NewStorePage extends StatefulWidget {
  const NewStorePage({super.key});

  @override
  State<NewStorePage> createState() => _NewStorePageState();
}

class _NewStorePageState extends State<NewStorePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();

  EStoreType _type = EStoreType.other;
  String _name = '';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameControllerChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameControllerChanged);
    _nameController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  void _onNameControllerChanged() =>
      setState(() => _name = _nameController.text);

  void _onClose(BuildContext context) => context.pop();

  void _onTypeSelected(EStoreType type) => setState(() => _type = type);

  /// Dispatches the create intent only — `StoresBloc` owns the write. The
  /// `BlocListener` below pops with the resulting id once
  /// [StoresState.lastCreatedId] arrives.
  void _onCreate(BuildContext context) {
    final trimmedName = _name.trim();
    if (trimmedName.isEmpty) return;

    context.read<StoresBloc>().add(
      StoresEvent.create(
        name: trimmedName,
        receiptAlias: _aliasController.text,
        type: _type,
      ),
    );
  }

  bool _listenWhenCreated(StoresState previous, StoresState current) {
    return current.lastCreatedId != null &&
        previous.lastCreatedId != current.lastCreatedId;
  }

  void _onCreated(BuildContext context, StoresState state) {
    final createdId = state.lastCreatedId;
    if (createdId == null) return;
    context.pop(createdId);
  }

  bool _listenWhenWriteFailed(StoresState previous, StoresState current) {
    return !previous.isWriteFailed && current.isWriteFailed;
  }

  void _onWriteFailed(BuildContext context, StoresState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final isEnabled = _name.trim().isNotEmpty;

    return MultiBlocListener(
      listeners: [
        BlocListener<StoresBloc, StoresState>(
          listenWhen: _listenWhenCreated,
          listener: _onCreated,
        ),
        BlocListener<StoresBloc, StoresState>(
          listenWhen: _listenWhenWriteFailed,
          listener: _onWriteFailed,
        ),
      ],
      child: Scaffold(
        backgroundColor: scheme.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: HorizontalPadding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 18.0,
                children: [
                  SheetCloseHeader(
                    title: lo.newStore,
                    onClose: () => _onClose(context),
                  ),
                  Text(
                    lo.newStoreNote,
                    style: textTheme.footnote13.copyWith(
                      color: scheme.ter,
                      height: 1.45,
                    ),
                  ),
                  LabeledField(
                    label: lo.name,
                    child: NewStoreTextField(
                      controller: _nameController,
                      hintText: lo.namePh,
                    ),
                  ),
                  LabeledField(
                    label: lo.alias,
                    child: NewStoreTextField(
                      controller: _aliasController,
                      hintText: lo.aliasPh,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  LabeledField(
                    label: lo.type,
                    child: StoreTypeChipRow(
                      selected: _type,
                      onSelected: _onTypeSelected,
                    ),
                  ),
                  GradientCtaButton(
                    label: lo.createStore,
                    enabled: isEnabled,
                    onTap: () => _onCreate(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
