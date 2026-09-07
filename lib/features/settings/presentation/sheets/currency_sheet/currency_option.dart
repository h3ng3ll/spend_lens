/// A single selectable row in the Currency sheet.
///
/// The prototype's own currency list (verified in
/// `SpendLens Prototype.dc.html`): MDL, EUR, RON, USD, UAH, GBP.
class CurrencyOption {
  final String code;
  final String name;

  const CurrencyOption({required this.code, required this.name});
}
