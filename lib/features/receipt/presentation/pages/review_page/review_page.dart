import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../scanner/domain/pending_receipt_draft_store.dart';
import '../../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../../domain/use_cases/create_expense_from_receipt_use_case.dart';
import '../../bloc/review_bloc/review_bloc.dart';
import 'widgets/review_scaffold.dart';

/// `ReviewPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell, reached when the Scanner's `ParsedReceipt` is ready.
///
/// `ReviewBloc` is screen-scoped (`registerFactory` semantics: built here in
/// `initState`, closed in `dispose` — BLoC rule A3.8), loading its data from
/// `PendingReceiptDraftStore` rather than a router `extra` payload (see that
/// store's own doc comment for why).
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late final ReviewBloc _reviewBloc = ReviewBloc(
    draftStore: getIt<PendingReceiptDraftStore>(),
    receiptRepository: getIt<IReceiptLocalRepository>(),
    receiptItemRepository: getIt<IReceiptItemLocalRepository>(),
    productRepository: getIt<IProductLocalRepository>(),
    createExpenseFromReceipt: getIt<CreateExpenseFromReceiptUseCase>(),
  )..add(const ReviewEvent.load());

  final Map<String, TextEditingController> _editControllers = {};

  @override
  void dispose() {
    for (final controller in _editControllers.values) {
      controller.dispose();
    }
    _reviewBloc.close();
    super.dispose();
  }

  TextEditingController _controllerFor(String itemId, String initialText) {
    final existing = _editControllers[itemId];
    if (existing != null) return existing;
    final created = TextEditingController(text: initialText);
    _editControllers[itemId] = created;
    return created;
  }

  /// Back returns to whatever sits beneath Review — Home on the normal
  /// path, since the scanner `pushReplacement`s Review over itself and
  /// leaves Home in the stack.
  ///
  /// The explicit fallback covers a Review reached with no stack beneath
  /// it, where `pop()` would throw `GoError: There is nothing to pop`.
  void _onBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    HomePageRoute().go(context);
  }

  /// Discards the pending draft and returns to the SCANNER for a fresh
  /// capture.
  ///
  /// This deliberately does NOT pop: the scanner route was replaced by
  /// Review, so what lies beneath is Home — popping would send "Retake" to
  /// the wrong screen entirely. `.pushReplacement` swaps Review back out
  /// for a fresh scanner, preserving Home underneath and keeping the stack
  /// exactly one deep however many times the user retakes.
  void _onRetake() {
    getIt<PendingReceiptDraftStore>().clear();
    const ScannerPageRoute().pushReplacement(context);
  }

  void _onStartEditItem(String itemId) =>
      _reviewBloc.add(ReviewEvent.startEditItem(itemId));

  void _onDoneEditingItem(String itemId) {
    final controller = _editControllers[itemId];
    if (controller != null) {
      _reviewBloc.add(ReviewEvent.commitEditedName(controller.text));
    }
    _reviewBloc.add(const ReviewEvent.stopEditItem());
  }

  Future<void> _onPickCategory(BuildContext context) async {
    final pickedId = await CategoriesPageRoute().push<String>(context);
    if (pickedId == null || !context.mounted) return;
    _reviewBloc.add(ReviewEvent.setCategory(pickedId));
  }

  /// Dispatches the intent ONLY. The success toast is NOT shown here: at
  /// this point the bloc has not written anything yet, so a failing save
  /// would still have reported "saved". Feedback for both outcomes lives
  /// in the `saved` / `failed` listeners in `build`.
  void _onSave() => _reviewBloc.add(const ReviewEvent.save());

  void _onCorrect() => _reviewBloc.add(const ReviewEvent.saveAndCorrect());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewBloc>.value(
      value: _reviewBloc,
      child: MultiBlocListener(
          listeners: [
            // Two DISTINCT terminal statuses, two DISTINCT navigations — a
            // shared `saved` status here would fire the wrong route for one
            // of the two exit paths (see `ReviewState`'s doc comment).
            BlocListener<ReviewBloc, ReviewState>(
              listenWhen: (previous, current) =>
                  !previous.isSaved && current.isSaved,
              listener: (context, state) {
                final lo = AppLocalizations.of(context);
                UiMessageService.showSuccess(lo.tSaved(lo.reviewReceipt));
                HomePageRoute().go(context);
              },
            ),
            // `failed` was reachable and had an `isFailed` getter, but NOTHING
            // read it — a save that failed was completely silent, leaving the
            // user on a screen that looked unchanged. Surfacing it is the
            // other half of moving feedback off the dispatch site.
            BlocListener<ReviewBloc, ReviewState>(
              listenWhen: (previous, current) =>
                  !previous.isFailed && current.isFailed,
              listener: (context, state) => UiMessageService.showError(
                AppLocalizations.of(context).tSaveFailed,
              ),
            ),
            BlocListener<ReviewBloc, ReviewState>(
              listenWhen: (previous, current) =>
                  !previous.isCorrecting && current.isCorrecting,
              // PUSHED, not `.go()`: the Edit screen is a staging step the
              // user must be able to Cancel out of, back to THIS screen with
              // its state intact. `.go()` replaced the stack, which is why
              // Cancel had nowhere to return to.
              listener: (context, state) async {
                await const EditReceiptPageRoute(
                  receiptId: kPendingDraftReceiptId,
                ).push<void>(context);
                if (!context.mounted) return;
                // Reload on return so Review shows the corrections, and so
                // the status leaves `correcting` — otherwise the
                // `listenWhen` transition below could never fire again and
                // Correct would be a one-shot button.
                _reviewBloc.add(const ReviewEvent.load());
              },
            ),
          ],
        child: ReviewScaffold(
          controllerFor: _controllerFor,
          onBack: _onBack,
          onRetake: _onRetake,
          onStartEditItem: _onStartEditItem,
          onDoneEditingItem: _onDoneEditingItem,
          onPickCategory: () => _onPickCategory(context),
          onSave: _onSave,
          onCorrect: _onCorrect,
        ),
      ),
    );
  }
}
