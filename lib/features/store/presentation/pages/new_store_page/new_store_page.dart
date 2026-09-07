import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../domain/models/store/e_store_type.dart';
import '../../../domain/models/store/store.dart';
import '../../../domain/repositories/i_store_local_repository.dart';
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

  void _onNameControllerChanged() => setState(() => _name = _nameController.text);

  void _onClose(BuildContext context) => context.pop();

  void _onTypeSelected(EStoreType type) => setState(() => _type = type);

  Future<void> _onCreate(BuildContext context) async {
    final trimmedName = _name.trim();
    if (trimmedName.isEmpty) return;

    final trimmedAlias = _aliasController.text.trim();
    final now = DateTime.now();

    final store = Store(
      id: now.microsecondsSinceEpoch.toString(),
      name: trimmedName,
      receiptAliases: trimmedAlias.isEmpty ? const [] : [trimmedAlias],
      type: _type,
      updatedAt: now,
    );

    await getIt<IStoreLocalRepository>().save(store);
    if (!context.mounted) return;

    context.pop(store.id);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final isEnabled = _name.trim().isNotEmpty;

    return Scaffold(
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
                  style: textTheme.footnote13.copyWith(color: scheme.ter, height: 1.45),
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
    );
  }
}
