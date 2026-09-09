/// The combined value `SyncBloc` subscribes to.
///
/// A NAMED class, not a Dart record: this project's BLoC rules require one
/// combined stream plus a named snapshot type when a bloc reacts to several
/// sources, so the shape stays greppable and documented.
///
/// Carries no uid-adjacent PII beyond the uid itself, and `SyncState`
/// deliberately does not store the uid — freezed `toString()` is logged by
/// `AppObserver`, and leaking an identifier there is a recorded bug
/// (`AuthState.email` did exactly that once).
class SyncSnapshot {
  final String uid;
  final bool isOnline;
  final int pendingCount;

  const SyncSnapshot({
    required this.uid,
    required this.isOnline,
    required this.pendingCount,
  });
}
