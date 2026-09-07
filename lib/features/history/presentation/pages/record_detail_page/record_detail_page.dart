import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../bloc/record_detail_bloc/record_detail_bloc.dart';
import 'widgets/record_detail_body.dart';
import 'widgets/record_detail_header.dart';

/// `RecordDetailPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing one History record.
///
/// M5 scope boundary: renders ONLY the cash-expense branch of the design's
/// Record detail artboard — every record in History at this milestone is an
/// [Expense] with `source: cash` (receipt scanning is M7/M8), so this
/// screen does not implement the items-list / receipt-photo branch at all.
/// A future milestone ADDS that branch as new code once receipts exist; it
/// is never uncommented from a stub (`no_commented_code_rules.md`).
///
/// The header's Edit action shows an info toast rather than navigating: this
/// build's `init_router.dart` has no dedicated edit-cash-expense route (only
/// `CashExpensePageRoute`, which CREATES a new expense, was found), and
/// inventing a new route/screen for it is outside this task's scope
/// (CLAUDE.md's "no invented screens/routes/flows" rule) — that gap is
/// reported in this build's handoff rather than worked around.
///
/// [RecordDetailBloc] is screen-scoped (`registerFactory` semantics): built
/// here in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class RecordDetailPage extends StatefulWidget {
  final String recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late final RecordDetailBloc _recordDetailBloc = RecordDetailBloc(
    recordId: widget.recordId,
    expenseLocalRepository: getIt<IExpenseLocalRepository>(),
    categoryLocalRepository: getIt<ICategoryLocalRepository>(),
    storeLocalRepository: getIt<IStoreLocalRepository>(),
  )..add(const RecordDetailEvent.watch());

  @override
  void dispose() {
    _recordDetailBloc.close();
    super.dispose();
  }

  void _onClose() {
    context.goBack();
  }

  void _onEdit() {
    final lo = AppLocalizations.of(context);
    UiMessageService.showInfo(lo.editComingSoon);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: BlocProvider<RecordDetailBloc>.value(
        value: _recordDetailBloc,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RecordDetailHeader(
                typeLabel: lo.cashType,
                editLabel: lo.edit,
                onClose: _onClose,
                onEdit: _onEdit,
              ),
              Expanded(
                child: BlocBuilder<RecordDetailBloc, RecordDetailState>(
                  builder: (context, state) => RecordDetailBody(state: state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
