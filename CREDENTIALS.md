# Credentials checklist

Nothing here blocks the build until the milestone named in the last column. The app is
built against `.env` keys and placeholders, so development proceeds without any of it.

**Start with `cp .env.example .env`**, then fill the values below.

---

## 1. Real receipt photos — the only item with no substitute

**Blocks: M8 (parser tuning). Worth gathering during M1.**

20–50 photos of real receipts, ideally Moldovan/Romanian stores, covering:

- supermarkets, restaurants, pharmacies, small shops
- long and short receipts; folded and rotated ones; low light
- Romanian **and** English receipts
- receipts with discounts, weighed goods (`1.2 kg`), and multi-quantity lines

Drop them anywhere convenient (e.g. `test/fixtures/receipts/raw/`) and say where.

Why this one is different: every other credential is a value to paste. Parser accuracy
against real OCR noise is the one thing effort alone cannot fix — testing against a single
receipt format is how a parser ships broken. The pipeline records OCR output from these into
fixtures, so the parser is tuned against real noise rather than idealized text.

---

## 2. Firebase — Crashlytics + optional auth only

**Blocks: M9.**

`flutterfire configure` for bundle id **`com.hengell.spendlens`**, which produces:

| File | Platform |
|---|---|
| `ios/Runner/GoogleService-Info.plist` | iOS |
| `android/app/google-services.json` | Android |
| `lib/firebase_options.dart` | both |

All three are gitignored. Note the deliberate limits: **no Firestore sync, no receipt image
upload**. Firebase is Crashlytics plus optional sign-in; the app is fully functional with
Firebase entirely absent.

---

## 3. Google Sign-In

**Blocks: M9.** → `GOOGLE_SERVER_CLIENT_ID`, `GOOGLE_IOS_CLIENT_ID`,
`GOOGLE_IOS_REVERSED_CLIENT_ID` in `.env`.

From Google Cloud Console → APIs & Services → Credentials:
- an **OAuth Web client** → `GOOGLE_SERVER_CLIENT_ID`
- an **OAuth iOS client** → `GOOGLE_IOS_CLIENT_ID` (+ its reversed form)
- an **OAuth Android client**, which needs your signing **SHA-1**:
  `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

> The template this architecture came from passed a **push certificate** where the server
> client id belonged — a real bug we are fixing rather than copying. If sign-in fails with an
> opaque error, verify this value first.

---

## 4. Sign in with Apple

**Blocks: M9.**

1. Apple Developer → Certificates, Identifiers & Profiles → your App ID
   (`com.hengell.spendlens`) → enable **Sign in with Apple**.
2. Regenerate the provisioning profile.
3. Xcode → Runner → Signing & Capabilities → add **Sign in with Apple** (writes
   `ios/Runner/Runner.entitlements`).
4. Firebase Console → Authentication → Sign-in method → enable **Apple**.

Needs a paid Apple Developer account. Also required: your **Team ID** for signing.

---

## 5. Apphud

**Blocks: M9.** → `APPHUD_API_KEY` in `.env`.

Apphud → Settings → General → API key. Then create the products/paywall in Apphud and link
them to App Store Connect / Google Play subscriptions. Apphud owns all entitlement state —
the app implements no StoreKit handling and no receipt validation of its own.

---

## 6. App icon and splash assets

**Blocks: M10.**

A 1024×1024 icon plus a splash logo. The renders in
`assets/SpendLens design system/uploads/` are **light-theme marketing images, not app
assets** — they would need recolouring to the violet/cyan palette, and two of them are
unrelated mood references.

---

## 7. Privacy policy and About copy

**Blocks: M10.**

The design shows the rows but not the text. Per your instruction these are **plain markdown
from assets**, not the hosted-URL webview flow. Supply the text (English at minimum) and it
will be wired in verbatim — legal copy is never invented or paraphrased.

---

## 8. Sign-off: the 6 derived category hues

**Blocks: M3 seeding.**

The design ships 6 categories with exact hues; you asked for all 12. The extra 6 are derived
using the design system's own stated rule — *"same lightness and chroma, only hue changes"*:

| Category | Hue | Source |
|---|---|---|
| Food | `#A78BFA` | design |
| Transport | `#67E8F9` | design |
| Household | `#F5B36B` | design |
| Restaurants & Coffee | `#F9A8D4` | design |
| Health | `#6EE7B7` | design |
| Other | `#8E8E93` | design |
| Personal Care | `#F57D7E` | derived |
| Entertainment | `#B2F57D` | derived |
| Shopping | `#F0F57D` | derived |
| Education | `#E47DF5` | derived |
| Utilities | `#7DF587` | derived |
| Travel | `#7DA3F5` | derived |

**Two names drifted from the original plan**, which listed *Electronics* and *Bills*; the
build seeded **Education** and **Utilities** instead. Both are sensible expense categories,
but you picked the 12, so say if you want them renamed — it is an ARB + seed change, not a
structural one.

**A hue concern worth a look.** Three of the derived six sit close together in the
yellow-green band — Shopping `#F0F57D`, Entertainment `#B2F57D`, Utilities `#7DF587` — and
are hard to tell apart in the Analytics donut legend, where colour is the only distinguishing
mark. Green also carries a specific meaning in this design system: *"amber when spending
rose, green when it fell."* A green category bar reads, at a glance, as a positive trend
rather than a category hue.

Suggested respacing across the wheel, keeping the design's six untouched:

| Category | Current | Suggested |
|---|---|---|
| Shopping | `#F0F57D` | `#F5D98B` |
| Entertainment | `#B2F57D` | `#C9A0F5` |
| Utilities | `#7DF587` | `#8BC6F5` |

Seeding proceeds with these; say the word if you want different hues.

---

## Not needed for this project

- **Jira** — no metadata sync step runs (`set_info_plist.sh --sync` is skipped).
- **App Store / Play signing** — only for an actual store release, not for the build.
