/// Resolution of the user's manual cross-store product links.
///
/// Products are per-store, so the same goods bought at two stores are two
/// [Product] rows with two different ids. That is what makes each store own
/// its own price line — and it is also what would silently kill the
/// store-detail "cheaper by" comparison, which groups price observations by
/// `productId`: with nothing joining the two rows, every product would
/// forever report "Only bought here".
///
/// The join is the user's own: they link a product to its counterpart at
/// another store, and comparison then runs over the whole linked GROUP.
///
/// Pure functions only, so tests need no mocks.
library;

import '../models/product/product.dart';

/// Every product id in [productId]'s link group, including itself.
///
/// TRANSITIVE: links are stored as symmetric pairs, and this walks them, so
/// linking A-B and B-C makes all three one group without anyone maintaining
/// a group id. That matters because the alternative — stamping a shared
/// "family id" on each row — has to be rebalanced on every unlink, and a
/// half-applied rebalance splits a group in a way no UI would reveal.
///
/// Breadth-first over a visited set, so a cycle (A-B, B-A, or any longer
/// loop) terminates rather than recursing forever. Cycles are not a
/// hypothetical: symmetric writes create A-B and B-A by construction.
///
/// Ids that name a missing or tombstoned product are dropped — a link to a
/// deleted product is stale, not a reason to fail.
Set<String> resolveLinkedGroup(String productId, List<Product> allProducts) {
  final byId = <String, Product>{};
  for (final product in allProducts) {
    if (product.deletedAt != null) continue;
    byId[product.id] = product;
  }

  if (!byId.containsKey(productId)) return {productId};

  final group = <String>{};
  final queue = <String>[productId];

  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    if (!group.add(current)) continue;

    final product = byId[current];
    if (product == null) continue;

    for (final linkedId in product.linkedProductIds) {
      if (group.contains(linkedId)) continue;
      if (!byId.containsKey(linkedId)) continue;
      queue.add(linkedId);
    }
  }

  return group;
}

/// [a] and [b] with each other's id added — the SYMMETRIC write.
///
/// Returned as a pair for the caller to persist; this function performs no
/// I/O. Both sides must be saved, or the link is one-directional and
/// [resolveLinkedGroup] would find it from one product but not the other.
/// Re-linking an already-linked pair is a no-op rather than a duplicate.
({Product a, Product b}) linkProducts(Product a, Product b, DateTime now) {
  final linkedA = a.linkedProductIds.contains(b.id)
      ? a
      : a.copyWith(
          linkedProductIds: [...a.linkedProductIds, b.id],
          updatedAt: now,
        );
  final linkedB = b.linkedProductIds.contains(a.id)
      ? b
      : b.copyWith(
          linkedProductIds: [...b.linkedProductIds, a.id],
          updatedAt: now,
        );
  return (a: linkedA, b: linkedB);
}

/// [a] and [b] with each other's id removed — the symmetric unlink.
///
/// Removes the direct pair only. Anything still reachable through another
/// product stays in the group, which is the correct reading of a transitive
/// closure: unlinking A-B does not sever A-C when B-C still holds.
({Product a, Product b}) unlinkProducts(Product a, Product b, DateTime now) {
  return (
    a: a.copyWith(
      linkedProductIds: a.linkedProductIds
          .where((id) => id != b.id)
          .toList(),
      updatedAt: now,
    ),
    b: b.copyWith(
      linkedProductIds: b.linkedProductIds
          .where((id) => id != a.id)
          .toList(),
      updatedAt: now,
    ),
  );
}
