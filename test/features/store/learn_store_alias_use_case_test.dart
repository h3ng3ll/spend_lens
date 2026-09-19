import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/features/store/domain/use_cases/learn_store_alias_use_case.dart';

/// `Store.receiptAliases` had two writers and ZERO readers — the field the
/// model was designed around was dead, so an oddly-printed store name had to
/// be corrected by hand on every single scan.
///
/// These cover the write side. The rule that matters is restraint: it must
/// record a spelling exactly once, and never one that already resolves.
void main() {
  late _RecordingStoreRepository repository;
  late LearnStoreAliasUseCase learnAlias;

  setUp(() {
    repository = _RecordingStoreRepository();
    learnAlias = LearnStoreAliasUseCase(repository: repository);
  });

  Store store({List<String> aliases = const []}) => Store(
    id: '1',
    name: 'Kaufland',
    receiptAliases: aliases,
    updatedAt: DateTime(2026, 9, 19),
  );

  test('appends the printed spelling', () async {
    await learnAlias(store: store(), printedName: 'KAUFLAND SA MD-2001');

    expect(repository.saved.single.receiptAliases, ['KAUFLAND SA MD-2001']);
  });

  test('keeps existing aliases, appending rather than replacing', () async {
    await learnAlias(
      store: store(aliases: ['KAUFLEND']),
      printedName: 'KAUMPFLEND',
    );

    // The user's earlier lesson is not forgotten when a new one is learned —
    // every spelling they have confirmed maps to this one store.
    expect(repository.saved.single.receiptAliases, [
      'KAUFLEND',
      'KAUMPFLEND',
    ]);
  });

  test('stores the RAW spelling, not a cleaned one', () async {
    await learnAlias(store: store(), printedName: 'Nr.1, Green Hills');

    expect(repository.saved.single.receiptAliases, ['Nr.1, Green Hills']);
  });

  group('writes nothing when there is nothing to learn', () {
    test('the printed name already equals the store name', () async {
      await learnAlias(store: store(), printedName: 'kaufland');
      expect(repository.saved, isEmpty);
    });

    test('the alias is already on file, ignoring case and punctuation', () async {
      await learnAlias(
        store: store(aliases: ['KAUFLAND SA MD-2001']),
        printedName: 'kaufland sa md 2001',
      );

      // Without cleaned comparison this row would grow by one on every scan
      // of the same receipt.
      expect(repository.saved, isEmpty);
    });

    test('the printed name is null', () async {
      await learnAlias(store: store(), printedName: null);
      expect(repository.saved, isEmpty);
    });

    test('the printed name is blank', () async {
      await learnAlias(store: store(), printedName: '   ');
      expect(repository.saved, isEmpty);
    });
  });
}

class _RecordingStoreRepository implements IStoreLocalRepository {
  final List<Store> saved = [];

  @override
  Future<void> save(Store store, {bool markPending = true}) async {
    saved.add(store);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
