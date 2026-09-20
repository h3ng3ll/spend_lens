import 'receipt_line_expression.dart';

/// Which structural REGION of the receipt a grouped line belongs to.
///
/// A fiscal receipt is not a flat list of lines — it has a fixed shape, and
/// only one of its regions contains products:
///
/// ```
///   header   HONEST COMPANY S.R.L.        <- store name
///            mun. Chisinau                <- locality
///            str. Vasile Badiu, 11A       <- street
///            IDNO: 1020600037010          <- fiscal id
///            INR N: J403005312            <- fiscal id
///   items    BARILLA Paste W93 Conchiglie r
///              1 _ x 25.50= 25.50 A       <- price CONTINUATION of the line above
///            Branza Maasdam 45% 130g BREST
///              1 _ x 47.50= 47.50 A
///   total    TOTAL LEI            206.11  <- ends the item region
///   footer   CARD                 206.11
///            REST                   0.00
///            BRUT A               157.21
///            TVA 20%               26.20
///            Articole                  5  <- an item COUNT, not an item
///            Z:0855 BON:0067
///            <QR code>
/// ```
///
/// Classifying by region is what stops the footer's numbers from being read
/// as products. Without it every one of those trailing lines carries a
/// price-shaped token and so passes as an "item candidate": a real scan
/// produced 18 items including `INR N: JA` at 3,005,312.00 and
/// `Articole` at 5.00.
enum EReceiptRegion { header, items, total, footer }

/// Parser stage 2b — structure resolver.
///
/// Splits the grouped lines into the regions above BEFORE any item
/// extraction runs, and identifies price-continuation lines so a wrapped
/// item is not counted twice.
///
/// Deterministic, no LLM (spec §33) — position plus printed-token shape.
class ReceiptStructureResolver {
  /// Matches a line that carries ONLY a quantity/price expression and no
  /// product text of its own — the second physical line of a wrapped item:
  ///
  ///   `1 _ x 25.50= 25.50 A`
  ///   `0.274 _ x 165.40= 45.32 A`
  ///   `0.982 - x 39. 60= 38.89 A`
  ///
  /// OCR noise is expected inside it (`_`/`-`/`.` for the unit separator,
  /// stray spaces inside numbers, a trailing VAT letter), so the shape is
  /// matched loosely: a leading number, an `x`/`×` multiplier, and at least
  /// one more number, with nothing alphabetic beyond the trailing VAT
  /// class letter.
  /// A number, tolerating OCR spaces on EITHER side of the decimal
  /// separator — real output includes `165. 40` and `39. 60`.
  static const _number = r'\d+(?:[\s]*[.,][\s]*\d+)*';

  static final _continuationLine = RegExp(
    '^[\\s_.,-]*$_number'
    r'[\s_.,-]*[x×][\s_.,-]*'
    '$_number'
    '(?:[\\s_.,=-]*$_number)*'
    r'[\s_.,=-]*[A-Za-z]?[\s.]*$',
    caseSensitive: false,
  );

  /// Footer keywords that terminate or sit below the item region. These are
  /// PRINTED tokens, from the same fixed non-localized vocabulary as
  /// [ReceiptKeywordDetector] — never the app's own ARB labels.
  static const footerKeywords = <String>[
    'CARD',
    'NUMERAR',
    'CASH',
    'REST',
    'BRUT',
    'TVA',
    'ARTICOLE',
    'CASIER',
    'BON FISCAL',
    'FAB.N',
    'SUBTOTAL',
  ];

  /// Header keywords marking a fiscal/administrative line that must never
  /// become a product. `INR` is included because a real scan turned
  /// `INR N: J403005312` into an item priced at 3,005,312.00 — the store
  /// resolver's own noise check missed it.
  static const headerKeywords = <String>[
    'IDNO',
    'INR',
    'C/F',
    'COD FISCAL',
    'STR.',
    'TEL',
    'MUN.',
    'BON:',
    'Z:',
  ];

  /// A decimal money token — two digits after the separator. A bare
  /// integer is deliberately NOT money here.
  static final _moneyToken = RegExp(r'\d{1,3}(?:[.,]\d{3})*[.,]\d{2}(?!\d)');

  static const _expressionExtractor = ReceiptLineExpressionExtractor();

  const ReceiptStructureResolver();

  /// True when [line] is a wrapped item's price line rather than a product.
  ///
  /// The test is positional and delegated to
  /// [ReceiptLineExpressionExtractor]: a continuation line is one whose
  /// price expression starts at the very BEGINNING of the line, i.e. there
  /// is no product name in front of it. `0.488 kq x7.49- 3.66 b` is a
  /// continuation; `PASTE rigati 1 buc x 15.99- 15.99 A` prices itself and
  /// is not.
  ///
  /// This replaced a second, independently-maintained regex that did not
  /// recognize the real `QTY kg x PRICE= TOTAL TAXCODE` shape at all — so
  /// every weighed continuation line fell through to the item branch and
  /// became an item with an EMPTY name, instead of pairing with the name
  /// printed on the row above. One extractor owning the expression grammar
  /// means that shape can never drift between two places again.
  bool isPriceContinuation(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;
    if (!RegExp(r'^[\s_.,\-]*\d').hasMatch(trimmed)) return false;

    final expression = _expressionExtractor.extract(trimmed);
    if (expression == null) return _continuationLine.hasMatch(trimmed);

    // Only leading punctuation/whitespace may precede the expression —
    // anything word-like is a product name, making this a self-priced line.
    final prefix = trimmed.substring(0, expression.startIndex);
    return !RegExp(r'[A-Za-z]').hasMatch(prefix);
  }

  /// Promotional banner text a till prints ABOVE an item, not part of any
  /// product name.
  ///
  /// A real scan produced `O ! PRET MIC` ("special price") on its own line
  /// directly above `Conserva cu carne tocata de`. It has letters and no
  /// price, so it is indistinguishable from a name fragment by shape alone
  /// — and once name fragments are ACCUMULATED rather than overwritten, a
  /// banner would prepend itself to the product name
  /// (`O ! PRET MIC Conserva cu carne tocata de porc/gain`). Matched by
  /// vocabulary because that is the only thing that separates it.
  bool isPromoBanner(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;

    // Strip the decorative punctuation these banners are wrapped in
    // (`O ! PRET MIC`, `** REDUCERE **`) before matching.
    final letters = trimmed
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (letters.isEmpty) return false;

    for (final keyword in promoKeywords) {
      if (RegExp('(?<!\\w)${RegExp.escape(keyword)}(?!\\w)')
          .hasMatch(letters)) {
        return true;
      }
    }
    return false;
  }

  /// PRINTED promo vocabulary (Romanian/Moldovan tills), from the same
  /// fixed non-localized vocabulary as [footerKeywords] — never the app's
  /// own ARB labels.
  static const promoKeywords = <String>[
    'PRET MIC',
    'PRET SPECIAL',
    'REDUCERE',
    'OFERTA',
    'PROMO',
    'PROMOTIE',
    'SUPER PRET',
  ];

  /// True when [line] names a product but prints NO price of its own — the
  /// first half of a wrapped item.
  ///
  /// This cannot be inferred from "the price extractor found nothing",
  /// because that extractor accepts a BARE INTEGER as a price and product
  /// names routinely embed digits: `BARILLA Paste W93 Conchiglie r` was
  /// priced at 93.00 from its own product code, and `Branza Maasdam 45%
  /// 130g BREST` at 130.00 from its gram weight. Both then looked like
  /// complete items, so their real price lines below were stranded and
  /// emitted as separate bogus items — the 429.11 subtotal on a 206.11
  /// receipt.
  ///
  /// The test is therefore: the line contains LETTERS (a name), carries no
  /// DECIMAL money token, and carries no explicit quantity MULTIPLIER. A
  /// real item line prices itself either with decimals (`25.50`) or through
  /// a multiplier expression, so a line with neither is a bare name.
  ///
  /// The multiplier clause is what keeps a single-line weighed item intact:
  /// `ROSII 1.2 kg @ 104` has letters and no decimal token (`104` is a bare
  /// integer), so a decimals-only test would have misread that complete
  /// item as a name awaiting a price on the next row.
  bool isNameOnlyLine(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;
    if (!RegExp(r'[A-Za-z]').hasMatch(trimmed)) return false;
    if (_moneyToken.hasMatch(trimmed)) return false;
    return !_quantityMultiplier.hasMatch(trimmed);
  }

  /// Any Unicode LETTER. `\p{L}` rather than `[A-Za-z]` so Romanian
  /// diacritics count as letters — `Brânză`/`Pâine` are product names, not
  /// noise.
  static final _letter = RegExp(r'\p{L}', unicode: true);

  /// How many letters a name needs before it can be a product.
  ///
  /// TWO, not one, because a receipt prints its VAT CLASS CODE as a single
  /// trailing letter: `99.88 A` and `139.88 A` are an amount plus that
  /// code, and a one-letter threshold kept them as products named after
  /// their own price. No real product name survives on one letter — the
  /// shortest in this corpus (`2L A`, `Ou`, `APA`) all clear two.
  static const _minNameLetters = 2;

  /// Whether [name] — an already-extracted candidate NAME, never a raw line
  /// — identifies no product at all: empty, or carrying no letters
  /// whatsoever (`1.008 %`, `20 %`, `1 008`, `...`, `- - -`).
  ///
  /// THE BUG THIS CLOSES. A receipt's VAT block prints a bare rate row, and
  /// when the line grouper splits the `TVA` label away from the figure (or
  /// OCR mangles the label) nothing vetoes it: `footerKeywords` needs the
  /// keyword, `reachedTotal` needs the total line to have matched first, and
  /// [isNameOnlyLine] requires letters so it cannot even park it. The
  /// candidate builder then strips the trailing amount but `%` blocks the
  /// trailing-digit strip, leaving a non-empty `1.008 %` that passed its
  /// only guard — and became a Product with a price observation.
  ///
  /// It also cost real money. A VAT line is already INSIDE the printed
  /// total, so counting it as an item pushes `itemsTotal` above the printed
  /// total, `ReceiptParser._plausibleTotal` then judges the correctly-read
  /// total implausible and returns null, and the expense is recorded from
  /// the inflated item sum instead — with the mismatch warning suppressed,
  /// because a null printed total reconciles as "nothing to compare".
  ///
  /// A trailing VAT class code does not rescue a line either: `99.88 A` is
  /// an amount and a tax letter, and reading it as a name produced a
  /// product called after its own price. Hence [_minNameLetters].
  ///
  /// KEYED ON A SHORTAGE OF LETTERS, never on the presence of `%`:
  /// `Branza Maasdam 45% 130g BREST` is a real 45%-fat cheese, and an
  /// earlier over-broad guard on a `%`-bearing line already broke that once
  /// (see [_matchesWord]'s note on `REST`). A name keeps its line whenever
  /// it contains anything word-like.
  ///
  /// A short fragment that IS part of a real name — `45% 130g`, `2L A` —
  /// never reaches this predicate: [isNameOnlyLine] parks it as a pending
  /// name fragment first, and the parser tests the JOINED name, by which
  /// point the letters from the fragment above are present.
  bool hasNoProductName(String name) =>
      _letter.allMatches(name).length < _minNameLetters;

  /// An explicit quantity multiplier — `1.2 kg @ 104`, `2 x 15`, `500 g x
  /// 40`. Its presence means the line prices ITSELF.
  static final _quantityMultiplier = RegExp(
    r'\d+(?:[\s]*[.,][\s]*\d+)?\s*(?:kg|g)?\s*[x×@]\s*\d',
    caseSensitive: false,
  );

  /// Matched at WORD BOUNDARIES, never as a bare substring.
  ///
  /// A plain `contains` check is unsafe here because these keywords are
  /// short and collide with real product text: `Branza Maasdam 45% 130g
  /// BREST` contains `REST`, so the cheese was classified as a footer line
  /// and dropped — which then stranded its price line as a bogus item of
  /// its own. `TVA` inside a brand name and `CARD` inside `CARDAMOM` are
  /// the same hazard.
  bool isFooterLine(String line) => _matchesWord(line, footerKeywords);

  bool isHeaderLine(String line) => _matchesWord(line, headerKeywords);

  bool _matchesWord(String line, List<String> keywords) {
    final upper = line.toUpperCase();
    for (final keyword in keywords) {
      // Keywords ending in a non-word char (`Z:`, `BON:`, `STR.`, `FAB.N`)
      // cannot use a trailing \b — anchor those on the left only.
      final endsWithWordChar = RegExp(r'\w$').hasMatch(keyword);
      final pattern = RegExp(
        endsWithWordChar
            ? '(?<!\\w)${RegExp.escape(keyword)}(?!\\w)'
            : '(?<!\\w)${RegExp.escape(keyword)}',
      );
      if (pattern.hasMatch(upper)) return true;
    }
    return false;
  }
}
