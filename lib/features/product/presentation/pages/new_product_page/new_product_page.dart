import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/services/permission_requester.dart';
import '../../../../../core/services/product_image_store/product_image_store.dart';
import '../../../../auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../../domain/models/product/e_unit.dart';
import '../edit_product_page/widgets/e_product_image_source.dart';
import '../edit_product_page/widgets/editable_product_image.dart';
import '../edit_product_page/widgets/product_image_source_sheet.dart';
import '../../bloc/products_bloc/products_bloc.dart';
import 'widgets/product_unit_chip_row.dart';

/// `NewProductPageRoute` — a top-level push above the shell for recording a
/// product by hand, without the camera.
///
/// The FIRST PRICE is optional. A product with none is legal and opens on an
/// empty price list with a live "+ Add price"; requiring one here would make
/// "I know I buy this, I just don't have the receipt" impossible to express.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the whole
/// form including the Create button lives inside ONE
/// [SingleChildScrollView], and the `Scaffold` keeps its default
/// `resizeToAvoidBottomInset: true`.
class NewProductPage extends StatefulWidget {
  /// The store this product belongs to. Null creates a general-purpose one.
  final String? storeId;

  const NewProductPage({super.key, this.storeId});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  EUnit _unit = EUnit.piece;

  /// The STAGED photo's filename, or empty when none was picked. The
  /// committed slot is keyed on a product id that does not exist yet, so the
  /// commit happens in `ProductsBloc._onCreate` once the id is built.
  String _stagedImageFilename = '';

  /// Covers BOTH the OS picker and the staging copy — neither is instant on
  /// a multi-megabyte photo.
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _priceController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _priceController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _priceController.dispose();
    // A pick the user never saved must not survive into the next form: the
    // staging slot is one shared file.
    if (_stagedImageFilename.isNotEmpty) {
      getIt<ProductImageStore>().discardStaged();
    }
    super.dispose();
  }

  void _onFieldChanged() => setState(() {});

  /// Opens the source sheet and STAGES the outcome. Nothing is committed
  /// here: the product has no id yet.
  Future<void> _onImageTap() async {
    final source = await ProductImageSourceSheet.show(
      context,
      hasImage: _stagedImageFilename.isNotEmpty,
    );
    if (source == null || !mounted) return;

    if (source == EProductImageSource.remove) {
      setState(() => _stagedImageFilename = '');
      return;
    }

    setState(() => _isPickingImage = true);

    try {
      final permissionRequester = getIt<PermissionRequester>();
      final file = source == EProductImageSource.camera
          ? await permissionRequester.onPickCamera(context)
          : await permissionRequester.onPickGallery(context);
      if (file == null) {
        if (mounted) setState(() => _isPickingImage = false);
        return;
      }

      final staged = await getIt<ProductImageStore>().stageFrom(file.path);
      if (!mounted) return;
      setState(() {
        _isPickingImage = false;
        if (staged != null) _stagedImageFilename = staged;
      });
    } catch (_) {
      // A stuck spinner over an unchanged tile is worse than the failure
      // itself, because it never resolves.
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  void _onClose(BuildContext context) => context.pop();

  void _onUnitSelected(EUnit unit) => setState(() => _unit = unit);

  double? get _parsedPrice {
    final raw = _priceController.text.trim().replaceAll(',', '.');
    if (raw.isEmpty) return null;
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return value;
  }

  void _onCreate(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    context.read<ProductsBloc>().add(
          ProductsEvent.create(
            name: name,
            storeId: widget.storeId,
            categoryId: null,
            unit: _unit,
            firstPrice: _parsedPrice,
            observedAt: DateTime.now(),
            currencyCode:
                context.read<SettingsBloc>().state.settings.currencyCode,
            stagedImageFilename:
                _stagedImageFilename.isEmpty ? null : _stagedImageFilename,
            uid: context.read<AuthBloc>().state.uid,
          ),
        );
  }

  bool _listenWhenCreated(ProductsState previous, ProductsState current) {
    return current.lastCreatedId != null &&
        previous.lastCreatedId != current.lastCreatedId;
  }

  void _onCreated(BuildContext context, ProductsState state) {
    final createdId = state.lastCreatedId;
    if (createdId == null) return;
    context.pop(createdId);
  }

  bool _listenWhenWriteFailed(ProductsState previous, ProductsState current) {
    return !previous.isWriteFailed && current.isWriteFailed;
  }

  void _onWriteFailed(BuildContext context, ProductsState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ProductsBloc, ProductsState>(
          listenWhen: _listenWhenCreated,
          listener: _onCreated,
        ),
        BlocListener<ProductsBloc, ProductsState>(
          listenWhen: _listenWhenWriteFailed,
          listener: _onWriteFailed,
        ),
      ],
      child: Scaffold(
        backgroundColor: scheme.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: HorizontalPadding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16.0,
                  children: [
                    SheetCloseHeader(
                      title: lo.newProductTitle,
                      onClose: () => _onClose(context),
                    ),
                    Center(
                      child: EditableProductImage(
                        filename: _stagedImageFilename,
                        productName: _nameController.text,
                        onTap: _onImageTap,
                        isUploading: _isPickingImage,
                      ),
                    ),
                    LabeledField(
                      label: lo.productNameLabel,
                      child: AppContainer(
                        color: scheme.field,
                        borderRadius: BorderRadius.circular(14.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: CustomTextField(
                          controller: _nameController,
                          hintText: lo.productNameHint,
                          style: textTheme.body17.copyWith(color: scheme.ink),
                          hintStyle: textTheme.body17.copyWith(
                            color: scheme.ter,
                          ),
                          filled: false,
                          isDense: true,
                          padding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    LabeledField(
                      label: lo.productUnitLabel,
                      child: ProductUnitChipRow(
                        selected: _unit,
                        onSelected: _onUnitSelected,
                      ),
                    ),
                    LabeledField(
                      label: lo.priceAmountLabel,
                      child: AppContainer(
                        color: scheme.field,
                        borderRadius: BorderRadius.circular(14.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: CustomTextField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: textTheme.body17.copyWith(color: scheme.ink),
                          filled: false,
                          isDense: true,
                          padding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    GradientCtaButton(
                      label: lo.create,
                      enabled: _nameController.text.trim().isNotEmpty,
                      onTap: () => _onCreate(context),
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
}
