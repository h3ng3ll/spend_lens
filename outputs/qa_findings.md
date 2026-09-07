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
