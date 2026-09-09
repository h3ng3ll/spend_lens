import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../core/failures/sync_failures.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../../core/services/subscription/i_subscription_repository.dart';
import '../../../../../core/utils/app_limits.dart';
import '../../../domain/adapters/sync_entity_adapters.dart';
import '../../../domain/models/sync_snapshot/sync_snapshot.dart';
import '../../../domain/use_cases/run_full_sync_use_case.dart';

part 'sync_event.dart';

part 'sync_state.dart';

part 'sync_state_ext.dart';

part 'sync_bloc.freezed.dart';

/// App-lifetime sync bloc (`registerLazySingleton`, `SyncEvent.watch()`
/// dispatched once from `main()` — never re-dispatched from a screen).
///
/// Concurrency mirrors the lesson `AuthBloc` documents at length: `_Watch`
/// awaits `emit.forEach` over an INFINITE stream, so its Future never
/// completes. Registering it on the same `sequential()` queue as the action
/// event would permanently occupy that queue and leave every `syncNow`
/// unhandled — a dead feature invisible to `flutter analyze`. So `_Watch` is
/// `restartable()` and `_SyncNow` is `droppable()`, on separate handlers.
///
/// `droppable()` for `_SyncNow` is deliberate: a burst of local edits should
/// coalesce into one cycle, not queue N of them.
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final RunFullSyncUseCase _runFullSync;
  final SyncEntityAdapters _adapters;
  final ConnectivityService _connectivityService;
  final FirebaseFirestoreService _firestoreService;
  final FirebaseStorageService _storageService;
  final ISubscriptionRepository _subscriptionRepository;

  // `required this._x` — the shape `AuthBloc` uses.
  SyncBloc({
    required this._runFullSync,
    required this._adapters,
    required this._connectivityService,
    required this._firestoreService,
    required this._storageService,
    required this._subscriptionRepository,
  }) : super(const SyncState()) {
    on<_Watch>(_onWatch, transformer: restartable());
    on<_SyncNow>(_onSyncNow, transformer: droppable());
  }

  /// Subscribes to ONE combined stream (BLoC rule: never parallel
  /// `emit.forEach` calls on a single emitter, and a named snapshot class
  /// rather than a Dart record).
  Future<void> _onWatch(_Watch event, Emitter<SyncState> emit) async {
    await emit.forEach<SyncSnapshot>(
      _snapshots(),
      onData: (snapshot) => _stateFrom(snapshot),
      onError: (error, stackTrace) => state.copyWith(
        status: ESyncUiStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  /// uid + connectivity + total pending count, combined.
  ///
  /// The uid stream is `authGated`-adjacent: `authState` is already distinct
  /// on uid, so this re-emits only when the signed-in user actually changes.
  Stream<SyncSnapshot> _snapshots() {
    final uidStream = _firestoreService.authState
        .map((user) => user?.uid ?? '')
        .startWith(_firestoreService.currentUid ?? '');

    final onlineStream = _connectivityService.stream.startWith(
      _connectivityService.isOnline,
    );

    return Rx.combineLatest3<String, bool, int, SyncSnapshot>(
      uidStream,
      onlineStream,
      _pendingCounts(),
      (uid, isOnline, pendingCount) => SyncSnapshot(
        uid: uid,
        isOnline: isOnline,
        pendingCount: pendingCount,
      ),
    );
  }

  /// Total rows awaiting upload, re-counted whenever any box mutates.
  Stream<int> _pendingCounts() async* {
    yield await _countPending();
    // Any box write is a reason to recount. Watching the seven boxes
    // separately and summing would need seven parallel subscriptions; one
    // recount on any change is both simpler and cheaper at this data size.
    yield* Rx.merge(
      _adapters.all().map((a) => a.watchAll()),
    ).asyncMap((_) => _countPending());
  }

  Future<int> _countPending() async {
    var total = 0;
    for (final adapter in _adapters.all()) {
      total += (await adapter.readPending()).length;
    }
    return total;
  }

  SyncState _stateFrom(SyncSnapshot snapshot) {
    if (snapshot.uid.isEmpty) {
      // Signed out: not an error, and not "up to date" either — there is no
      // account to be up to date with.
      return state.copyWith(
        status: ESyncUiStatus.disabled,
        pendingCount: snapshot.pendingCount,
        isOnline: snapshot.isOnline,
        usedBytes: 0,
      );
    }

    if (!snapshot.isOnline) {
      return state.copyWith(
        status: ESyncUiStatus.offline,
        pendingCount: snapshot.pendingCount,
        isOnline: false,
      );
    }

    // Signed in and online. Anything outstanding means a cycle is due;
    // `needsSync` turns that into the listener's trigger.
    final status = snapshot.pendingCount > 0
        ? ESyncUiStatus.idle
        : (state.lastSyncedAt == null
              ? ESyncUiStatus.idle
              : ESyncUiStatus.upToDate);

    return state.copyWith(
      status: state.isSyncing ? state.status : status,
      pendingCount: snapshot.pendingCount,
      isOnline: true,
    );
  }

  Future<void> _onSyncNow(_SyncNow event, Emitter<SyncState> emit) async {
    final uid = _firestoreService.currentUid;
    if (uid == null || uid.isEmpty) {
      emit(state.copyWith(status: ESyncUiStatus.disabled));
      return;
    }

    emit(state.copyWith(status: ESyncUiStatus.syncing, errorMessage: ''));

    final result = await _runFullSync(uid: uid);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          // An offline failure reads as `offline`, not `failed`: the writes
          // are queued and will replay, so presenting it as breakage would
          // invite a pointless retry.
          status: failure is SyncOfflineFailure
              ? ESyncUiStatus.offline
              : ESyncUiStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (report) async {
        final usedBytes = await _storageService.usedBytes(uid);
        final isPremium = await _subscriptionRepository.hasPremiumAccess();

        emit(
          state.copyWith(
            status: ESyncUiStatus.upToDate,
            errorMessage: '',
            lastSyncedAt: DateTime.now(),
            usedBytes: usedBytes,
            isPremium: isPremium,
            quotaBytes: isPremium
                ? AppLimits.premiumCloudQuotaBytes
                : AppLimits.freeCloudQuotaBytes,
          ),
        );
      },
    );
  }
}
