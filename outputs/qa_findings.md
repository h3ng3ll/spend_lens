# QA Findings — SpendLens (Round 1, deferred whole-app QA)

Agent: adb-tester · Mode: full-pipeline · Round 1
Emulator: emulator-5554 (1080x2424 @420dpi, font_scale 1.0, night=no — unchanged by QA)

## B-1
Severity: High
Symptom: The app cannot be built or installed on Android at all. Gradle fails at
`:app:processDebugMainManifest` with a manifest-merger error, so no APK is produced
and every one of the 22 routes is unreachable at runtime.
Where: android/app/build.gradle.kts:28 (`minSdk`), with `apphud: ^3.4.0` (pubspec.yaml:57)
Evidence (verbatim):
  uses-sdk:minSdkVersion 24 cannot be smaller than version 26 declared in
  library [:apphud] ... Manifest merger failed
  Flutter Fix: "The plugin apphud requires a higher Android SDK version ...
  minSdkVersion 26"
Reproduced independently twice: once via the live-session runner (`ensure=failed`)
and once via a clean `flutter build apk --debug` (BUILD FAILED in 13s).
Cause: implementation
Root cause: `minSdk` is below Apphud's required 26. The committed value is
`minSdk = 21` (HEAD); the uncommitted working tree changes it to
`minSdk = flutter.minSdkVersion` (= 24). BOTH are < 26, so the break exists in the
committed tree and in the working tree alike. The adjacent code comment claims the
value is "Explicit ... never left to `flutter.minSdkVersion`'s default", which is
the opposite of what the working-tree line now does.
Verification that this is the ONLY build blocker: setting `minSdk = 26` as a
temporary QA probe produced `✓ Built build/app/outputs/flutter-apk/app-debug.apk`
in 43s. The probe was reverted; `git diff` confirms the file is back to its
pre-QA working-tree state.
Why no test caught it: no test under test/ references `minSdk` or `build.gradle`,
so the 207-test suite passes green against an app that cannot be installed.
Fix applied by Developer: (pending)
Potentially reusable: YES

## B-2
Severity: Medium
Symptom: A "Coming Soon"-class placeholder string is shipped in user-facing UI.
Opening a record and tapping Edit shows the toast "Editing arrives in a later
update." — a teaser for an unimplemented feature rather than a working control or
an honest empty state.
Where: lib/features/history/presentation/pages/record_detail_page/record_detail_page.dart:65
  `UiMessageService.showInfo(lo.editComingSoon);`
Evidence: 4 `*ComingSoon` keys exist in all 7 ARB locales
(`signInComingSoon`, `exportComingSoon`, `scanComingSoon`, `editComingSoon`,
e.g. app_en.arb:168,169,710,736). Of these, `editComingSoon` has a live caller.
Cause: implementation
Root cause: The Edit affordance on Record Detail is wired to a placeholder toast
instead of either an implemented edit flow or the removal of the control.
Fix applied by Developer: (pending)
Potentially reusable: NO (project-specific instance of a known chronic pattern)

## B-3
Severity: Low
Symptom: Three `*ComingSoon` localization keys exist in all 7 locales but have
zero callers — dead placeholder strings that remain available to be wired up.
Where: lib/core/resources/translations/app_*.arb —
`signInComingSoon`, `exportComingSoon`, `scanComingSoon`
Evidence: grep for each key across lib/ excluding /gen/ and /translations/
returns no call site (only `editComingSoon` is called).
Cause: implementation
Root cause: Placeholder copy authored for features that later got real capability
states (e.g. the scanner's per-state `scanStatus*`/`scanUnsupported*` keys), with
the superseded strings left behind.
Fix applied by Developer: (pending)
Potentially reusable: NO

## B-4
Severity: Medium
Symptom: Count + noun strings are concatenated with no ICU plural, so
non-English locales render grammatically wrong text for most counts. In Russian
`lo.items(1)` renders "1 позиций" (should be "1 позиция") and `lo.items(3)`
renders "3 позиций" (should be "3 позиции").
Where: lib/core/resources/translations/app_*.arb — `items`, `catUsed`,
`cheapestOf`, `storeMeta`, `bought`, `deleteAllBody`, `tCsv`, `tImported`.
Call sites include:
  review_page.dart:361            `lo.items(state.items.length)`
  store_product_row.dart:73       `lo.cheapestOf(result.params[0] as int)`
  store_list_row.dart:46          `lo.storeMeta(visits, 0)`
Evidence: the ARB files contain ZERO ICU plural constructs — `grep -c 'plural,'
app_en.arb` returns 0 across all 338 keys. Russian and Ukrainian need 3 plural
forms; Romanian needs 3; French/Spanish/German need 2.
Cause: implementation
Root cause: `{n} <noun>` templating used instead of `{n, plural, ...}`.
A partial hand-rolled workaround exists (`purchase1` / `purchaseN` in all 7
locales) but it has NO callers, so even the two-form fallback is unused.
Fix applied by Developer: (pending)
Potentially reusable: YES

## B-5
Severity: Low
Symptom: The application name is rendered in user-facing UI text, and it is shown
for the wrong condition. An unexpected/unknown backup-import failure displays
"That file isn't a SpendLens backup." — which both leaks the app name on screen
and misreports an unknown error as a malformed-file error.
Where: lib/features/auth/presentation/pages/profile_page/profile_page.dart:120-121
  `EBackupError.malformed => lo.importMalformed,`
  `EBackupError.unexpected || EBackupError.none => lo.importMalformed,`
  string: app_en.arb:812 "That file isn't a SpendLens backup." (+ 6 locales)
Cause: implementation
Root cause: `EBackupError.unexpected` and `.none` are folded into the `malformed`
message, so a genuine unexpected failure is mislabelled; that shared message is
also the only user-facing string in the app containing the product name.
Fix applied by Developer: (pending)
Potentially reusable: NO

## B-6
Severity: Low
Symptom: The Profile screen has no editable profile data. The 88dp circle that
reads as an avatar is a static icon with no tap target, and there is no way to set
or remove an avatar and no editable display name.
Where: lib/features/auth/presentation/pages/profile_page/widgets/profile_identity_column.dart:39-51
  `child: AppSvgIcon(asset: AppIcons.user, color: scheme.accent, size: 40.0)`
  lib/features/auth/presentation/pages/profile_page/widgets/profile_body.dart:53-77
  (children: header, identity, sign-in card, storage, export/import — no edit control)
Evidence: `image_picker` is absent from pubspec.yaml (only `camera` and
`file_picker` are present, used by the scanner and backup import respectively);
grep for `editProfile|edit_profile|EditProfile` across lib/ returns zero hits;
there is no `/profile/edit` route in the 22-route inventory.
Cause: design-spec (scope) — needs triage, NOT auto-fixed by QA
Root cause: `~/.claude/rules/edit_profile_screen_rules.md` requires that an avatar
can always be SET and REMOVED (remove shown only when an avatar exists, staged
until Save). This app ships no editable avatar surface at all, so that contract
has nothing to bind to. This is reported as a SCOPE question, not a regression:
whether SpendLens should offer profile editing is a design-source decision.
Note the identity circle currently reads as an affordance while being inert.
Fix applied by Developer: (pending triage decision)
Potentially reusable: NO

## O-1
- **Severity:** High (launch blocker)
- **Signature:** `sig:unbounded-third-party-sdk-await-before-runapp-hangs-first-frame`
- **Stage attributed:** Developer (M9 subscription wiring)
- **Found by:** Orchestrator, on-device verification (`emulator-5554`), NOT by any test
- **Symptom:** App hangs on the Android native splash indefinitely. No crash, no Dart
  exception, clean logcat. `dumpsys SurfaceFlinger --list` shows
  `Splash Screen <pkg> ... z=30000` still on top at 20s+ while Flutter's SurfaceView
  exists underneath. Process alive (`pidof` returns a pid); its last log activity is the
  SDK's failed network call.
- **Root cause:** `main()` did `await subscriptionRepository.init()` before `runApp()`.
  Apphud's `start()` future **never settles** when the API key is syntactically valid but
  rejected — a placeholder key answers HTTP 401 and the SDK neither completes nor throws.
  The guard was `if (env.apphudApiKey.isEmpty) return;` — it checked the wrong condition:
  **"configured" is not the same as "non-empty"**.
- **Fix:** bound the call — `await Apphud.start(...).timeout(Duration(seconds: 5))` with
  an explicit `on TimeoutException` branch that disables subscriptions. A third-party SDK
  may never gate the first frame.
- **Verified:** rebuilt, `pm clear`, relaunched; native splash layer count 0 and
  onboarding step 1 paints. Screenshot, not a code read.
- **Why cross-project:** any app that awaits a vendor SDK's init before `runApp` inherits
  this. Placeholder credentials are the normal state during development, so the hang
  appears exactly when the app is least able to explain itself.

## O-2
- **Severity:** High (launch blocker)
- **Signature:** `sig:lifecycle-call-parked-on-a-route-the-router-redirects-away-from`
- **Stage attributed:** Developer (M10 splash), missed by the Orchestrator's own M7/M10 review
- **Found by:** Orchestrator, on-device verification
- **Symptom:** Identical to O-1 — stuck on the native splash, clean logcat. Present even
  after O-1 was fixed; the two masked each other.
- **Root cause:** `FlutterNativeSplash.remove()` lived in `SplashPage.initState()`, and
  `resolveRedirect` redirects `/` away **synchronously on the first evaluation**, so
  `SplashPage` is never built and `initState` never runs. `preserve()` was therefore never
  undone. The screen was structurally unreachable, not occasionally skipped.
- **Fix:** deleted the unreachable screen; `remove()` moved to the ROOT widget's
  `initState()` — the earliest point guaranteed to run on every cold start. The router
  remains the single navigation authority.
- ⛔ **Why this matters beyond the bug — the gate was GREEN.**
  `splash_native_remove_test.dart` asserted `remove()` appears exactly once, in
  `initState`, first after `super.initState()`. All true. All useless: the assertion
  covered a code path that could never execute. **A passing gate over unreachable code
  proves nothing.** The gate was rewritten to assert the reachable contract.
- **Why cross-project:** any codebase with a router-level redirect plus a
  lifecycle-critical call parked on the redirected-away screen. The greppable-but-dead
  pattern is what makes it survive review.

## O-3
- **Severity:** High (build blocker)
- **Signature:** `sig:minsdk-below-a-dependency-floor-fails-manifest-merge-and-no-test-covers-it`
- **Stage attributed:** design spec (§6 specifies 21) + Developer (M7 left it explicit at 21)
- **Symptom:** `flutter build apk` fails: `uses-sdk:minSdkVersion 24 cannot be smaller
  than version 26 declared in library [:apphud]`. App cannot be installed, so **every**
  runtime check is uncovered.
- **Root cause:** the spec's `minSdk = 21` predates its own Apphud decision and is
  unachievable with it. Per-dependency floors: apphud 3.4.0 → 26, camera_android_camerax
  → 23, mlkit text recognition → 21. Highest floor wins.
- ⛔ **Pipeline gap:** a 207-green suite coexisted with an app that could not be
  installed, because **no test referenced `build.gradle` or `minSdk`**. Closed by
  `test/regression/android_min_sdk_test.dart`, which was verified to FAIL at minSdk=21
  rather than pass vacuously.
- **Why cross-project:** every Flutter app with a native SDK dependency; the spec-vs-
  dependency conflict is generic, and unit suites never compile the Android manifest.

---

# QA Findings — SpendLens (Round 2, FINAL QA round)

Agent: adb-tester · Mode: full-pipeline · Round 2 (re-verify + runtime-only chronics)
Emulator: emulator-5554 · HEAD 4a20ddb
Device state at entry AND exit: font_scale 1.0, night=no, no wm size/density override
(set to 2.0 during check #4, restored and read back as 1.0 — verified).

## R2-1
Severity: High
Symptom: At `font_scale 2.0` the bottom navigation bar overflows on EVERY tab —
"BOTTOM OVERFLOWED BY 20 PIXELS" stripes render under the bar, and tab labels are
truncated ("Analytic", "Setting").
Where: lib/core/routes/root_page/root_page.dart:68 — `AppContainer(height: 64.0)`
Evidence: screencaps fs_home/fs_analytics/fs_history/fs_settings.png all show the
overflow banner. The nav item is a `Column` (icon + label, `spacing: 4.0`) in
lib/core/routes/root_page/widgets/shell_tab_item.dart:39-41 with no maxLines,
no ellipsis and no textScaler clamp, inside a hard 64.0dp box.
Cause: implementation
Root cause: fixed-height container hosting text that scales with the OS font
setting, with no clamp on either side.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-2
Severity: High
Symptom: At `font_scale 2.0` the Settings "Scanning" row overflows horizontally —
"RIGHT OVERFLOWED BY 24 PIXELS" — and the label degenerates to one character per
line ("S/c/a/n/n/i/n/g"), with the card clipped by the nav bar.
Where: Settings → Scanning row (lib/features/settings/.../settings_page/widgets/)
Evidence: fs_settings.png. Same screen at font_scale 1.0 renders correctly.
Cause: implementation
Root cause: a label/value Row with no flex budget for the label; the value text
("Camera permission needed") takes its intrinsic width and starves the label.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-3
Severity: Medium
Symptom: The Settings "Scanning" label wraps mid-word to "Сканир / ование" in
Russian at NORMAL font_scale 1.0 — no OS scaling needed.
Where: Settings → Scanning row, ru locale
Evidence: lang_ru.png and deleted_settings.png, both at font_scale 1.0.
Cause: implementation
Root cause: same narrow label column as R2-2; longer localized strings expose it
without any accessibility setting involved.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-4
Severity: Medium
Symptom: Every root bottom-nav tab that uses `CustomAppBar` renders a back arrow
(History shows "← History"). A root tab has nothing to pop. Tapping it does not go
"back" — it jumps to an unrelated tab (observed: History's back arrow navigated to
Settings).
Where: lib/core/widgets/custom_app_bar.dart:56-70 —
  `leading: ... leading ?? InkWell(onTap: context.goBack, ...)`
Evidence: tab_history.png shows the arrow; hist_backarrow.png shows the resulting
Settings screen. Home/Analytics/Stores do not use CustomAppBar and have no arrow.
Cause: implementation
Root cause: CustomAppBar unconditionally synthesizes a back affordance; it has no
`automaticallyImplyLeading`-style guard for roots of a StatefulShellRoute branch.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-5
Severity: Medium
Symptom: Settings → Language row shows the value "Language" instead of the current
language. The language SHEET's first option is likewise labelled "Language" rather
than "System default".
Where: lib/features/settings/presentation/pages/settings_page/settings_page.dart:195
  `languageLabel: state.settings.localeCode == null ? lo.language : ...`
  lib/features/settings/presentation/sheets/language_sheet/language_sheet.dart:37
  `LanguageOption(code: null, label: lo.language)`
Evidence: tab_settings.png ("Language  Language ›"), lang_sheet.png.
Selecting Русский correctly renders "Язык  Русский", confirming the defect is
specific to the null/system default state.
Cause: implementation
Root cause: the row's VALUE falls back to the row's own LABEL string when no
explicit locale is stored. There is no "System default" key.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-6
Severity: Medium
Symptom: The Appearance Dark/Light control does not select the tapped segment. It
is one GestureDetector over both segments with a single toggle callback, so tapping
"Light" flips to whatever the other state is. Additionally, with the default
`EAppThemeMode.system`, "Dark" is highlighted while the app renders in LIGHT.
Where: lib/core/widgets/appearance_toggle.dart:53-56 (single GestureDetector)
  lib/features/settings/.../widgets/preferences_card.dart:39
  `final isDark = themeMode != EAppThemeMode.light;`
Evidence: tab_settings.png — light-rendered screen with "Dark" highlighted.
theme_light.png — tapped "Light", got dark.
Cause: implementation
Root cause: a 2-segment selector wired as a binary toggle, plus a tri-state enum
collapsed to a boolean that maps `system` onto `dark`.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-7
Severity: Medium
Symptom: Home's primary CTA "Scan your first receipt" is a silent no-op on a device
without an available camera — no navigation, no toast, no dialog, no permission
prompt. The brief requires a per-state message naming the real reason.
Where: Home empty-state CTA → scanner entry
Evidence: scanner.png and scanner_toast.png, captured 2s after the tap; screen
unchanged. logcat filtered for flutter/camera/permission over the tap window
returned no output — no exception, but also no user-visible feedback.
Settings' own Scanning row DOES correctly read "Camera permission needed", so the
capability is known to the app and simply is not surfaced at the CTA.
Cause: implementation
Root cause: the CTA's guard returns early without dispatching the user-facing
message the Settings row already computes.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-8
Severity: Low
Symptom: Onboarding step 2 renders the hardcoded platform name "iPhone" on an
Android build: "Text is read on your iPhone".
Where: lib/core/resources/translations/app_en.arb:121 — "onb1Point1"
Evidence: t1_onb2.png (Android emulator-5554).
Cause: implementation (copy authored for the iOS target only)
Root cause: a platform-specific noun baked into a shared localization string.
Fix applied by Developer: (pending)
Potentially reusable: YES

## R2-9
Severity: Low
Symptom: After "Delete all data" the Categories count is 0 and there is NO
restore/reset-to-samples path. The Categories screen simultaneously states
"Built-in categories cannot be deleted" while all 12 built-ins are gone.
Where: Settings → Categories (empty), footer copy
Evidence: deleted_settings.png (Категории 0), categories.png.
`delete_all_records_rules.md` rule 7 requires a reachable restore path. A manual
"New category" add exists, so the user is not fully stranded — hence Low, not High.
Cause: implementation
Root cause: the delete-all handler clears the store and sets `dataCleared: true`
(both correct per contract) but no reset handler exists to set it back to false.
Fix applied by Developer: (pending)
Potentially reusable: NO

## R2-10
Severity: Medium
Symptom: B-4 (ICU plurals) is only PARTIALLY fixed. 5 of the 8 keys Round 1 named
were converted; three still concatenate a count with a fixed noun, reproducing the
exact recorded defect for a count of 1 in Russian/Ukrainian.
Where: lib/core/resources/translations/app_*.arb
  catUsed   => "Своя · {n} записей"      (n=1 reads "1 записей", want "1 запись")
  storeMeta => "{v} визитов · {p} товаров" (two un-pluralized counts)
  bought    => "Куплено {n}×"             (numeric suffix; lower risk)
Evidence: `grep -c 'plural,'` returns 6 in every locale file, not 8. Converted:
items, cheapestOf, deleteAllBody, tCsv, tImported. Verified `items` now yields
"1 позиция" correctly, and the delete-all sheet rendered "12 записей" correctly.
Cause: implementation
Root cause: the plural conversion pass missed the two multi-count keys and catUsed.
Fix applied by Developer: (pending)
Potentially reusable: YES

---

# TRIAGE REPORT — Round 2 (findings-triage, Step 3a)

Agent: findings-triage · Mode: full-pipeline · Round 2 (FINAL — no Round 3)
Scope authority: `instructions/design_spendlens.md` + local design source
`assets/SpendLens design system/SpendLens Prototype.dc.html` (authoritative).
No design MCP in this project.
FAQ: `~/.claude/agent-memory/qa-faq/INDEX.tsv` read once — 1 entry
(`screenshot-capture-path`), no hit on any finding below.

Findings received: 19 blocks · 9 already-resolved (record only) · **10 open, triaged.**

## Already resolved — NOT re-routed
B-1/O-3, O-1, O-2, B-2, B-3, B-5 — fixed and device-verified. Retained as the
record for `qa-analytics` (Step 6) and `knowledge-extractor` (Step 7).
B-4 is **superseded by R2-10** (partial fix); the residue is triaged there.

## CODE BUG → Developer (8)

1. **R2-1** [`root_page.dart:68` + `shell_tab_item.dart:39-41`] nav bar overflows
   20px on every tab at font_scale 2.0 — cause: implementation. Verified both
   sites: hard `AppContainer(height: 64.0)` hosting an unclamped `Column`
   (icon 22.0 + `spacing: 4.0` + `Text` with no `maxLines`, no `overflow`, no
   `textScaler` clamp). ⛔ `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`
   — ledger's oldest chronic, 11/16 sessions. **PER-SITE terminal state required.**
2. **R2-2** [`settings_page/widgets/scan_capability_row.dart`] Scanning row
   overflows right 24px at font_scale 2.0 — cause: implementation. Label column
   has no flex budget; the value text takes intrinsic width and starves it.
   Same chronic signature as R2-1.
3. **R2-3** [same widget, ru locale] "Сканир/ование" wraps mid-word at NORMAL
   font_scale 1.0 — cause: implementation. Same root cause as R2-2, exposed by
   string length alone with no accessibility setting involved. Fixing R2-2
   properly (flex budget on the label) should resolve this; **verify separately**
   — a fix that only clamps at scale 2.0 leaves R2-3 live.
4. **R2-4** [`custom_app_bar.dart:56-70`] back arrow on root tab screens jumps to
   an unrelated tab — cause: implementation. Confirmed: `leading` falls back
   unconditionally to `InkWell(onTap: context.goBack)` with no
   `automaticallyImplyLeading`-style guard for a `StatefulShellRoute` branch root.
   A root tab has nothing to pop, so `goBack` walks to a foreign branch.
5. **R2-5** [`settings_page.dart:195`, `language_sheet.dart:37`] Language row and
   sheet show "Language" as the current value when locale is null — cause:
   implementation. The row's VALUE falls back to the row's own LABEL. Needs a new
   "System default" ARB key in all 7 locales (a string, not a flow).
6. **R2-6** [`appearance_toggle.dart:53-56`, `preferences_card.dart:39`] Appearance
   toggle does not select the tapped segment; `system` maps to `dark` — cause:
   implementation. **The design source settles the semantics** (Prototype line
   781): `themeOpts` gives EACH segment its own `pick` setting an ABSOLUTE value
   (`theme:'dark'` / `theme:'light'`) — not a toggle. The app instead wraps both
   segments in ONE `GestureDetector(onTap: onToggle)` and collapses the tri-state
   enum with `isDark = themeMode != EAppThemeMode.light`.
   ⚠️ Binding decision 2 (spec line 34) is AUTHORITATIVE: this app has BOTH themes
   plus a persisted toggle, deliberately overriding the global dark-only guidance.
   **Do NOT "fix" this by removing the toggle or the light theme.** Per-segment
   absolute selection; decide `system` explicitly (resolve against platform
   brightness — never silently onto `dark`).
   Related: `db:custom-switch-toggle-knob-fills-track-wrong-state-colors`.
7. **R2-9** [`delete_all_records_use_case.dart`] delete-all wipes the 12 built-in
   categories — cause: implementation. ⚠️ **RE-DIAGNOSED — this is not a missing
   restore flow.** The design source (Prototype line 901) `confirmDeleteAll`
   clears only `customCats`, and `allCats = [...defaultCats, ...customCats]`
   (line 808), where `defaultCats` is a hardcoded constant — so **the built-in
   categories SURVIVE delete-all by design.** The use case's own doc comment
   ("the built-in categories are also cleared, matching the design's
   `confirmDeleteAll`") misreads the design source. Deleting them produces the
   exact contradiction QA observed: 0 categories while the footer states
   "Built-in categories cannot be deleted".
   **Fix = stop deleting built-ins** (`isBuiltIn == true` survives; clear
   expenses, stores and CUSTOM categories only). That restores the design's own
   post-delete state and satisfies `delete_all_records_rules.md` rule 7 —
   the user lands in a usable state, not a stranded one — **without adding any
   screen, route or flow.** No new restore surface is authorised.
   Leave the `dataCleared` seed guard (`isEmpty && !dataCleared`) intact.
8. **R2-10** [`app_*.arb` × 7 locales] ICU plural conversion is PARTIAL — cause:
   implementation. Independently verified: `grep -c 'plural,'` returns **6, not
   8**, in every locale. Converted: `items`, `cheapestOf`, `deleteAllBody`,
   `tCsv`, `tImported`. **Still concatenating: `catUsed` ("Своя · {n} записей"),
   `storeMeta` ("{v} визитов · {p} товаров" — TWO counts, both un-pluralized),
   `bought` ("Куплено {n}×").**
   ⛔ `sig:count-plus-noun-concatenated-without-icu-plural` — PERMANENT CHECKLIST
   key (resolved once, returned 3×), and a textbook partial rollout.
   **PER-KEY terminal state required.** ru/uk need 4 forms (one/few/many/other),
   ro 3, fr/es/de 2. `storeMeta` needs two independent plural blocks.

## DESIGN-CAUSED, AUTO-FIX → Developer (1)

1. **R2-8** [`app_en.arb:121` `onb1Point1`] "Text is read on your iPhone" renders
   on Android — cause: **design spec §4.4 omission**, not an unwired call site.
   Objective criterion: **incorrect content shipped to the user** — the string
   states a factual falsehood about the device in hand.
   Evidence: spec §4.4 (lines 77, 239-240) enumerates exactly **4** strings to
   de-iPhone (`deleteAllBody`, `onDevice`, `keepSafeBody`, `limitLocal`) and the
   `{device}` mechanism is correctly built and wired at all four —
   `lo.thisDevice` resolves at `settings_page.dart:129`, `profile_page.dart:94`,
   `profile_body.dart:58,67`, `scanner_processing_sheet.dart:90`. **`onb1Point1`
   was simply never on the spec's list** — a 5th occurrence the spec missed.
   **Deviation logged:** spec §4.4 says 4 strings → a 5th (`onb1Point1`) is
   converted to the same `{device}` placeholder across all 7 locales. Required
   because the existing mechanism already exists and the omission ships a false
   platform claim. Minimal: one ARB key per locale + one call site. **No new
   mechanism, no new key design.**

## DESIGN-CAUSED, ESCALATE → user (1)

1. **B-6** [`profile_identity_column.dart:39-51`, `profile_body.dart:53-77`] no
   editable avatar or display name anywhere — cause: **design source**.
   ⚠️ **I checked the design source, as instructed. It shows NO avatar editor.**
   The Profile screen (Prototype lines 251-274) renders the 88px circle as a
   pure `{{ avatarInitial }}` letter badge with **no `onClick`**, and
   `avatarInitial` / `avatarBg` (line 907) are **derived state**, not user data:
   they switch on `signedIn` ('A' + warm gradient / 'L' + cool gradient).
   `profileName` (line 906) is likewise derived — `'Alex Popescu'` when signed
   in, else `T('localAccount')`. There is no image picker, no name field, and no
   edit route anywhere in either design file. The app faithfully implements this.
   Therefore `edit_profile_screen_rules.md` **has nothing to bind to**: it
   governs a screen "where an Edit Profile surface exists", and none does.
   Adding one would add a **flow** (image picker + staged commit + persistence,
   and `image_picker` is not even a dependency) — the absolute
   never-auto-fix boundary. **ESCALATE.**
   **Proposed fix for the user to rule on:** EITHER (a) accept as-designed —
   identity is derived from auth state, which is coherent for a local-first
   tracker whose signed-in name comes from Google/Apple; and make the inert
   88px circle non-affordant so it stops reading as a tappable control (that
   half is a cheap, in-scope polish); OR (b) authorise a new Edit Profile flow
   as scope, which requires `image_picker`, a staged-commit editor and a new
   route. **Recommend (a)** — (b) adds a flow the design never showed, for data
   the design derives rather than stores.

## DROP — intended behaviour (0)

None. No open finding is contradicted by a `.claude/rules/*.md` contract or by
the spec. (The known-intended set — unconfigured sign-in / PDF export / cloud
backup, the styled-disabled year stepper, the absent NoConnection screen with
`connectivity_plus` blacklisted — was correctly NOT re-filed by QA, so there is
nothing to drop.)

## Verdict

**9 to fix · 1 escalated · 0 dropped == 10 open findings received.** ✅ Reconciles.

Two items were re-diagnosed against the design source rather than taken at face
value: **R2-9** (not a missing restore path — delete-all over-deletes; the design
preserves built-ins) and **R2-8** (not an unwired placeholder — a spec-coverage
omission; the mechanism works at all 4 spec-named sites).
**R2-7 is NOT in the lists above — see the escalation note below.**

## R2-7 — ADDENDUM: the toast theory is REFUTED; routed as CODE BUG with a caveat

**Bucket: CODE BUG → Developer. Bringing the fix total to 9 as counted above.**

The Orchestrator asked me to verify the hypothesis that the CTA's silence is a
`UiMessageService`/`AppToast` overlay failure affecting **every** toast in the
app. **I traced the whole chain and that hypothesis is false.** The toast
infrastructure is correctly and completely wired:

- `ui_message_service.dart:26` holds a `GlobalKey<NavigatorState>`; `:57-75`
  `_show` resolves `currentState.overlay` and inserts an `OverlayEntry`
  building `AppToast`.
- `main.dart:166` calls `UiMessageService.attach(rootNavigatorKey)` **before**
  `runApp` (`:168`).
- `init_router.dart:62` passes that same `rootNavigatorKey` as
  `GoRouter(navigatorKey: ...)`, and `main.dart:247` wires
  `routerConfig:` onto `MaterialApp.router`. GoRouter forwards the key to the
  root `Navigator`, so `currentState.overlay` is live after the first frame.
  (There is deliberately no literal `navigatorKey:` on `MaterialApp.router` —
  that constructor rejects it. The wiring is correct, just located in the router.)
- `app_toast.dart:33` returns a `Positioned` — valid inside an `Overlay`; its
  colour tokens exist in both schemes and nothing resolves to transparent.

**This matters for routing:** B-2's "Editing arrives in a later update." toast
was observed rendering on-device in Round 1, which independently corroborates a
working overlay. So this is **not** the app-wide toast failure the Orchestrator
flagged as "much more serious" — that concern is retired, and no app-wide toast
work is authorised.

`_onScanReceipt` (`home_body.dart:36-60`) is likewise correct, as the
Orchestrator read it: exhaustive switch, per-state message, `showInfo` at `:59`.

⚠️ **What remains unexplained — the Developer must reproduce before fixing.**
A correct handler plus a working toast cannot both hold while the screen stays
silent. I did not observe the device myself and I will not manufacture a root
cause to close the gap. The two candidates the code supports:

1. **`_show`'s silent null-guard at `:59`.** If the toast fires while
   `currentState` is momentarily null, `_show` returns having done nothing —
   no log, no throw. That failure mode is *specifically* invisible, and it is
   the shape that matches "no exception, no output, no feedback".
2. **The awaits never settle.** `capabilityService.check()` (`:40`) hits
   `permission_handler` and `camera`'s `availableCameras()`. If either hangs on
   this emulator (no camera HAL), execution never reaches `:59` at all —
   the same clean-logcat signature as O-1's unbounded Apphud await, a defect
   class this very run already shipped once.

**Directive to the Developer:** reproduce first, identify which of the two it is,
and fix THAT. Do not "fix" this by adding a second toast mechanism. If it is
candidate 2, bound the capability probe with a timeout and a defined fallback —
the O-1 lesson, applied to a second unbounded native await. Additionally, and
regardless of cause: **replace the silent `return` at `ui_message_service.dart:59`
with a diagnostic** so a dropped toast can never again be invisible.

## Consolidated Developer fix list (priority order)

1. **R2-1** (High) nav bar overflow — **per-site terminal state**
2. **R2-2** (High) Scanning row overflow — same chronic
3. **R2-3** (Med) ru mid-word wrap at normal scale — verify separately from R2-2
4. **R2-7** (Med, PRIMARY PATH) scan CTA silent — **reproduce before fixing**
5. **R2-6** (Med) Appearance per-segment selection + `system` handling
   (decision 2 binding: keep both themes and the toggle)
6. **R2-4** (Med) CustomAppBar back arrow on shell-branch roots
7. **R2-9** (Med) delete-all must preserve built-in categories
8. **R2-10** (Med) ICU plurals — **per-key terminal state**: `catUsed`,
   `storeMeta` (2 counts), `bought`
9. **R2-5** (Med) "System default" language value
10. **R2-8** (Low, AUTO-FIX w/ logged deviation) `onb1Point1` → `{device}`

## Escalation → Orchestrator → user (1)

**B-6** — no editable avatar/display name. The design source shows none; the
identity is derived from auth state, not stored. Adding an editor adds a flow.
Recommend option (a): accept as-designed, and make the inert 88px circle
non-affordant. Option (b) authorises a new Edit Profile flow as scope.
**This pauses only B-6; the other 9 items proceed.**

## Anti-regression note for `qa-analytics` (Step 6)

Two chronic keys recur in this round and BOTH as partial rollouts — the same
failure shape, twice, in one run:
- `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor` (R2-1, R2-2, R2-3)
- `sig:count-plus-noun-concatenated-without-icu-plural` (R2-10, residue of B-4)
A third, `sig:unbounded-third-party-sdk-await-before-runapp-hangs-first-frame`
(O-1), may have a **second instance** in R2-7 candidate 2 — a native capability
probe awaited with no bound. Worth attributing if the Developer confirms it.

## O-4
- **Severity:** Medium
- **Signature:** `sig:a-clamp-applied-to-one-branch-of-a-two-branch-widget-leaves-the-other-live`
- **Chronic key:** `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor` (11/16 sessions)
- **Found by:** Orchestrator, on-device screencap at `font_scale 2.0`, AFTER the QA fix round
  reported R2-1/R2-2/R2-3 all RESOLVED with a per-site terminal state.
- **What happened:** the fix round clamped `SettingsRow`'s `trailingText` branch
  (ellipsis + maxLines) but left the sibling `trailing` *widget* branch as a bare
  `Flexible` + `Align`. The `AppearanceToggle` passed through that second branch, kept
  its intrinsic width, and still overflowed — "Ligh…" clipped mid-word behind a yellow
  stripe. Both branches live in the SAME FILE, six lines apart.
- **Fix:** `Flexible(fit: FlexFit.tight)` + `MediaQuery.withClampedTextScaling` on the
  widget branch, plus `maxLines`/`ellipsis` on the toggle's own segment labels.
- **Verified:** rebuilt, relaunched at `font_scale 2.0`, screencapped — toggle renders
  "Dark | Light" cleanly, no stripe anywhere on the screen. Device restored to 1.0.
- ⛔ **Why this is worth recording as its own signature:** this is the FIFTH consecutive
  milestone in which this chronic survived as a PARTIAL rollout, and the narrowest yet —
  not "4 of 5 files" but *one of two adjacent branches in a single widget*. A per-site
  terminal state was explicitly demanded and honestly given; it was still incomplete,
  because the author enumerated the sites they had changed rather than the sites the
  defect could occupy. ⭐ **The reusable lesson: a per-site report enumerates the fixer's
  mental model, not the code. Only re-running the original reproduction — here, a
  screencap at the exact font scale that first exposed it — closes the loop.**
- ⚠️ **Instrument note:** `adb logcat | grep -c "OVERFLOWED BY"` returned **0** while the
  screencap plainly showed an overflow stripe. The logcat grep is NOT a reliable
  overflow detector on this build; the screencap is authoritative. Same class as the
  stale-splash-layer artifact QA hit in Round 2.

## O-5
- **Severity:** High (process defect — a gate that could never fail)
- **Signature:** `sig:regression-gate-regex-silently-matches-zero-sites-and-reports-green`
- **Found by:** Orchestrator, by deliberately breaking a fixed site and re-running the gate.
- **What happened:** the Code-Reviewer fix round added
  `test/regression/platform_channel_timeout_test.dart` to stop the run's THIRD instance
  of the unbounded-native-await defect from recurring, and reported it "verified to fail
  against unfixed code". I re-verified independently by deleting one real
  `.timeout(_kDetectFrameTimeout)` — **the gate stayed GREEN.**
- **Three independent defects in one 60-line gate**, each sufficient on its own to make
  it vacuous:
  1. ⛔ **The matcher `invokeMethod\s*(?:<[^>]*>)?\s*\(` matched ZERO of the real call
     sites.** Production calls use NESTED generics —
     `invokeMethod<Map<Object?, Object?>>(` — and `[^>]*` stops at the first `>`. The
     gate scanned **0 sites** while reporting pass. Fixed to `[^(]*`.
  2. The statement scan started at `match.end`, so the call's own opening `(` was never
     counted; `parenDepth` went negative at the closing `)` and the next `;` looked like
     the statement end — truncating before a cascaded `.timeout(...)` on a later line.
     Anchored at `callStart`.
  3. Consequently a multi-line `await _channel\n .invokeMethod<T>(...)\n .timeout(...)` —
     the shape ALL the real code uses — read as unbounded-but-passing.
- **After the fix:** the gate covers **6 call sites across 4 files** (previously 0), fails
  with the exact `file:line` when a timeout is removed, and passes when restored.
- ⛔ **Why this belongs in the ledger:** this is the SECOND green-but-meaningless gate
  this session. The first (`splash_native_remove_test.dart`) asserted a real property on
  an **unreachable code path**; this one asserted a real property against **zero matched
  sites**. Different mechanisms, identical consequence: a gate that cannot fail is
  indistinguishable from a gate that passes, and both were written in good faith by
  authors who believed they had verified them.
- ⭐ **The reusable practice:** *verifying a gate means breaking the code and watching it
  go red — performed by someone other than the gate's author.* The author here did claim
  a negative-control check and had done one (via `git stash`, which reverted whole files
  and happened to trip the two sites whose call shape the regex DID match). A
  single-site, surgical break is the sharper instrument, and it is what exposed this.
- ⛔ **UPDATE — a THIRD mechanism, found by attacking the REPAIRED gate.** My two fixes
  (regex + scan anchor) were both correct and still left the gate partially vacuous. A
  surgical break of exactly one `.timeout(...)` per file, one file at a time, gave:
  `method_channel_receipt_detector` RED · `scan_capability_service` RED ·
  `method_channel_ocr_service` RED · `camera_preview_layer` RED ·
  ⛔ **`apphud_subscription_repository` GREEN** · ⛔ **`google_sign_in_service` GREEN**.
  **Root cause was SCOPE, not syntax:** the pattern list was still
  `['invokeMethod', 'availableCameras']`, and `Apphud.start`,
  `Apphud.hasPremiumAccess` and `GoogleSignIn.initialize` tunnel to a native channel
  *inside the plugin*, so the literal `invokeMethod` never appears in our source.
  ⭐ **The gate was blind to precisely the two calls it had been written in response to** —
  the ones that actually hung this app. Fixed by extracting `_kBoundedCallPatterns` and
  adding those shapes; the same surgical sweep now turns all 6 files RED, and the gate
  covers 8 sites (from 0 → 6 → 8 across the three repairs).
- ⛔ **So this ONE gate failed three times, by three different mechanisms, with one
  consequence:** unreachable path → zero matched sites → out-of-scope call shapes. Each
  repair was correct and each left a hole.
- ⭐ **SHARPENED LESSON (supersedes "test your gate"):** *a gate must be broken at EVERY
  site it claims to cover, not at one, and the negative control must be SURGICAL.* Two
  independent coarse controls failed identically here — a `git stash` that reverted whole
  files, and a shell loop that silently modified nothing because zsh did not word-split an
  unquoted variable. ⛔ **An unverified negative control is indistinguishable from a
  passing one.** Both were caught only by checking `git status` and the `.timeout(` count
  rather than trusting the loop's own output.
- **Cross-project applicability:** nothing here is SpendLens-specific. Source-scanning
  gates are grep-based by construction (this repo's own rules note comments are stripped
  before matching), so the whole family fails this way: a pattern that matches nothing, a
  scan window that truncates, or a pattern list that omits the very call shape the gate
  exists to police.
