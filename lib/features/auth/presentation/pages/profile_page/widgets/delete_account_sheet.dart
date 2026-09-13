import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/sheet_close_header.dart';
import '../../../../domain/models/e_account_deletion_scope.dart';
import 'delete_account_option_row.dart';
import 'delete_account_subscription_notice.dart';

/// Lets the user choose WHAT "delete my account" destroys.
///
/// The two scopes are offered explicitly rather than picked for them, because
/// the phrase is genuinely ambiguous: some people mean "close the account",
/// others mean "erase every trace of me". Guessing either way destroys data
/// they meant to keep, or keeps data they meant to be rid of.
///
/// Returns the choice and acts on nothing — the confirmation and the deletion
/// itself belong to the caller, so this sheet can never delete anything by
/// being shown.
class DeleteAccountSheet extends StatelessWidget {
  /// Whether a paid subscription is currently active.
  ///
  /// Gates [DeleteAccountSubscriptionNotice]: billing lives with the App Store,
  /// not with this account, so deletion cannot and does not cancel it. The user
  /// has to be told BEFORE choosing — see that widget's doc comment.
  final bool hasActiveSubscription;

  /// Opens the platform subscription-management screen.
  final VoidCallback onManageSubscription;

  const DeleteAccountSheet({
    super.key,
    required this.hasActiveSubscription,
    required this.onManageSubscription,
  });

  static Future<EAccountDeletionScope?> show(
    BuildContext context, {
    required bool hasActiveSubscription,
    required VoidCallback onManageSubscription,
  }) {
    return showModalBottomSheet<EAccountDeletionScope>(
      context: context,
      // Root navigator, above the 5-tab shell — matching `LanguageSheet.show`.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => DeleteAccountSheet(
        hasActiveSubscription: hasActiveSubscription,
        onManageSubscription: onManageSubscription,
      ),
    );
  }

  void _onClose(BuildContext context) => Navigator.of(context).pop();

  void _onPick(BuildContext context, EAccountDeletionScope scope) =>
      Navigator.of(context).pop(scope);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return SafeArea(
      child: AppContainer(
        color: scheme.sheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SheetCloseHeader(
                title: lo.deleteAccountSheetTitle,
                onClose: () => _onClose(context),
              ),
              // ABOVE the two choices, deliberately: it is context for the
              // decision, not a footnote to be read after making it.
              if (hasActiveSubscription)
                DeleteAccountSubscriptionNotice(onManage: onManageSubscription),
              DeleteAccountOptionRow(
                title: lo.deleteAccountEverywhere,
                body: lo.deleteAccountEverywhereBody,
                onTap: () =>
                    _onPick(context, EAccountDeletionScope.everywhere),
              ),
              DeleteAccountOptionRow(
                title: lo.deleteAccountCloudOnly,
                body: lo.deleteAccountCloudOnlyBody,
                onTap: () =>
                    _onPick(context, EAccountDeletionScope.accountAndCloud),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
