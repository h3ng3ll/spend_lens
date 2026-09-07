import 'dart:typed_data';

import '../../receipt/domain/parser/parsed_receipt.dart';

/// One in-flight scan's parsed result, held only for the handoff between the
/// Scanner and Review/Edit screens (design_spendlens.md §5/§8).
///
/// This is NOT a persisted entity — a [ParsedReceipt] is ephemeral
/// scan-session state until the user actually saves it (at which point a
/// real `Receipt`/`ReceiptItem` set is written to Hive). Held in memory only
/// so `ReviewPageRoute`/`EditReceiptPageRoute` (both no-param, type-safe
/// `GoRouteData` routes per design_spendlens.md §5) do not need a
/// non-serializable `extra` payload threaded through the router — the
/// router contract is unchanged; this is a screen-scoped domain holder the
/// Scanner writes to and Review/Edit read from.
class PendingReceiptDraft {
  final ParsedReceipt parsedReceipt;
  final Uint8List imageBytes;

  const PendingReceiptDraft({
    required this.parsedReceipt,
    required this.imageBytes,
  });
}

/// Registered as a `@lazySingleton`-equivalent in `initScannerFeature` — a
/// single app-lifetime slot for the current scan's draft. Cleared once the
/// user saves or discards (Review/Edit's exit paths), so a stale draft is
/// never picked up by a later, unrelated scan.
class PendingReceiptDraftStore {
  PendingReceiptDraft? _current;

  PendingReceiptDraft? get current => _current;

  void set(PendingReceiptDraft draft) {
    _current = draft;
  }

  void clear() {
    _current = null;
  }
}
