import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Whether the device currently has a network path, as a broadcast stream.
///
/// This exists so the sync UI can report "Offline" the MOMENT signal drops,
/// rather than only discovering it from a failed Firestore write, and so sync
/// gets a real reconnect trigger (offline -> online) instead of waiting for the
/// next app resume.
///
/// It is NOT the whole offline story, and deliberately so: connectivity is not
/// reachability. A captive-portal hotspot reports a perfectly good connection
/// while Firestore is unreachable, so `SyncErrorClassifier` still inspects
/// `FirebaseException.code` on the failure path. The two layers answer
/// different questions — "is there a network?" and "did the write land?" — and
/// neither subsumes the other.
///
/// This screen-agnostic service does not navigate. Nothing here routes to
/// `AppRoutes.noConnection`; that route remains reserved with no callers.
class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool? _lastIsOnline;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Emits only on CHANGE, never a repeat of the current value.
  Stream<bool> get stream => _controller.stream;

  /// Optimistic default: until the first sample arrives, assume online rather
  /// than flashing a false "Offline" on a cold start. Callers that must
  /// distinguish "unknown" from "online" read [isInitialised].
  bool get isOnline => _lastIsOnline ?? true;

  bool get isInitialised => _lastIsOnline != null;

  /// Seeds the current status, then subscribes for the app's lifetime.
  ///
  /// Awaited before `runApp` so the first frame already knows the real state.
  /// Idempotent — a second call is a no-op rather than a second subscription.
  Future<void> init() async {
    if (_subscription != null) return;

    final initial = await _connectivity.checkConnectivity();
    _lastIsOnline = _isOnlineFrom(initial);

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) => _emit(_isOnlineFrom(results)),
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    await _controller.close();
  }

  void _emit(bool isOnline) {
    if (_lastIsOnline == isOnline) return;
    _lastIsOnline = isOnline;
    _controller.add(isOnline);
  }

  bool _isOnlineFrom(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return !results.every((result) => result == ConnectivityResult.none);
  }
}
