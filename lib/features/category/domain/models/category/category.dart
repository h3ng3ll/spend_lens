import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// An expense category (design_spendlens.md §3). 12 are seeded on first
/// launch (§7, binding decision 3); the user may add custom ones.
///
/// `name` is an **i18n key** for built-in categories (e.g. `'catFood'`,
/// resolved through `AppLocalizations` at display time) and a plain
/// user-typed string for custom ones — never a rendered string baked in at
/// seed time.
@freezed
sealed class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String colorHex,
    required bool isBuiltIn,
    @Default(<String>[]) List<String> keywords,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
