import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/colors/app_colors.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../../analytics/domain/models/price_observation/price_observation.dart';
import 'price_point_result.dart';

/// Adds or edits one manual price point.
///
/// It RETURNS the value and writes nothing — the page dispatches the intent
/// to `ProductDetailBloc`, which owns every write. Same discipline as
/// `StoreLogoSourceSheet`.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the body is
/// scrollable, `isScrollControlled` is true, and the sheet is padded by
/// `viewInsets.bottom`, so the price field stays above the keyboard.
class PricePointSheet extends StatefulWidget {
  final PriceObservation? existing;
  final String? defaultStoreId;

  const PricePointSheet({
    super.key,
    this.existing,
    this.defaultStoreId,
  });

  static Future<PricePointResult?> show(
    BuildContext context, {
    PriceObservation? existing,
    String? defaultStoreId,
  }) {
    return showModalBottomSheet<PricePointResult>(
      context: context,
      // Root navigator, above the 5-tab shell — see `CurrencySheet.show`.
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent.value,
      builder: (sheetContext) => PricePointSheet(
        existing: existing,
        defaultStoreId: defaultStoreId,
      ),
    );
  }

  @override
  State<PricePointSheet> createState() => _PricePointSheetState();
}

class _PricePointSheetState extends State<PricePointSheet> {
  late final TextEditingController _priceController = TextEditingController(
    text: widget.existing == null
        ? ''
        : widget.existing!.comparableUnitPrice.toStringAsFixed(2),
  );

  late DateTime _observedAt = widget.existing?.observedAt ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_onPriceChanged);
  }

  @override
  void dispose() {
    _priceController.removeListener(_onPriceChanged);
    _priceController.dispose();
    super.dispose();
  }

  void _onPriceChanged() => setState(() {});

  double? get _parsedPrice {
    final raw = _priceController.text.trim().replaceAll(',', '.');
    if (raw.isEmpty) return null;
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return value;
  }

  Future<void> _onPickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _observedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      // Same reason as every other modal in this app.
      useRootNavigator: true,
    );
    if (picked == null || !mounted) return;
    setState(() => _observedAt = picked);
  }

  void _onSave() {
    final price = _parsedPrice;
    if (price == null) return;
    Navigator.of(context).pop(
      PricePointResult(
        unitPrice: price,
        observedAt: _observedAt,
        storeId: widget.existing?.storeId ?? widget.defaultStoreId,
      ),
    );
  }

  void _onClose() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.sheet,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: HorizontalPadding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16.0,
                  children: [
                    SheetCloseHeader(
                      title: widget.existing == null
                          ? lo.addPrice
                          : lo.editPrice,
                      onClose: _onClose,
                    ),
                    LabeledField(
                      label: lo.priceAmountLabel,
                      child: CustomTextField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        filled: true,
                        fillColor: scheme.field,
                        style: textTheme.body17.copyWith(color: scheme.ink),
                      ),
                    ),
                    LabeledField(
                      label: lo.priceDateLabel,
                      child: GestureDetector(
                        onTap: _onPickDate,
                        behavior: HitTestBehavior.opaque,
                        child: AppContainer(
                          height: 52.0,
                          color: scheme.field,
                          borderRadius: BorderRadius.circular(14.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatDate(_observedAt),
                            style: textTheme.body17.copyWith(
                              color: scheme.ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GradientCtaButton(
                      label: lo.save,
                      enabled: _parsedPrice != null,
                      onTap: _onSave,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}
