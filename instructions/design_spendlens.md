# SpendLens — Receipt Expense Analyzer

## Context

Build a Flutter app for personal expense tracking driven by **physical receipt scanning**:
camera → receipt detection → on-device OCR → deterministic parsing → user review → local
save → analytics / history / price history.

`/Volumes/SSD/Programming/device_lab/spend_lens` is today a bare `flutter create` scaffold
(only `lib/main.dart`). Everything is new code, but the **architecture is not invented** —
it is lifted from `/Volumes/SSD/Programming/StudioProjects/sinergy_hub`, which already uses
the exact clean-architecture layout required, and extended with the `feature` Mason brick
that generates the same slice shape.

Two authorities govern the work:

- **Scope + visual truth** — `assets/SpendLens design system/`. `SpendLens Prototype.dc.html`
  is authoritative (18 `data-screen-label` artboards ≈ 23 destinations once sheets, the
  dialog and the toast are counted; dark default plus a complete light token set). The older
  `SpendLens.dc.html` contributes four things the prototype dropped: empty state,
  scan-failed state, disabled button, and the price-history bar chart.
- **Behaviour truth** — the MVP technical specification in the request.

Design wins on scope; spec wins on behaviour. Every divergence is listed under
[Conflicts resolved](#conflicts-resolved).

---

## Binding decisions (from the user — do not revisit)

| # | Decision |
|---|---|
| 1 | **No dev/prod flavors.** One concrete `Env`, one `.env`, no `EnvHelper`, no `--dart-define=DARTENV`, no flavored `firebase_options`. `.env.example` ships **placeholders only**; the user fills real values. |
| 2 | **Both dark and light themes**, with the Settings Appearance toggle persisted. Overrides the global "dark-only" developer guidance — this project's specification differs. |
| 3 | **Seed all 12 categories.** The design's 6 keep their exact hues; the other 6 are derived by the design's own rule (*"same lightness and chroma, only hue changes"*). All 12 names go into all 7 ARB files. |
| 4 | **All 7 languages** (en, ro, ru, uk, es, de, fr), ported from `i18n.js`. |
| 5 | **iOS and Android are both first-class**, on devices with the appropriate hardware. Real OCR on both — Apple Vision on iOS, ML Kit on Android. **No fake is reachable in a shipped build.** Where hardware or engine support is missing: a toast telling the user, plus a Settings row stating scanning-support status directly. Fakes live only in `test/` and `integration_test/`. |

Decision 5 supersedes spec §3 ("iOS-first, do not spend development time on Android"). Code
stays platform-agnostic above the service boundary.

---

## Verified facts that changed the approach

Each of these was checked against the actual files, and each overturns a plausible assumption.

| Assumption | Reality | Consequence |
|---|---|---|
| The `project` Mason brick could bootstrap the app | It emits **`lib/src/{screens,bloc,models}`** with `AppRoutes` string constants — the old monolith layout, **architecturally incompatible** with `lib/core` + `lib/features` | **Do not use the `project` brick.** Hand-copy `core/` from sinergy_hub; only the `feature` brick is usable. |
| ru/uk are missing translation keys | **All 7 languages are complete.** The apparent gap was a counting artifact: the differing "keys" are the language-code labels (`en:`/`ro:`) and the word `Simulate` occurring *inside a translated value* ("Simulate: switch back to Free"), which ru/uk phrase without a colon | **Port 1:1, no backfill.** `Simulate:` is a prototype debug affordance and ships in neither. |
| The brick's dirs match the template | Brick emits **`domain/usecases/`**; sinergy_hub has both `use_cases/` and `usecases/` | Standardize on **`domain/use_cases/`** → a rename pass after **every** `mason make`, plus fixing the import in the generated `_injection.dart`. |
| `combine_latest_streams.dart` exists to copy | **It does not exist** in sinergy_hub | Write from scratch (`rxdart` is available). |
| The scaffold's platform ids are consistent | iOS is `com.hengell.spendlens.spendLens`, Android is `com.hengell.spend_lens.spend_lens` | **Unify to `com.hengell.spendlens`** before any signing / Firebase / Apphud work. |
| — | Project is **not a git repo**; `.gitignore` has **no `.env` entry** | Steps 0.1–0.2 below, before the bulk copy. |
| — | Template's `AppColorScheme` has 14 fields, its dark ctor is an all-white stub, `AppTextStyle.medium12` has `fontSize: 10`, `UiMessageService` is full of commented-out dead code, and two `of()` helpers throw Russian-language messages | Rewrite all of these; do not copy. |

Environment: Flutter **3.44.4** / Dart **3.12.2**. `google_mlkit_text_recognition` **0.17.1**
requires Dart ^3.12.0 / Flutter >=3.44.0 — compatible; its **Latin** recognizer covers
Romanian *and* English (spec §28). `apphud` **3.4.0** is the official SDK, so no custom
StoreKit (spec §10).

---

## Conflicts resolved

| Topic | Design | Spec | Resolution |
|---|---|---|---|
| Categories | 6, exact hues | 12 (§18) | **12** (decision 3): design's 6 verbatim + 6 derived by its own hue rule |
| Theme | dark + light + toggle | silent | **Both** (decision 2) |
| Platform | iOS mockups | iOS-only (§3) | **Both** (decision 5) |
| Tabs | 5 incl. **Stores** | no Stores screen | **5** — Stores is fully designed, so it is built |
| Price history | textual cross-store lines (v2); bar chart (v1) | required (§54–57) | **Both**: Stores-detail comparison lines *and* a dedicated price-history page with the v1 chart |
| Empty / scan-failed | v1 only | §65–66 require recoverable errors | **Carried forward from v1** — "never a dead end" |
| Currency | display-only suffix | §52 never mix currencies | **No conversion.** Display currency for totals; receipts keep their printed currency; never silently combine |
| Insight copy | hardcoded "32%" | §53 deterministic engine | **Parameterized** — engine emits (ARB key, params), never a rendered string |
| "this iPhone" | 4 strings | platform-agnostic | **`{device}` placeholder** resolved per platform |

**Deliberately not built:** the prototype's Period-sheet year stepper is styled disabled
(only Aug/Sep selectable) — it stays disabled until there is more than one year of data; and
the `Simulate:` premium toggle is a prototype debug control. The Settings `Privacy` row,
inert in the prototype, **does** get a real destination: plain-markdown policy from assets,
per the user's instruction.

---

## 1. Bootstrap

**Step 0 — before touching `lib/`**
1. `git init` and commit the bare scaffold, so the bulk copy is reviewable as one diff.
2. Add to `.gitignore`: `.env`, `ios/Runner/GoogleService-Info.plist`,
   `android/app/google-services.json`, `**/firebase_options.dart`. Commit `.env.example`
   with placeholders only.
3. Unify the bundle id to `com.hengell.spendlens` — `ios/Runner.xcodeproj/project.pbxproj`
   (incl. RunnerTests) and `android/app/build.gradle.kts` (`namespace` + `applicationId`).
4. Register the brick: `mason add -g feature --git-url git@github.com:h3ng3ll/init_flutter_bloc_shared_pref_monolith.git --git-path bricks/feature`
   (local fallback: `/Volumes/SSD/Programming/StudioProjects/init_flutter_bloc_shared_pref_monolith/bricks/feature`).

**Step 1 — copy `core/` verbatim** from `sinergy_hub/lib/core/`:
`bloc/app_observer.dart` · `failures/failure.dart` · `models/pageable/` ·
`routes/root_page/` · `routes/presentation/{error_message,error_navigation,loading_data}_widget.dart` ·
`services/logger_service.dart` · `utils/extensions/{bloc_ext,color_ext,date_time_ext,go_router_x,scroll_controller_ext,string_x}.dart` ·
`utils/converters/color_serializable.dart` · `widgets/padding/horizontal_padding.dart` ·
`widgets/btn/{custom_back_btn,custom_chip,custom_text_btn,translucent_btn,app_fab}.dart` ·
`widgets/{custom_app_bar,build_image,custom_text_field}.dart`

**Step 2 — copy then rewrite** (structure kept, content replaced): `app_colors.dart` (§4.1),
`app_color_scheme.dart` (§4.2, and drop the Russian strings), `app_text_theme.dart`,
`app_text_style.dart` (§4.3, fix `medium12`), `app_theme.dart` (`useMaterial3: true` on
**both** themes — template has `false` on dark), `app_gradients.dart`, `app_locale.dart`
(7 locales, start locale from persisted settings), `di/injection.dart` (strip all
Firestore/Functions/Database/Messaging registrations), `hive/{hive_adapters,hive_initializer}.dart`
(§3), `ui_message_service.dart` (**full rewrite**, §4.5), `permission_requester_service.dart`
(camera only), `image_service.dart` (drop Storage upload), `utils/env/env.dart` (**single
concrete `Env`**; delete `dev_env`, `prod_env`, `env_helper`), `main.dart`.

**Step 3 — do not copy.** Features `chat`, `matches`, `notifications`, `onboard_survey`,
`report`, `support`, `user_chat`, `user`, `home`, `settings`, `privacy_policy`,
`terms_of_use`. **All of `connectivity/`** — `connectivity_plus` is blacklisted, so there is
no `NoConnectionPage`, no connectivity redirect gate, no auto-redirect on reconnect; the app
is offline-first by design. Services `connectivity_service`, `audio_service`,
`local_notification_service`, `notification_tap_processor`, all `firebase/*` except auth,
`shared_preferences_database`. Utils `responsive_helper`, `shader_painter`, `app_config`,
`timestamp_convertor`. `app_shader.dart`. Widgets `build_user_avatar`, `custom_popup_menu`,
`inputs/*`.

`auth/` is **rewritten from reference, not copied**, fixing the template bugs (§8, M9).

**Hand-write vs brick:** `core/**` hand-copied (no brick covers it); the 13 feature
skeletons via `mason make feature`; domain entities, router, ARB files, and all the
OCR/parser/normalizer/analytics/export logic hand-written (the brick's model template is a
one-field stub and it explicitly does not touch router or l10n — it prints `.snippets/`
for those instead).

---

## 2. Dependencies

Add: `bloc`/`flutter_bloc`/`bloc_concurrency`, `get_it`, `dartz`, `rxdart`, `collection`,
`freezed_annotation`, `json_annotation`, `go_router`, `hive_ce`/`hive_ce_flutter`,
`path_provider`, `camera`, `google_mlkit_text_recognition`, `google_mlkit_document_scanner`,
`image`, `permission_handler`, `device_info_plus`, `share_plus`, `csv`, `file_picker`,
`pdf` + `printing` (the Analytics PDF chip), `apphud`, `firebase_core`/`firebase_auth`/
`firebase_crashlytics`, `google_sign_in`, `sign_in_with_apple`, `crypto`, `intl`, `gap`,
`flutter_svg`, `flutter_dotenv`, `package_info_plus`, `url_launcher`,
`flutter_native_splash`, `flutter_gen`.

Dev: `integration_test`, `build_runner`, `freezed`, `json_serializable`,
`go_router_builder`, `hive_ce_generator`, `flutter_gen_runner`, `flutter_launcher_icons`,
plus **`mocktail` and `bloc_test` in dev_dependencies** (the template wrongly has them in
`dependencies`).

Deliberately absent: **`connectivity_plus` (blacklisted)**, `fluttertoast` (replaced by the
custom overlay, §4.5), `cloud_firestore`, `cloud_functions`, `firebase_database`,
`firebase_storage`, `firebase_messaging`, `flutter_local_notifications`, `dio`,
`flutter_webrtc`, `audioplayers`, `responsive_framework`, `shared_preferences`,
`cached_network_image`, `lottie`, and the web-only sign-in packages.

`.env` is bundled as an asset for `[ios, android]` only.

---

## 3. Domain model and Hive

Eight freezed entities, each carrying the sync-ready triple `updatedAt`, `deletedAt?`,
`syncStatus` (spec §62 — fields only, **no sync logic**):

- **`Receipt`** — `storeId?`, `purchasedAt`, `printedTotal?`, `itemsTotal`, `discount?`,
  `currencyCode`, `categoryId?`, `imagePath?`, `itemIds`, `isReconciled`
- **`ReceiptItem`** — **`rawName` (never overwritten)**, `normalizedName`, `productId?`,
  `quantity`, `unit`, `unitPrice?`, `lineTotal`, `confidence`, `isLowConfidence`,
  `isManuallyAdded`, `lineIndex`
- **`Product`** — `normalizedName`, `displayName`, `aliases`, `defaultCategoryId?`, `defaultUnit`
- **`Store`** — `name`, `receiptAliases`, `type`
- **`Category`** — `name` (i18n key for built-ins), `colorHex`, `isBuiltIn`, `keywords`
- **`Expense`** — `amount`, `currencyCode`, `categoryId`, `storeId?`, `note?`, `occurredAt`, `source`
- **`PriceObservation`** — `productId`, `storeId?`, `receiptId`, `observedAt`,
  `comparableUnitPrice`, `unit`, `currencyCode`
- **`AppSettings`** — `currencyCode`, `localeCode`, `themeMode`, `onboardingCompleted`,
  `flashMode`, **`dataCleared`** (see §7)

Enums: `EUnit`, `EStoreType`, `EExpenseSource`, `EAppThemeMode`, `EFlashMode`, `ESyncStatus`.

Boxes (plural lowercase, per spec §20): `receipts`, `receipt_items`, `products`, `stores`,
`categories`, `expenses`, `price_observations`, `settings`.

**Three Hive rules that cause silent, launch-time-only failures:**
1. Every enum used as a model field must be imported **directly** in `hive_adapters.dart` —
   the generated `.g.dart` is a `part` file and inherits only that file's imports. First
   thing to check on any adapter error.
2. **No `@HiveField`** on models registered via `@GenerateAdapters` — the two mechanisms
   conflict and produce a broken `.g.dart`.
3. Generated model adapters take typeIds 0–7 in `hive_adapters.g.yaml` (**commit it**);
   manual enum adapters use **≥ 100**. A regeneration that renumbers corrupts stored data,
   so `test/core/hive/hive_type_ids_test.dart` pins every id as a literal.

**Receipt images live on the filesystem**, never as Hive values (spec §21):
`<Documents>/receipts/receipt_<id>.jpg`, owned by `core/services/receipt_image_store.dart`.
Store the **filename** and resolve the directory at read time — the Documents path changes
across iOS reinstalls.

---

## 4. Theme, tokens, localization

**4.1 `AppColors`** — raw hues only, as the template's `enum AppColors { name(Color(0x…)) }`
read via `.value`: the neutral/surface pairs, accent pairs (`#C4B5FD`/`#5B3FC4`,
`#8EE3F5`/`#0E7C8C`), gradient stops, warn pair, the **trend pair**, and the 12 category
hues. Translucent tokens (`--card`, `--line`, `--field`, `--bar`, `*-tint`) are **not** enum
entries — they are `withValues(alpha:)` expressions in the scheme factories, because one base
colour appears at five different alphas.

**4.2 `AppColorScheme`** — extend from 14 to ~26 semantic fields: `bg, card, cardSolid,
sheet, line, line2, field, field2, fieldDim, ink, sec, ter, dim, onAccent, bar, toastBg,
toastInk, accent, accent2, accentTint, accentLine, accent2Tint, warn, warnTint, trendUp,
trendDown`, with `.dark()` / `.light()` factories mapping 1:1 to the two verified CSS
strings, plus `categoryColor(id)`, `accentGradient`, and `glowLayers`.

> **"Trend text: amber when spending rose, green when it fell. Never red."** That is a design
> rule, so `trendUp` / `trendDown` are their own semantic pair — **never reuse `error`** for a
> spending increase.

Normalize the design's two gradient variants to one `accentGradient`
(135°, `#C4B5FD → #8EE3F5`); `#A78BFA` / `#67E8F9` survive only as the Food/Transport
category hues, where they genuinely are category colours.

**4.3 `AppTextStyle`** — named by design role, not by size: `hero44`, `heroCurrency22`,
`screenTitle28`, `detailAmount40`, `statValue20`, `headline17`, `headline17Semi`, `body17`,
`subhead15`, `footnote13`, `sectionLabel12`, `tabLabel10`, `amountInput32`.
`fontFamily: null` yields SF Pro on iOS and Roboto on Android. **Every amount style carries
`fontFeatures: [FontFeature.tabularFigures()]`** — the design mandates tabular numerals on
all amounts.

**4.4 Localization** — 7 ARB files in `lib/core/resources/translations/`. Nested `cat` /
`storeTypes` / `flash` maps flatten (`catFood`, `storeTypeSupermarket`, `flashAuto`); the
`onb` / `steps` / `months` / `monthsShort` arrays flatten to indexed keys. Beyond the
mechanical port, three real edits:

- **4 strings say "this iPhone"** (`deleteAllBody`, `onDevice`, `keepSafeBody`, `limitLocal`)
  → a `{device}` placeholder resolved from a localized device noun, in all 7 languages.
- **8 strings hardcode mocked values** → ARB placeholders: `ins2` (category + direction +
  percent), `insA1`, `insA2`, `tBackup` (filename), `tCsv` (row count), and the storage
  quotas in `tPremiumOn`/`tPremiumOff`/`toPremium`/`limitPremium`, which read from
  `AppLimits`.
- Already-correct templates — `ins1`, `ins3`, `insA3`, `itemsMatch`, `itemsDiffer`,
  `cheaperBy`, `cheapestOf`, `storeMeta`, `bought`, `periodRange` — port unchanged. That they
  are already parameterized is what proves spec §53's deterministic insights are achievable
  exactly as designed.

Two vocabularies must never merge: **UI labels** (ro: `Bon`, `Reducere`, `Cant.`, `Sumă`)
live in ARB; **printed-receipt keywords** the parser matches (`TOTAL DE PLATA`,
`SUMA DE PLATA`, `TOTAL GENERAL`, `SUMA`) live in the parser's own tables. Category display
shortening is a design rule: the key `Restaurants & Coffee` renders as `Restaurants` in
charts, legends and badges.

**4.5 Toast — custom overlay, not `fluttertoast`.** The designed toast (44 h pill, gradient
dot, 24 px backdrop blur, 2200 ms) is not renderable by `fluttertoast`.
`UiMessageService` keeps its exact static API (`showError`/`showInfo`/`showSuccess`) so the
project rule holds, but is reimplemented as a navigator-key-backed `OverlayEntry` rendering
`core/widgets/app_toast.dart`, with a single-entry queue. `SnackBar` / `ScaffoldMessenger`
remain forbidden, and the rewrite carries **no commented-out code**.

---

## 5. Features, routing, blocs

**13 slices** via `mason make feature`, in dependency order — `settings`, `category`,
`store`, `product`, `receipt`, `expense`, `home`, `analytics`, `history`, `scanner`,
`onboarding`, `backup`, `auth`. Run all with `--wire_di=true`, `--wire_hive=true` where a new
box appears, and `--run_build=false` on all but the last (one build_runner pass at the end
avoids partial-generation errors). `settings` and `category` must land and compile first —
every later repository depends on them. **After every `mason make`: the
`usecases/` → `use_cases/` rename plus its import fix.**

**Blocs — register only genuinely app-lifetime ones.** The brick registers none (pages build
their own); sinergy_hub registers several. Resolution: `SettingsBloc`, `CategoriesBloc`,
`StoresBloc`, `AuthBloc`, `SubscriptionBloc` are `registerLazySingleton` and dispatched from
`main()`. Everything else — including `HomeBloc`, `AnalyticsBloc`, `HistoryBloc` — is
`registerFactory`, built in `initState`, closed in `dispose`. Never dispatch the same
stream-based event from both `main()` and a screen's `initState`.

**Router** (`go_router_builder`, type-safe; route classes are the API — there is no
`AppRoutes` string-constants class): `SplashPageRoute` `/` and `OnboardingPageRoute`
`/onboarding` at top level, then a **5-branch `TypedStatefulShellRoute`** for Home,
Analytics, Stores, History, Settings.

Everything else is a **top-level push above the shell** (`parentNavigatorKey: rootNavigatorKey`):
`StoreDetailPageRoute`, `PriceHistoryPageRoute`, `ProfilePageRoute`, `RecordDetailPageRoute`,
`ReceiptPhotoPageRoute`, `ScannerPageRoute`, `ReviewPageRoute`, `EditReceiptPageRoute`,
`CashExpensePageRoute`, `CategoriesPageRoute`, `NewCategoryPageRoute`, `ChooseStorePageRoute`,
`NewStorePageRoute`, `PrivacyPageRoute`, `AboutPageRoute`.

Three routing decisions worth stating:
- **Tab-bar visibility is structural, not a flag.** The pill lives only in the shell's
  builder, so every root-level push covers it automatically — no `hideTabBar` boolean.
  `StoreDetailPageRoute` is therefore a top-level push, **not** a branch-2 child, because the
  design hides the bar when a store is selected.
- **The scanner's four sub-states are one route**, driven by
  `EScannerStatus {searching, detected, capturing, processing, failed}`.
- **The Period / Language / Currency sheets, the delete dialog and the toast are overlays**,
  not routes — `showModalBottomSheet` / `showDialog` / `OverlayEntry`.

`redirect` handles only Splash → Onboarding → Home, keyed on `onboardingCompleted`, kept as a
pure testable function. **No auth gate** (the app is fully usable anonymously, spec §8) and
**no connectivity gate**. All pushes share one `slideUpPage()` transition helper matching the
design's `slUp` timings.

---

## 6. Native, capability detection, and the core pipeline

**One channel contract, `com.hengell.spendlens/ocr`, identical on both platforms** so Dart
never branches above the service boundary: `isAvailable`, `recognizeText`,
`detectReceiptRect`, `cropPerspective`. Bounding boxes are **required** — never collapse OCR
output to a single `String` (spec §27). If detection returns null, OCR proceeds on the
original image: **detection failure never blocks OCR** (spec §24).

- **iOS** — Swift under `ios/Runner/Ocr/`: `VNRecognizeTextRequest`
  (`recognitionLanguages ["ro-RO","en-US"]`, `.accurate`, language correction on) and
  `VNDetectRectanglesRequest` + `CIPerspectiveCorrection`. iOS 13 baseline is sufficient.
  `NSCameraUsageDescription` explains receipt scanning; camera only.
- **Android** — OCR through `google_mlkit_text_recognition` (Latin recognizer covers ro + en,
  so no Kotlin needed for OCR); Kotlin only for the headless rect detection and crop.
  Manifest declares `CAMERA`, `<uses-feature ... required="false">` so camera-less tablets can
  still install for cash-only use, and **`com.google.mlkit.vision.DEPENDENCIES = ocr` to
  bundle the model** — a downloaded model would fail on a first launch in airplane mode,
  which spec §64 forbids. `minSdk = 21` explicitly.

**`IScanCapabilityService`** lives in `core/services/scan_capability/` (core, because two
unrelated consumers read it) and returns
`EScanCapability {supported, noCamera, ocrUnavailable, permissionDenied, permissionPermanentlyDenied}`.
Both consumers read that one source: tapping **Scan Receipt** when not `supported` shows a
per-state toast and never navigates; the **Settings row** states the status directly, with an
"Open Settings" action on the permanent denial. This makes "unsupported" a **hardware and
permission** condition, not a platform one — a real Android phone reports `supported`, an
iOS Simulator reports `ocrUnavailable`.

**Pipeline placement** — platform-touching or cross-feature code goes in `core/services/`;
pure domain logic goes in the owning feature's `domain/`, as pure functions so tests need no
mocks:

- **OCR** — `core/services/ocr/`: `OcrService`, `OcrTextBlock`, `IReceiptDetector`, and the
  channel-backed implementations. Both platforms are real.
- **Parser** — `features/receipt/domain/parser/`, decomposed into 8 independently testable
  stages: text normalizer, line grouper, keyword detector, price extractor, quantity
  extractor, product-candidate builder, store resolver, date extractor. **Deterministic, no
  LLM** (spec §33). The total comes from **semantic keywords, never "the largest or last
  number"** (§35), and an ambiguous date returns null rather than silently swapping day and
  month (§36).
- **Normalizer** — `features/product/domain/normalizer/`: cleanup → abbreviation expansion →
  exact match → fuzzy match → create new. **Conservative**: a near-miss creates a new product,
  because false merges are worse than duplicates (§42).
- **Analytics** — `features/analytics/domain/`: calculator, insight generator (emits
  **(ARB key, params)** pairs, never rendered strings, so it stays locale-independent and
  testable), price-history calculator, and a currency guard that refuses to combine
  currencies silently. All computed from Expenses + ReceiptItems, never stored as source of
  truth (§49).
- **Receipt rules** — reconciler (warns on mismatch but **always allows saving**, §45) and
  duplicate detector (warns, allows continue, **never auto-deletes**, §46).
- **Backup** — `features/backup/`: canonical JSON with `schemaVersion`, CSV, share sheet;
  import validates the schema and migrates, **never blind-overwrites** (§61).
- **Subscription** — `core/services/subscription/`: `SubscriptionRepository` over Apphud
  only, with `core/utils/app_limits.dart` holding `freeReceiptLimit = 50` and the quota
  labels in **one place**.
- **`core/utils/combine_latest_streams.dart`** must be written: multiple repositories →
  **one** combined stream plus a **named snapshot class** (e.g. `HomeSnapshot`), consumed by a
  single `await emit.forEach(...)`. Never parallel `emit.forEach`, never `stream.listen`,
  never Dart records, and **never `unawaited(...)` in `lib/`**.

---

## 7. Delete-all needs a persisted flag

The design's `confirmDeleteAll` zeroes totals, empties transactions, clears custom stores and
categories, and **never re-seeds** — which matches the global contract. But the prototype has
no persistence, so it cannot show the part that matters: **the emptiness must survive a
restart.** So:

- `AppSettings.dataCleared` is persisted;
- the seed guard checks `isEmpty` **AND** `!dataCleared` — seeding on emptiness alone would
  silently repopulate behind the user;
- delete-all clears, sets the flag, resets transient view state, and does not re-seed;
- any restore path sets the flag back to `false`;
- the truly-empty state uses the dedicated v1 empty copy — **distinct** from the
  filter/search "no match" copy — and hides the now-useless search field and segmented filter;
- the destructive control uses the `warn` token, never a raw colour, and always routes through
  the confirm dialog.

---

## 8. The scanner's timings are a simulation, not a specification

The prototype drives the scanner on a fixed timer chain (1800 ms → detected, 3300 →
capturing, 3800 → processing, 4900/6000/6900 → step ticks, 7600 → Review). **Do not port
those as behaviour.** Each transition is driven by a real event: detection when the detector
returns bounds, capture on auto-capture or shutter tap, each of the four processing steps when
that pipeline stage actually completes (detect/crop → OCR → parse+normalize → price lookup),
and Review when the `ParsedReceipt` is ready. The four labels therefore report genuine
progress instead of a fake bar.

Only the **animations** keep their design durations (slPulse 2.2 s, slScan 2.4 s, slBreathe
1.4 s, slSpin 1 s, slFlash 120 ms, slUp .25–.4 s) — those are presentation, and the capture
flash stays fixed because it is a shutter effect, not a task.

If OCR yields nothing usable, show the v1 scan-failed sheet (three tips + **Try Again** +
**Enter Manually**) and **never discard the captured image** (§66).

---

## 9. Template bugs to fix rather than copy

1. `google_sign_in_service_mobile.dart` passes `env.webPushCertificate()` as
   `serverClientId` — **the wrong value entirely**.
2. The Apple iOS nonce is generated and then **discarded**, with both `nonce:` params
   commented out — a replay-protection gap. Wire it up.
3. `_androidCall()` throws while its caller unconditionally wraps in `Left(...)`; return
   `Right(Failure)` instead.
4. Dual `Failure` / `Exceptions` hierarchies (Google uses one, Apple the other) → standardize
   on **`Failure`**.
5. Directory typos `domain/repostories/`, `uknown_failure.dart`, and `use_cases/` vs
   `usecases/` → standardize.
6. `mocktail` / `bloc_test` in `dependencies` → dev_dependencies.
7. `AppTextStyle.medium12` has `fontSize: 10`; the dark `AppColorScheme` is an all-white stub.
8. Russian-language exception strings in `AppColorScheme.of` / `AppTextTheme.of`.
9. `_state_ext.dart` only ~25% adopted → standardize from day one, with a getter per enum
   value including **`isFailed`**.
10. `.env` and real client IDs committed → gitignore `.env`, commit only `.env.example`.

---

## 10. Build phasing

Each milestone ends `flutter analyze` clean and running.

| M | Deliverable |
|---|---|
| **M1** | Skeleton boots: steps 0–2, single `Env`, pubspec, themed blank screen |
| **M2** | Tokens + all 7 ARB files; Language and Currency sheets switch and persist |
| **M3** | Data layer: 8 entities + 6 enums + 8 boxes; build_runner; typeIds pinned; 12 categories seeded |
| **M4** | 13 brick slices + rename pass + one build_runner; DI resolves |
| **M5** | **Manual-entry app, zero native code** — Home, Analytics, Stores(+detail), History, Settings, Profile, Cash expense, all pickers, Record detail, sheets, dialog, empty states, custom toast, 5-tab pill |
| **M6** | Analytics engine + price-history page and chart |
| **M7** | `IScanCapabilityService` both platforms, Settings status row, unsupported toast, camera preview, Scanner with all 4 sub-states and animations |
| **M8** | OCR + the 8 parser stages + normalizer + Review + Edit receipt + reconciliation + duplicate detection + scan-failed state |
| **M9** | Export/import, Google + Apple sign-in **rewritten with bugs 1–5 fixed**, Apphud + `AppLimits` |
| **M10** | Splash, onboarding, transitions, disabled states, all regression gates, icons and native splash |

**M5 is the key de-risking step**: it is a fully usable expense tracker with no native code,
so everything afterwards is additive. **M8 is the only milestone that can slip on quality
rather than effort**, because parser accuracy depends on real-world OCR noise.

**Ordering constraints.** Run `build_runner --delete-conflicting-outputs` after *every* model
change — freezed, hive_ce and go_router_builder all generate, and a stale `.g.dart` produces
misleading errors. `go_router_builder` needs pages that compile, so stub pages before
generating routes. The `usecases/` rename must follow every `mason make`. Expect Gradle
friction on the first Android build after M7/M8.

---

## 11. Verification

- **Parser** — per-stage unit tests over recorded `OcrTextBlock` fixtures: all 5 total
  keywords; a receipt whose largest number is a barcode still resolves the right total; the
  5 price formats; 4 date formats plus an ambiguous case returning null; quantity and weight
  lines; two-column grouping.
- **Normalizer** — whitespace, OCR confusions, abbreviations, unit normalization
  (`1.2 kg @ 104 → 86.67/kg`, `500 g @ 40 → 80/kg`), and a fuzzy near-miss that **creates
  rather than merges**.
- **Analytics** — monthly totals, previous-month comparison, % change, average, per-category
  share and count, cash-vs-receipt split; insights return the right **key + params**
  deterministically; price history reproduces the design's `18.50 → 22.90 = +23.8%`; mixed
  currencies never combine.
- **Backup** — JSON round-trip, CSV escaping and row count, and schema validation rejecting
  or migrating missing/old/future `schemaVersion`.
- **The hardest invariant** — `receipt_item_raw_name_test.dart`: `rawName` survives
  normalization, rename, and edit.
- **Blocs** — one `bloc_test` each, asserting the `_state_ext` booleans flip and `isFailed`
  is reachable.
- **Regression gates** — `connectivity_plus` absent from pubspec and lock; no
  `SnackBar`/`ScaffoldMessenger` in `lib/`; no `unawaited(` in `lib/`; no
  `addPostFrameCallback`/`Future.delayed`/`Future.microtask` inside `build()`; **no `Fake*Ocr`
  symbol anywhere under `lib/`** (this is what makes decision 5 structural, not aspirational);
  every `*_state.dart` has a sibling `_state_ext.dart`; Hive typeIds pinned; no PII in
  logging calls.
- **Fakes are confined** to `test/fakes/` and overridden into `integration_test/mocks/test_di.dart`
  *after* `initDependencies()`, mirroring the template's pattern. Fixtures are recorded from
  **real receipts**, so the parser is tuned against real OCR noise.
- **Manual**: run in airplane mode and confirm scan → parse → save → analytics → export all
  work (spec §64).

---

## 12. Needs to come from the user

| Item | Blocks | Note |
|---|---|---|
| **20–50 real receipt photos** (Moldovan/Romanian stores) | **M8 parser tuning** | The single highest-value input — worth gathering during M1, not M8, since parser accuracy is the one thing effort alone cannot fix |
| Apphud SDK key | M9 | into `.env` |
| Firebase project + `GoogleService-Info.plist` / `google-services.json` | M9 | Crashlytics + auth only — no Firestore, no image upload |
| Google OAuth `serverClientId` (iOS + Android, plus Android SHA-1) | M9 | must be the real client id, not the push certificate (bug 1) |
| Apple Developer team + Sign-In-with-Apple capability | M9 | provisioning profile |
| App icon + splash assets | M10 | the `uploads/` renders are light-theme marketing images, not app assets |
| Sign-off on the 6 derived category hues | M3 | proposed via the design's own "same lightness and chroma" rule |
| Privacy + About copy | M10 | design shows the rows, not the text; plain markdown from assets |
