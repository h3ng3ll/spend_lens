/// One document as it came back from Firestore.
///
/// A plain class, not freezed: it holds a decoded JSON map on its way into a
/// model and is never persisted, compared or copied — the code generation
/// would buy nothing.
class RemoteRecord {
  final String id;
  final Map<String, dynamic> json;

  const RemoteRecord({required this.id, required this.json});

  /// The document's `updatedAt` as stored (ISO-8601), or null when absent.
  String? get updatedAtRaw => json['updatedAt'] as String?;

  /// Parsed `updatedAt`, or null when missing/unparseable.
  ///
  /// Never falls back to `DateTime.now()`. The reference template's
  /// `TimestampConverter` did exactly that, which makes a record with no
  /// timestamp indistinguishable from one written this instant — poison for
  /// last-write-wins, since such a row would beat every real local edit.
  DateTime? get updatedAt {
    final raw = updatedAtRaw;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  bool get isTombstone => json['deletedAt'] != null;
}
