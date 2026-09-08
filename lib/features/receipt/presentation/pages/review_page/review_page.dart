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

  /// `context.pop()` ONLY when there is something to pop.
  ///
  /// The scanner reaches Review with `.go()` — deliberately, so the user
  /// cannot back into a stale scanner session — which REPLACES the route
  /// stack. `pop()` then has no target and does nothing at all, leaving the
  /// user stuck on this screen. Falling back to an explicit destination is
  /// what makes the control actually work on that (normal) entry path.
  void _onBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    HomePageRoute().go(context);
  }

  /// Discards the pending draft and returns to the scanner for a fresh
  /// capture. Uses the same pop-or-navigate fallback as [_onBack]: on the
  /// `.go()` entry path there is nothing to pop, and a dead "Retake" is
  /// exactly the dead end spec §66 forbids.
  void _onRetake() {
    getIt<PendingReceiptDraftStore>().clear();

    if (context.canPop()) {
      context.pop();
      return;
    }
    const ScannerPageRoute().go(context);
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
                !previous.isSavedThenCorrect && current.isSavedThenCorrect,
            listener: (context, state) {
              final receiptId = state.savedReceiptId;
              if (receiptId == null) return;
              EditReceiptPageRoute(receiptId: receiptId).go(context);
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
