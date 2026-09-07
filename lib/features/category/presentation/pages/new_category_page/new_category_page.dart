import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/labeled_field.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/sheet_close_header.dart';
import '../../../domain/models/category/category.dart';
import '../../../domain/models/category/next_custom_category_color.dart';
import '../../../domain/repositories/i_category_local_repository.dart';
import '../../bloc/categories_bloc/categories_bloc.dart';
import 'widgets/new_category_name_field.dart';

/// `NewCategoryPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for creating a custom category. `CategoryPage`'s own
/// quick-create search row creates the category inline (a direct repository
/// save, per the Developer's own call on the simpler of two acceptable
/// designs) rather than routing through here, so this page never needs a
/// pre-fill parameter.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the design
/// pins the Create button to the bottom via a `flex:1` spacer above it. To
/// keep the low-on-screen name field AND the pinned Create button both
/// reachable once the keyboard opens, the ENTIRE column (header, field,
/// hint, spacer, button) is wrapped in one [SingleChildScrollView] instead —
/// the `Spacer`/`Expanded` push-to-bottom approach the design implies only
/// works while the keyboard is closed; once it opens, an `Expanded` inside
/// an unbounded-height scrollable throws, and even fixed-height variants
/// would still let the keyboard cover the field. Making the whole column
/// scrollable means the button simply sits right below the hint text and
/// both scroll into view together.
class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({super.key});

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  String _name = '';

  @override
  void initState() {
    super.initState();
    _name = _nameController.text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _onClose(BuildContext context) => context.pop();

  void _onNameChanged(String value) => setState(() => _name = value);

  Future<void> _onCreate(BuildContext context) async {
    final trimmed = _name.trim();
    if (trimmed.isEmpty) return;

    final existingCategories = context.read<CategoriesBloc>().state.categories;
    final customCount = existingCategories.where((c) => !c.isBuiltIn).length;
    final now = DateTime.now();

    final category = Category(
      id: now.microsecondsSinceEpoch.toString(),
      name: trimmed,
      colorHex: nextCustomCategoryColorHex(customCount),
      isBuiltIn: false,
      updatedAt: now,
    );

    await getIt<ICategoryLocalRepository>().save(category);
    if (!context.mounted) return;

    context.pop(category.id);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);
    final isEnabled = _name.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: HorizontalPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 18.0,
              children: [
                SheetCloseHeader(
                  title: lo.newCategory,
                  onClose: () => _onClose(context),
                ),
                LabeledField(
                  label: lo.name,
                  child: NewCategoryNameField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    onChanged: _onNameChanged,
                  ),
                ),
                Text(
                  lo.newCatHint,
                  style: AppTextTheme.of(context)
                      .footnote13
                      .copyWith(color: scheme.ter),
                ),
                GradientCtaButton(
                  label: lo.createCategory,
                  enabled: isEnabled,
                  onTap: () => _onCreate(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
