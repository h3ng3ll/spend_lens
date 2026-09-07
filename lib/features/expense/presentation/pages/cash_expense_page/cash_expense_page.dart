import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../../category/domain/models/category/category.dart';
import '../../../../category/presentation/bloc/categories_bloc/categories_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/expense/e_expense_source.dart';
import '../../../domain/models/expense/expense.dart';
import '../../../domain/repositories/i_expense_local_repository.dart';
import 'widgets/cash_amount_field.dart';
import 'widgets/cash_category_row.dart';
import 'widgets/cash_date_row.dart';
import 'widgets/cash_note_field.dart';
import 'widgets/cash_store_row.dart';

/// `CashExpensePageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for logging a cash expense (`EExpenseSource.cash`) with no
/// receipt.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): this is a
/// full-screen route, not a bottom sheet, so the fix is the "screen fields
/// low on the page" half of the recorded rule — the whole form (amount,
/// category row, note field, store row, date row) lives inside a single
/// [SingleChildScrollView] and the `Scaffold` keeps its default
/// `resizeToAvoidBottomInset: true`. The Save button is INSIDE that same
/// scroll region (not pinned outside it via `Spacer`/`Expanded`), so when
/// the keyboard opens for the note field — the lowest field above it — the
/// whole column simply scrolls and both the field and Save stay reachable.
class CashExpensePage extends StatefulWidget {
  const CashExpensePage({super.key});

  @override
  State<CashExpensePage> createState() => _CashExpensePageState();
}

class _CashExpensePageState extends State<CashExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Category? _category;
  String? _storeId;
  String? _storeName;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Category _defaultCategory(List<Category> categories) {
    if (_category != null) return _category!;
    if (categories.isEmpty) {
      // No categories loaded yet (seed race) — a placeholder the user will
      // never actually see save against, since `_onSave` requires a real
      // category id resolved from the live list.
      return Category(
        id: 'catOther',
        name: 'catOther',
        colorHex: '#8E8E93',
        isBuiltIn: true,
        updatedAt: DateTime.now(),
      );
    }
    return categories.firstWhere(
      (c) => c.id == 'catOther',
      orElse: () => categories.first,
    );
  }

  void _onClose(BuildContext context) => context.pop();

  Future<void> _onPickCategory(BuildContext context) async {
    final pickedId = await CategoriesPageRoute().push<String>(context);
    if (pickedId == null || !context.mounted) return;

    final categories = context.read<CategoriesBloc>().state.categories;
    Category? picked;
    for (final candidate in categories) {
      if (candidate.id == pickedId) {
        picked = candidate;
        break;
      }
    }
    if (picked == null) return;

    setState(() => _category = picked);
  }

  Future<void> _onPickStore(BuildContext context) async {
    final pickedId = await ChooseStorePageRoute().push<String>(context);
    if (pickedId == null || !context.mounted) return;

    final store = await getIt<IStoreLocalRepository>().getById(pickedId);
    if (store == null) return;

    setState(() {
      _storeId = store.id;
      _storeName = store.name;
    });
  }

  void _onClearStore() {
    setState(() {
      _storeId = null;
      _storeName = null;
    });
  }

  Future<void> _onSave(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0.0) {
      UiMessageService.showError(lo.enterValidAmount);
      return;
    }

    final categories = context.read<CategoriesBloc>().state.categories;
    final category = _defaultCategory(categories);
    final currencyCode = context.read<SettingsBloc>().state.settings.currencyCode;
    final now = DateTime.now();

    final expense = Expense(
      id: now.microsecondsSinceEpoch.toString(),
      amount: amount,
      currencyCode: currencyCode,
      categoryId: category.id,
      storeId: _storeId,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      occurredAt: now,
      source: EExpenseSource.cash,
      updatedAt: now,
    );

    await getIt<IExpenseLocalRepository>().save(expense);
    if (!context.mounted) return;

    UiMessageService.showSuccess(lo.tCashAdded(_amountController.text));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);
    final currencyCode = context.watch<SettingsBloc>().state.settings.currencyCode;
    final categories = context.watch<CategoriesBloc>().state.categories;
    final category = _defaultCategory(categories);

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
                  title: lo.cashExpense,
                  onClose: () => _onClose(context),
                ),
                LabeledField(
                  label: lo.amount,
                  child: CashAmountField(
                    controller: _amountController,
                    currencyCode: currencyCode,
                  ),
                ),
                LabeledField(
                  label: lo.category,
                  child: CashCategoryRow(
                    category: category,
                    onTap: () => _onPickCategory(context),
                  ),
                ),
                LabeledField(
                  label: lo.note,
                  child: CashNoteField(controller: _noteController),
                ),
                LabeledField(
                  label: '${lo.store} · ${lo.optional}',
                  child: CashStoreRow(
                    storeName: _storeName,
                    noStoreLabel: lo.noStore,
                    onTap: () => _onPickStore(context),
                    onClear: _onClearStore,
                  ),
                ),
                const CashDateRow(),
                GradientCtaButton(
                  label: lo.save,
                  enabled: true,
                  onTap: () => _onSave(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
