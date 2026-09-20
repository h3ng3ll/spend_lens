/// Combines multiple repository streams into ONE stream for a single
/// `emit.forEach` (hive_rules.md §7/§10 — never parallel `emit.forEach`
/// calls, never `stream.listen`, never Dart record types for the combined
/// value). A bloc reacting to several repositories combines them here into
/// a **named snapshot class** and subscribes to that one combined stream.
///
/// This file wraps `rxdart`'s `Rx.combineLatestN` — those thin wrappers are
/// re-exported under this project's own name so every combining bloc
/// imports one file instead of reaching into `rxdart` directly, and so the
/// "never parallel emit.forEach" rule has one place to audit imports
/// against.
///
/// Usage (a later milestone's bloc, e.g. Home):
/// ```dart
/// await emit.forEach<HomeSnapshot>(
///   combineLatest2(
///     _expenseRepository.watchAll(),
///     _categoryRepository.watchAll(),
///     (expenses, categories) => HomeSnapshot(
///       expenses: expenses,
///       categories: categories,
///     ),
///   ),
///   onData: (snapshot) => state.copyWith(status: EHomeStatus.ready, snapshot: snapshot),
/// );
/// ```
/// `HomeSnapshot` above is a named class the OWNING feature defines — this
/// file intentionally ships no snapshot classes of its own, since no bloc
/// consumes one yet in M3.
library;

import 'package:rxdart/rxdart.dart';


/// Combines two streams into one, emitting whenever either source emits,
/// using the CURRENT value of both.
Stream<T> combineLatest2<A, B, T>(
  Stream<A> streamA,
  Stream<B> streamB,
  T Function(A, B) combiner,
) =>
    Rx.combineLatest2(streamA, streamB, combiner);

/// Combines three streams into one, emitting whenever any source emits.
Stream<T> combineLatest3<A, B, C, T>(
  Stream<A> streamA,
  Stream<B> streamB,
  Stream<C> streamC,
  T Function(A, B, C) combiner,
) =>
    Rx.combineLatest3(streamA, streamB, streamC, combiner);

/// Combines four streams into one, emitting whenever any source emits.
Stream<T> combineLatest4<A, B, C, D, T>(
  Stream<A> streamA,
  Stream<B> streamB,
  Stream<C> streamC,
  Stream<D> streamD,
  T Function(A, B, C, D) combiner,
) =>
    Rx.combineLatest4(streamA, streamB, streamC, streamD, combiner);

/// Combines five streams into one, emitting whenever any source emits.
Stream<T> combineLatest5<A, B, C, D, E, T>(
  Stream<A> streamA,
  Stream<B> streamB,
  Stream<C> streamC,
  Stream<D> streamD,
  Stream<E> streamE,
  T Function(A, B, C, D, E) combiner,
) =>
    Rx.combineLatest5(streamA, streamB, streamC, streamD, streamE, combiner);

/// Six-stream combiner. Same contract as the smaller arities above.
Stream<T> combineLatest6<A, B, C, D, E, F, T>(
  Stream<A> streamA,
  Stream<B> streamB,
  Stream<C> streamC,
  Stream<D> streamD,
  Stream<E> streamE,
  Stream<F> streamF,
  T Function(A, B, C, D, E, F) combiner,
) => Rx.combineLatest6(
  streamA,
  streamB,
  streamC,
  streamD,
  streamE,
  streamF,
  combiner,
);
