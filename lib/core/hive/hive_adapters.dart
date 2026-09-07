import 'package:hive_ce/hive.dart';

import '../../features/analytics/domain/models/price_observation/price_observation.dart';
import '../../features/category/domain/models/category/category.dart';
import '../../features/expense/domain/models/expense/e_expense_source.dart';
import '../../features/expense/domain/models/expense/expense.dart';
import '../../features/product/domain/models/product/e_unit.dart';
import '../../features/product/domain/models/product/product.dart';
import '../../features/receipt/domain/models/receipt/receipt.dart';
import '../../features/receipt/domain/models/receipt_item/receipt_item.dart';
import '../../features/settings/domain/models/app_settings/app_settings.dart';
import '../../features/settings/domain/models/app_settings/e_app_theme_mode.dart';
import '../../features/settings/domain/models/app_settings/e_flash_mode.dart';
import '../../features/store/domain/models/store/e_store_type.dart';
import '../../features/store/domain/models/store/store.dart';
import '../models/e_sync_status.dart';

part 'hive_adapters.g.dart';

/// Central Hive adapter registration for the app.
///
/// M2 registered the first model (`AppSettings`, typeId 0) one milestone
/// early. M3 adds the remaining 7 freezed entities — `Receipt`,
/// `ReceiptItem`, `Product`, `Store`, `Category`, `Expense`,
/// `PriceObservation` — completing the 8-entity data layer
/// (design_spendlens.md §3 / §10).
///
/// Per hive_rules.md rule 3 / the recorded global bug
/// `hive-adapter-spec-file-missing-enum-model-imports`: every enum used as a
/// field of ANY model in the list below must be imported DIRECTLY in this
/// file, not merely in the model's own file — the generated `.g.dart` is a
/// `part` file and only inherits THIS file's imports. Hence the explicit
/// imports above for `EAppThemeMode`, `EFlashMode`, `EUnit`, `EStoreType`,
/// `EExpenseSource` and `ESyncStatus` even though every model file already
/// imports its own enum(s).
///
/// Auto-generated model adapters below occupy typeIds 0–7 (order-assigned by
/// `hive_ce_generator`); manual enum adapters in `enum_adapters.dart` use
/// typeIds ≥ 100. Both are pinned as literals in
/// `test/core/hive/hive_type_ids_test.dart` — a regeneration that renumbers
/// either range corrupts already-stored data.
@GenerateAdapters([
  AdapterSpec<AppSettings>(),
  AdapterSpec<Receipt>(),
  AdapterSpec<ReceiptItem>(),
  AdapterSpec<Product>(),
  AdapterSpec<Store>(),
  AdapterSpec<Category>(),
  AdapterSpec<Expense>(),
  AdapterSpec<PriceObservation>(),
])
class HiveAdapters {}
