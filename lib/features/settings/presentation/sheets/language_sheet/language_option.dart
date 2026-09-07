/// A single selectable row in the Language sheet.
///
/// `code` is `null` for the "follow device" row — every other row carries an
/// ISO 639-1 code matching one of [AppLocale.supportedLocales].
class LanguageOption {
  final String? code;
  final String label;

  const LanguageOption({required this.code, required this.label});
}
