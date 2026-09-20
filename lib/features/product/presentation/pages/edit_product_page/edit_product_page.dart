import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/app_icons.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/services/product_image_store/product_image_store.dart';
import '../../../../../core/services/permission_requester.dart';
import '../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../../category/domain/models/category/category_display_x.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/product/e_unit.dart';
import '../../../domain/models/product/product.dart';
import '../../../domain/repositories/i_product_local_repository.dart';
import '../new_product_page/widgets/product_unit_chip_row.dart';
import 'edit_product_result.dart';
import 'widgets/e_product_image_source.dart';
import 'widgets/editable_product_image.dart';
import 'widgets/product_image_source_sheet.dart';

/// `EditProductPageRoute` — a top-level push above the shell for correcting a
/// product's identity: its name, owning store, category and unit.
///
/// A PAGE, not a sheet. It carries four fields, two of which push their own
/// full-screen pickers (store and category); a sheet that has to be covered
/// by another full screen twice, over a keyboard, is the wrong surface for
/// it.
///
/// PRICES ARE NOT EDITED HERE. A price belongs to the receipt that recorded
/// it — the receipt is what describes it, and it is regenerated from that
/// receipt on every correction save. The product page's price list links each
/// one to its source, which is the only place a correction is durable.
///
/// It RETURNS the edited values via `context.pop` and writes nothing; the
/// product page dispatches the intents so the bloc stays the single writer.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the whole
/// form INCLUDING the Save button lives inside one [SingleChildScrollView],
/// and the `Scaffold` keeps its default `resizeToAvoidBottomInset: true`.
class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _nameController = TextEditingController();

  Product? _product;
  String? _storeId;
  String? _categoryId;
  EUnit _unit = EUnit.piece;

  String? _storeName;
  String? _categoryName;

  /// The photo currently SHOWN — the committed filename until the user picks,
  /// then the staged one. Never bytes (see `ProductImageStore`).
  String _imageFilename = '';

  /// Set once the user picks, so Save can tell a new photo from an untouched
  /// one without comparing filenames (the staging slot has a fixed name).
  String? _stagedImageFilename;

  /// Staged removal — committed on Save, never on tap
  /// (`edit_profile_screen_rules.md`).
  bool _imageRemoved = false;

  /// Covers BOTH the OS picker and the staging copy; neither is instant on a
  /// multi-megabyte photo, and without it the tile sits unchanged with no
  /// feedback — indistinguishable from a tap that did nothing.
  bool _isPickingImage = false;

  bool get _hasImage => _imageFilename.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
    _load();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    // A pick the user never saved must not survive into the next edit: the
    // staging slot is one shared file, so leaving it would show this photo
    // over the NEXT product opened. Fire-and-forget is the only option in
    // `dispose`, and a failed cleanup is harmless — the slot is overwritten
    // by the next pick regardless.
    if (_stagedImageFilename != null) {
      getIt<ProductImageStore>().discardStaged();
    }
    super.dispose();
  }

  void _onNameChanged() => setState(() {});

  /// One-shot reads to seed the form (hive_rules.md §6 exempts a form bloc's
  /// initial load): this is an editor over a snapshot the user is about to
  /// replace, not a surface that must track later writes.
  Future<void> _load() async {
    final product = await getIt<IProductLocalRepository>().getById(
      widget.productId,
    );
    if (!mounted || product == null) return;

    setState(() {
      _product = product;
      _nameController.text = product.displayName;
      _storeId = product.storeId;
      _categoryId = product.defaultCategoryId;
      _unit = product.defaultUnit;
      _imageFilename = product.imageFilename ?? '';
    });

    await _loadStoreName();
    await _loadCategoryName();
  }

  Future<void> _loadStoreName() async {
    final storeId = _storeId;
    if (storeId == null) {
      if (mounted) setState(() => _storeName = null);
      return;
    }
    final store = await getIt<IStoreLocalRepository>().getById(storeId);
    if (!mounted) return;
    setState(() => _storeName = store?.name);
  }

  /// Resolves the category's DISPLAYED name — built-ins store an i18n key in
  /// `name`, so the raw field is not showable text.
  Future<void> _loadCategoryName() async {
    final categoryId = _categoryId;
    if (categoryId == null) {
      if (mounted) setState(() => _categoryName = null);
      return;
    }
    final category = await getIt<ICategoryLocalRepository>().getById(
      categoryId,
    );
    if (!mounted) return;
    final resolved = category?.displayName(AppLocalizations.of(context));
    setState(() => _categoryName = resolved);
  }

  Future<void> _onPickStore() async {
    final pickedId = await ChooseStorePageRoute().push<String>(context);
    if (pickedId == null || !mounted) return;
    setState(() => _storeId = pickedId);
    await _loadStoreName();
  }

  void _onMakeGeneralPurpose() {
    setState(() {
      _storeId = null;
      _storeName = null;
    });
  }

  Future<void> _onPickCategory() async {
    final pickedId = await CategoriesPageRoute().push<String>(context);
    if (pickedId == null || !mounted) return;
    setState(() => _categoryId = pickedId);
    await _loadCategoryName();
  }

  /// Opens the source sheet and STAGES the outcome.
  ///
  /// The OS picker is a system dialog, not app logic, so launching it stays
  /// in the UI layer — but only the resulting PATH is used, and the bytes are
  /// never read here. Nothing is committed: this page writes nothing, so the
  /// staged decision rides back on [EditProductResult].
  Future<void> _onImageTap() async {
    final source = await ProductImageSourceSheet.show(
      context,
      hasImage: _hasImage,
    );
    if (source == null || !mounted) return;

    if (source == EProductImageSource.remove) {
      setState(() {
        _imageFilename = '';
        _stagedImageFilename = null;
        _imageRemoved = true;
      });
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
        if (staged != null) {
          _imageFilename = staged;
          _stagedImageFilename = staged;
          _imageRemoved = false;
        }
      });
    } catch (_) {
      // A read that throws (a revoked permission, a file that vanished) must
      // still clear the flag — a stuck spinner over an unchanged photo is
      // worse than the failure itself, because it never resolves.
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  void _onUnitSelected(EUnit unit) => setState(() => _unit = unit);

  void _onClose() => context.pop();

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    context.pop(
      EditProductResult(
        displayName: name,
        storeId: _storeId,
        categoryId: _categoryId,
        unit: _unit,
        stagedImageFilename: _stagedImageFilename,
        imageRemoved: _imageRemoved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        child: _product == null
            ? const LoadingDataWidget()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: HorizontalPadding(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16.0,
                      children: [
                        SheetCloseHeader(
                          title: lo.editProductTitle,
                          onClose: _onClose,
                        ),
                        Center(
                          child: EditableProductImage(
                            filename: _imageFilename,
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
                              style: textTheme.body17.copyWith(
                                color: scheme.ink,
                              ),
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
                          label: lo.productStoreLabel,
                          child: _PickerRow(
                            label: _storeName ?? lo.generalPurpose,
                            isPlaceholder: _storeId == null,
                            onTap: _onPickStore,
                          ),
                        ),
                        if (_storeId != null)
                          GestureDetector(
                            onTap: _onMakeGeneralPurpose,
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              lo.makeGeneralPurpose,
                              style: textTheme.footnote13.copyWith(
                                color: scheme.accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        LabeledField(
                          label: lo.productCategoryLabel,
                          child: _PickerRow(
                            label: _categoryName ?? lo.productCategoryLabel,
                            isPlaceholder: _categoryName == null,
                            onTap: _onPickCategory,
                          ),
                        ),
                        LabeledField(
                          label: lo.productUnitLabel,
                          child: ProductUnitChipRow(
                            selected: _unit,
                            onSelected: _onUnitSelected,
                          ),
                        ),
                        GradientCtaButton(
                          label: lo.save,
                          enabled: _nameController.text.trim().isNotEmpty,
                          onTap: _onSave,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// A tappable value row that opens a full-screen picker.
class _PickerRow extends StatelessWidget {
  final String label;
  final bool isPlaceholder;
  final VoidCallback onTap;

  const _PickerRow({
    required this.label,
    required this.isPlaceholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppContainer(
        height: 52.0,
        color: scheme.field,
        borderRadius: BorderRadius.circular(14.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          spacing: 12.0,
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.body17.copyWith(
                  color: isPlaceholder ? scheme.ter : scheme.ink,
                ),
              ),
            ),
            AppSvgIcon(
              asset: AppIcons.chevronRight,
              color: scheme.ter,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
