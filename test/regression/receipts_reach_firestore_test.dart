import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Receipts must stay in the set of entities the sync engine pushes.
///
/// This is a STRUCTURAL guard, not a behavioural one. The push itself is
/// generic over `SyncEntityAdapter`, so nothing would fail loudly if the
/// receipts adapter were dropped from `SyncEntityAdapters.all()` during a
/// refactor — receipts would simply stop reaching the server, silently,
/// with a clean log. That is the failure this pins.
void main() {
  test('SyncEntityAdapters registers receipts and receipt items', () {
    final source = File(
      'lib/features/sync/domain/adapters/sync_entity_adapters.dart',
    ).readAsStringSync();

    expect(
      source.contains('ESyncCollection.receipts'),
      isTrue,
      reason: 'The receipts adapter is gone — receipts would never upload.',
    );
    expect(
      source.contains('ESyncCollection.receiptItems'),
      isTrue,
      reason: 'Receipt line items would never upload.',
    );
  });

  test('both adapters are returned by all()', () {
    final source = File(
      'lib/features/sync/domain/adapters/sync_entity_adapters.dart',
    ).readAsStringSync();

    // `all()` is what RunFullSyncUseCase iterates; an adapter defined but
    // not listed there is dead code that uploads nothing.
    final allBody = RegExp(
      r'all\(\)\s*(?:=>|\{)(.*?)(?:\];|\}\s*\n)',
      dotAll: true,
    ).firstMatch(source)?.group(1);

    expect(allBody, isNotNull, reason: 'Could not locate all().');
    expect(allBody, contains('receipts'));
    expect(allBody, contains('receiptItems'));
  });
}
