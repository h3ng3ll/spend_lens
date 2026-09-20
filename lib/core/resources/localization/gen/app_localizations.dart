import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ro'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// No description provided for @deleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get deleteAllTitle;

  /// Auto-ported from i18n.js key "deleteAllBody". Converted to a real ICU plural — was raw string interpolation (recorded bug count-plus-noun-concatenated-without-icu-plural).
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{This removes 1 record, receipt photos, stores and categories from {device}. Cloud backups are not affected. This cannot be undone.} other{This removes {n} records, receipt photos, stores and categories from {device}. Cloud backups are not affected. This cannot be undone.}}'**
  String deleteAllBody(num n, String device);

  /// No description provided for @deleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get deleteAllConfirm;

  /// No description provided for @tDeletedAll.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get tDeletedAll;

  /// No description provided for @renameCategory.
  ///
  /// In en, this message translates to:
  /// **'Rename category'**
  String get renameCategory;

  /// Auto-ported from i18n.js key "catRenamed".
  ///
  /// In en, this message translates to:
  /// **'Renamed to {n}'**
  String catRenamed(String n);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @categoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get categoryEmpty;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get createCategory;

  /// No description provided for @newCatPh.
  ///
  /// In en, this message translates to:
  /// **'New category name'**
  String get newCatPh;

  /// No description provided for @searchCatPh.
  ///
  /// In en, this message translates to:
  /// **'Search or type a new category'**
  String get searchCatPh;

  /// No description provided for @newCatHint.
  ///
  /// In en, this message translates to:
  /// **'New category · appears in every category picker'**
  String get newCatHint;

  /// No description provided for @catNote.
  ///
  /// In en, this message translates to:
  /// **'Built-in categories cannot be deleted. Custom categories can be removed while unused.'**
  String get catNote;

  /// No description provided for @catDefault.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get catDefault;

  /// No description provided for @catCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom · unused'**
  String get catCustom;

  /// Converted to a real ICU plural (recorded bug count-plus-noun-concatenated-without-icu-plural, R2-10).
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{Custom · 1 record} other{Custom · {n} records}}'**
  String catUsed(num n);

  /// Auto-ported from i18n.js key "catCreated".
  ///
  /// In en, this message translates to:
  /// **'{n} created'**
  String catCreated(int n);

  /// Auto-ported from i18n.js key "catDeleted".
  ///
  /// In en, this message translates to:
  /// **'{n} deleted'**
  String catDeleted(int n);

  /// No description provided for @noStore.
  ///
  /// In en, this message translates to:
  /// **'No store'**
  String get noStore;

  /// No description provided for @deleteStore.
  ///
  /// In en, this message translates to:
  /// **'Delete store'**
  String get deleteStore;

  /// No description provided for @deleteStoreNote.
  ///
  /// In en, this message translates to:
  /// **'Also deletes every expense and receipt linked to this store.'**
  String get deleteStoreNote;

  /// Confirm-dialog body when deleting a store that has linked expenses/receipts. Real ICU plural, never string concatenation (recorded bug count-plus-noun-concatenated-without-icu-plural).
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{This store has 1 linked record. Deleting the store deletes that record too. This cannot be undone.} other{This store has {n} linked records. Deleting the store deletes those records too. This cannot be undone.}}'**
  String deleteStoreBody(num n);

  /// No description provided for @deleteStoreBodyEmpty.
  ///
  /// In en, this message translates to:
  /// **'This store has no linked records. This cannot be undone.'**
  String get deleteStoreBodyEmpty;

  /// Auto-ported from i18n.js key "storeDeleted".
  ///
  /// In en, this message translates to:
  /// **'{n} deleted'**
  String storeDeleted(int n);

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get tabAnalytics;

  /// No description provided for @tabStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get tabStores;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAll;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A local-first expense tracker. Scan receipts or add cash expenses, and see where your money goes — all stored on this device.'**
  String get aboutDescription;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @langNote.
  ///
  /// In en, this message translates to:
  /// **'Changes the app language. Receipts keep their original text.'**
  String get langNote;

  /// No description provided for @currencyNote.
  ///
  /// In en, this message translates to:
  /// **'Used for totals and analytics. Receipts keep their printed currency.'**
  String get currencyNote;

  /// No description provided for @splashTag.
  ///
  /// In en, this message translates to:
  /// **'Your receipts, understood.'**
  String get splashTag;

  /// Auto-ported from i18n.js key "onDevice".
  ///
  /// In en, this message translates to:
  /// **'Everything stays on {device}'**
  String onDevice(String device);

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get noAccount;

  /// No description provided for @noUpload.
  ///
  /// In en, this message translates to:
  /// **'No upload'**
  String get noUpload;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @yourCurrency.
  ///
  /// In en, this message translates to:
  /// **'Your currency'**
  String get yourCurrency;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onb0Title.
  ///
  /// In en, this message translates to:
  /// **'Know where your money goes.'**
  String get onb0Title;

  /// No description provided for @onb0Point0.
  ///
  /// In en, this message translates to:
  /// **'Every receipt becomes structured spending'**
  String get onb0Point0;

  /// No description provided for @onb0Point1.
  ///
  /// In en, this message translates to:
  /// **'Categories and totals, no typing'**
  String get onb0Point1;

  /// No description provided for @onb0Point2.
  ///
  /// In en, this message translates to:
  /// **'Prices tracked over time'**
  String get onb0Point2;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'Scan receipts in seconds.'**
  String get onb1Title;

  /// No description provided for @onb1Point0.
  ///
  /// In en, this message translates to:
  /// **'Point the camera, the receipt is found'**
  String get onb1Point0;

  /// R2-8: converted to the {device} mechanism already used at onDevice/keepSafeBody/limitLocal/scanner_processing_sheet — spec section 4.4 omitted this 5th site, a spec-coverage gap, not an unwired call site.
  ///
  /// In en, this message translates to:
  /// **'Text is read on {device}'**
  String onb1Point1(String device);

  /// No description provided for @onb1Point2.
  ///
  /// In en, this message translates to:
  /// **'Products and prices extracted automatically'**
  String get onb1Point2;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on your device.'**
  String get onb2Title;

  /// No description provided for @onb2Point0.
  ///
  /// In en, this message translates to:
  /// **'Local-first, works offline'**
  String get onb2Point0;

  /// No description provided for @onb2Point1.
  ///
  /// In en, this message translates to:
  /// **'No account required'**
  String get onb2Point1;

  /// No description provided for @onb2Point2.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync can be enabled later'**
  String get onb2Point2;

  /// No description provided for @spentThisMonth.
  ///
  /// In en, this message translates to:
  /// **'spent this month'**
  String get spentThisMonth;

  /// Auto-ported from i18n.js key "vs".
  ///
  /// In en, this message translates to:
  /// **'vs {m}'**
  String vs(String m);

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scanReceipt;

  /// No description provided for @addCash.
  ///
  /// In en, this message translates to:
  /// **'Add Cash Expense'**
  String get addCash;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @onDeviceShort.
  ///
  /// In en, this message translates to:
  /// **'On device'**
  String get onDeviceShort;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get thisMonth;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @ofSpending.
  ///
  /// In en, this message translates to:
  /// **'of spending'**
  String get ofSpending;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @cashVsReceipts.
  ///
  /// In en, this message translates to:
  /// **'Cash vs receipts'**
  String get cashVsReceipts;

  /// No description provided for @receiptsLower.
  ///
  /// In en, this message translates to:
  /// **'receipts'**
  String get receiptsLower;

  /// No description provided for @cashLower.
  ///
  /// In en, this message translates to:
  /// **'cash'**
  String get cashLower;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// Auto-ported from i18n.js key "periodRange".
  ///
  /// In en, this message translates to:
  /// **'Records from {a} to {b}'**
  String periodRange(String a, String b);

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// Auto-ported from i18n.js key "pdfToast".
  ///
  /// In en, this message translates to:
  /// **'{m} report · PDF ready to share'**
  String pdfToast(String m);

  /// No description provided for @pdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the PDF report. Please try again.'**
  String get pdfExportFailed;

  /// No description provided for @analyticsEmptyMonthTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this month'**
  String get analyticsEmptyMonthTitle;

  /// No description provided for @analyticsEmptyMonthBody.
  ///
  /// In en, this message translates to:
  /// **'Pick another period to see your spending.'**
  String get analyticsEmptyMonthBody;

  /// Selected-category drill-down card heading on Analytics: category name, its total for the period, and the currency code.
  ///
  /// In en, this message translates to:
  /// **'{c} · {a} {cur}'**
  String analyticsCategoryTotal(String c, String a, String cur);

  /// Timestamp line printed in the exported PDF report.
  ///
  /// In en, this message translates to:
  /// **'Generated {d}'**
  String reportGeneratedAt(String d);

  /// Replaces the auto-ported i18n.js "purchase1"/"purchaseN" pair — that split-by-count-bucket shape is not a real ICU plural (it has no dedicated code call site and was never localized to non-English plural rules; recorded bug count-plus-noun-concatenated-without-icu-plural). This single key is the correct replacement shape for any future count+noun purchases string.
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{{n} purchase} other{{n} purchases}}'**
  String purchaseCount(num n);

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'top'**
  String get top;

  /// Auto-ported from i18n.js key "ins1".
  ///
  /// In en, this message translates to:
  /// **'Food represents {p}% of your spending.'**
  String ins1(int p);

  /// Auto-ported from i18n.js key "ins2".
  ///
  /// In en, this message translates to:
  /// **'{category} spending {direction} {percent}% this month.'**
  String ins2(String category, String direction, int percent);

  /// Auto-ported from i18n.js key "ins3".
  ///
  /// In en, this message translates to:
  /// **'Your average purchase increased from {a} to {b} {c}.'**
  String ins3(String a, String b, String c);

  /// Auto-ported from i18n.js key "insA1".
  ///
  /// In en, this message translates to:
  /// **'{category} represented {percent}% of your spending.'**
  String insA1(String category, int percent);

  /// Auto-ported from i18n.js key "insA2".
  ///
  /// In en, this message translates to:
  /// **'{category} spending fell {percent}% in {month}.'**
  String insA2(String category, int percent, String month);

  /// Auto-ported from i18n.js key "insA3". Fixed M6 deviation: the literal 157 was hardcoded in every language; now a real {value} placeholder.
  ///
  /// In en, this message translates to:
  /// **'Your average purchase was {value} {c}.'**
  String insA3(String value, String c);

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catHousehold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get catHousehold;

  /// No description provided for @catRestaurantsCoffee.
  ///
  /// In en, this message translates to:
  /// **'Restaurants & Coffee'**
  String get catRestaurantsCoffee;

  /// No description provided for @catRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get catRestaurants;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get catEntertainment;

  /// No description provided for @catUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get catUtilities;

  /// No description provided for @catTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get catTravel;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catPersonalCare.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get catPersonalCare;

  /// No description provided for @months0.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get months0;

  /// No description provided for @months1.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get months1;

  /// No description provided for @months2.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get months2;

  /// No description provided for @months3.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get months3;

  /// No description provided for @months4.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get months4;

  /// No description provided for @months5.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get months5;

  /// No description provided for @months6.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get months6;

  /// No description provided for @months7.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get months7;

  /// No description provided for @months8.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get months8;

  /// No description provided for @months9.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get months9;

  /// No description provided for @months10.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get months10;

  /// No description provided for @months11.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get months11;

  /// No description provided for @monthsShort0.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthsShort0;

  /// No description provided for @monthsShort1.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthsShort1;

  /// No description provided for @monthsShort2.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthsShort2;

  /// No description provided for @monthsShort3.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthsShort3;

  /// No description provided for @monthsShort4.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthsShort4;

  /// No description provided for @monthsShort5.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthsShort5;

  /// No description provided for @monthsShort6.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthsShort6;

  /// No description provided for @monthsShort7.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthsShort7;

  /// No description provided for @monthsShort8.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthsShort8;

  /// No description provided for @monthsShort9.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthsShort9;

  /// No description provided for @monthsShort10.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthsShort10;

  /// No description provided for @monthsShort11.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthsShort11;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @cashType.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashType;

  /// No description provided for @receipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receipts;

  /// No description provided for @newStore.
  ///
  /// In en, this message translates to:
  /// **'New store'**
  String get newStore;

  /// No description provided for @editStore.
  ///
  /// In en, this message translates to:
  /// **'Edit store'**
  String get editStore;

  /// No description provided for @changeStoreLogo.
  ///
  /// In en, this message translates to:
  /// **'Change logo'**
  String get changeStoreLogo;

  /// No description provided for @removeStoreLogo.
  ///
  /// In en, this message translates to:
  /// **'Remove logo'**
  String get removeStoreLogo;

  /// No description provided for @changeProductImage.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changeProductImage;

  /// No description provided for @removeProductImage.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removeProductImage;

  /// No description provided for @savingStore.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingStore;

  /// No description provided for @tStoreSaved.
  ///
  /// In en, this message translates to:
  /// **'Store updated'**
  String get tStoreSaved;

  /// No description provided for @storesIntro.
  ///
  /// In en, this message translates to:
  /// **'Built automatically from your receipts. Open a store to see its products and how their prices compare elsewhere.'**
  String get storesIntro;

  /// No description provided for @storesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No stores yet'**
  String get storesEmptyTitle;

  /// No description provided for @storesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a store to start tracking where you shop and how prices compare.'**
  String get storesEmptyBody;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @productsHere.
  ///
  /// In en, this message translates to:
  /// **'Products bought here'**
  String get productsHere;

  /// No description provided for @cmpNote.
  ///
  /// In en, this message translates to:
  /// **'Comparisons use your own receipts from the last 60 days, not live store prices.'**
  String get cmpNote;

  /// Converted to TWO independent real ICU plural blocks — v (visits) and p (products) are separate counts, both previously raw string interpolation (recorded bug count-plus-noun-concatenated-without-icu-plural, R2-10).
  ///
  /// In en, this message translates to:
  /// **'{v,plural, =1{1 visit} other{{v} visits}} · {p,plural, =1{1 product} other{{p} products}}'**
  String storeMeta(num v, num p);

  /// Auto-ported from i18n.js key "storeEmpty".
  ///
  /// In en, this message translates to:
  /// **'{t} · no receipts yet'**
  String storeEmpty(String t);

  /// Converted to a real ICU plural (recorded bug count-plus-noun-concatenated-without-icu-plural, R2-10). The design source (SpendLens Prototype.dc.html trMeta) has no plural noun here — pure numeral + "×" — so every ICU form renders identical visible text; the placeholder itself is what the signature requires, not new wording.
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{Bought 1×} other{Bought {n}×}}'**
  String bought(num n);

  /// No description provided for @byWeight.
  ///
  /// In en, this message translates to:
  /// **'by weight'**
  String get byWeight;

  /// Auto-ported from i18n.js key "cheapestOf". Converted to a real ICU plural — was raw string interpolation (recorded bug count-plus-noun-concatenated-without-icu-plural).
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{Cheapest of 1 store} other{Cheapest of {n} stores}}'**
  String cheapestOf(num n);

  /// Auto-ported from i18n.js key "cheaperBy".
  ///
  /// In en, this message translates to:
  /// **'{s} {p} · cheaper by {d}'**
  String cheaperBy(String s, int p, String d);

  /// Auto-ported from i18n.js key "cheaperHere".
  ///
  /// In en, this message translates to:
  /// **'{s} {p} /kg · cheaper here'**
  String cheaperHere(String s, int p);

  /// No description provided for @onlyHere.
  ///
  /// In en, this message translates to:
  /// **'Only bought here'**
  String get onlyHere;

  /// No description provided for @storeTypeSupermarket.
  ///
  /// In en, this message translates to:
  /// **'Supermarket'**
  String get storeTypeSupermarket;

  /// No description provided for @storeTypeMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get storeTypeMarket;

  /// No description provided for @storeTypePharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get storeTypePharmacy;

  /// No description provided for @storeTypeCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get storeTypeCafe;

  /// No description provided for @storeTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get storeTypeOther;

  /// No description provided for @storeTypeStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeTypeStore;

  /// No description provided for @chooseStore.
  ///
  /// In en, this message translates to:
  /// **'Choose store'**
  String get chooseStore;

  /// No description provided for @searchStorePh.
  ///
  /// In en, this message translates to:
  /// **'Search or type a new store'**
  String get searchStorePh;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @newStoreHint.
  ///
  /// In en, this message translates to:
  /// **'New store · future receipts will link to it'**
  String get newStoreHint;

  /// No description provided for @noMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching store yet'**
  String get noMatch;

  /// No description provided for @createNewStore.
  ///
  /// In en, this message translates to:
  /// **'Create new store'**
  String get createNewStore;

  /// No description provided for @createNewStoreSub.
  ///
  /// In en, this message translates to:
  /// **'Name, receipt alias and type'**
  String get createNewStoreSub;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @newStoreNote.
  ///
  /// In en, this message translates to:
  /// **'Receipts whose store name matches will be linked here automatically.'**
  String get newStoreNote;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @namePh.
  ///
  /// In en, this message translates to:
  /// **'e.g. Nr.1, Green Hills'**
  String get namePh;

  /// No description provided for @alias.
  ///
  /// In en, this message translates to:
  /// **'Also appears on receipts as'**
  String get alias;

  /// No description provided for @aliasPh.
  ///
  /// In en, this message translates to:
  /// **'Optional · e.g. NR1 SRL'**
  String get aliasPh;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @createStore.
  ///
  /// In en, this message translates to:
  /// **'Create store'**
  String get createStore;

  /// Auto-ported from i18n.js key "storeCreated".
  ///
  /// In en, this message translates to:
  /// **'{n} created and selected'**
  String storeCreated(int n);

  /// Auto-ported from i18n.js key "storeAdded".
  ///
  /// In en, this message translates to:
  /// **'{n} added · receipts will link automatically'**
  String storeAdded(int n);

  /// No description provided for @searchPh.
  ///
  /// In en, this message translates to:
  /// **'Search receipts, products, stores'**
  String get searchPh;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @keepSafe.
  ///
  /// In en, this message translates to:
  /// **'Keep your data safe'**
  String get keepSafe;

  /// Auto-ported from i18n.js key "keepSafeBody".
  ///
  /// In en, this message translates to:
  /// **'Your receipts live only on {device}. Sign in to back them up and sync across devices. Nothing is uploaded until you do.'**
  String keepSafeBody(String device);

  /// No description provided for @continueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueGoogle;

  /// No description provided for @continueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueApple;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get cloudSync;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get upToDate;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @yourData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get yourData;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @exportSheet.
  ///
  /// In en, this message translates to:
  /// **'Export spreadsheet'**
  String get exportSheet;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackup;

  /// No description provided for @exportNote.
  ///
  /// In en, this message translates to:
  /// **'Exports are shared through the iOS share sheet. Imports are validated before anything is restored.'**
  String get exportNote;

  /// No description provided for @localAccount.
  ///
  /// In en, this message translates to:
  /// **'Local account'**
  String get localAccount;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in · on device only'**
  String get notSignedIn;

  /// No description provided for @signedInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google'**
  String get signedInGoogle;

  /// No description provided for @signedInApple.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Apple'**
  String get signedInApple;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @cloudStorage.
  ///
  /// In en, this message translates to:
  /// **'Cloud storage'**
  String get cloudStorage;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited · on device'**
  String get unlimited;

  /// Auto-ported from i18n.js key "of".
  ///
  /// In en, this message translates to:
  /// **'{a} of {b}'**
  String storageOf(String a, String b);

  /// No description provided for @limitFree.
  ///
  /// In en, this message translates to:
  /// **'Receipt photos and data are backed up to your account. Free accounts include {quota}.'**
  String limitFree(String quota);

  /// Auto-ported from i18n.js key "limitPremium".
  ///
  /// In en, this message translates to:
  /// **'Premium: {quota} of cloud storage, unlimited history and multi-device sync.'**
  String limitPremium(String quota);

  /// Auto-ported from i18n.js key "limitLocal".
  ///
  /// In en, this message translates to:
  /// **'Everything is stored on {device} with no limit. Sign in to back it up.'**
  String limitLocal(String device);

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// Auto-ported from i18n.js key "toPremium".
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium · {quota} cloud storage'**
  String toPremium(String quota);

  /// Auto-ported from i18n.js key "tPremiumOn".
  ///
  /// In en, this message translates to:
  /// **'Premium activated · {quota}'**
  String tPremiumOn(String quota);

  /// Auto-ported from i18n.js key "tPremiumOff".
  ///
  /// In en, this message translates to:
  /// **'Back on Free plan · {quota}'**
  String tPremiumOff(String quota);

  /// No description provided for @tSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in · sync enabled'**
  String get tSignedIn;

  /// No description provided for @tSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out · data kept on device'**
  String get tSignedOut;

  /// Auto-ported from i18n.js key "tBackup".
  ///
  /// In en, this message translates to:
  /// **'Backup ready · {filename}'**
  String tBackup(String filename);

  /// Auto-ported from i18n.js key "tCsv". Converted to a real ICU plural — was raw string interpolation (recorded bug count-plus-noun-concatenated-without-icu-plural).
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{Spreadsheet ready · 1 row} other{Spreadsheet ready · {count} rows}}'**
  String tCsv(num count);

  /// No description provided for @tImport.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup file to validate'**
  String get tImport;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @receiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Receipt photo'**
  String get receiptPhoto;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @chooseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get chooseLibrary;

  /// No description provided for @pickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the image'**
  String get pickImageFailed;

  /// No description provided for @receiptPhotoEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No photo yet'**
  String get receiptPhotoEmptyTitle;

  /// No description provided for @receiptPhotoEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo of this receipt from your library.'**
  String get receiptPhotoEmptyBody;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @cashExpense.
  ///
  /// In en, this message translates to:
  /// **'Cash expense'**
  String get cashExpense;

  /// No description provided for @deleteReceipt.
  ///
  /// In en, this message translates to:
  /// **'Delete receipt'**
  String get deleteReceipt;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get deleteExpense;

  /// Auto-ported from i18n.js key "items". Converted to a real ICU plural — was raw string interpolation (recorded bug count-plus-noun-concatenated-without-icu-plural).
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =1{{n} item} other{{n} items}}'**
  String items(num n);

  /// No description provided for @photoStored.
  ///
  /// In en, this message translates to:
  /// **'receipt photo · stored on device'**
  String get photoStored;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'receipt photo · updated just now'**
  String get photoUpdated;

  /// Auto-ported from i18n.js key "photoTitle".
  ///
  /// In en, this message translates to:
  /// **'{n} · receipt'**
  String photoTitle(int n);

  /// No description provided for @tRetake.
  ///
  /// In en, this message translates to:
  /// **'Camera opens to retake · photo replaced'**
  String get tRetake;

  /// No description provided for @tLibrary.
  ///
  /// In en, this message translates to:
  /// **'Photo replaced from library'**
  String get tLibrary;

  /// No description provided for @tShare.
  ///
  /// In en, this message translates to:
  /// **'Sharing receipt photo…'**
  String get tShare;

  /// No description provided for @tOpenReceipt.
  ///
  /// In en, this message translates to:
  /// **'Open the receipt to correct items'**
  String get tOpenReceipt;

  /// Auto-ported from i18n.js key "tDeleted".
  ///
  /// In en, this message translates to:
  /// **'{t} deleted · {a}'**
  String tDeleted(String t, String a);

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Auto-ported from i18n.js key "tCashAdded".
  ///
  /// In en, this message translates to:
  /// **'{a} added'**
  String tCashAdded(String a);

  /// No description provided for @receiptDetected.
  ///
  /// In en, this message translates to:
  /// **'Receipt detected'**
  String get receiptDetected;

  /// No description provided for @looking.
  ///
  /// In en, this message translates to:
  /// **'Looking for a receipt…'**
  String get looking;

  /// No description provided for @holdStill.
  ///
  /// In en, this message translates to:
  /// **'Hold still'**
  String get holdStill;

  /// No description provided for @capturing.
  ///
  /// In en, this message translates to:
  /// **'Capturing…'**
  String get capturing;

  /// No description provided for @keepInFrame.
  ///
  /// In en, this message translates to:
  /// **'Keep the whole receipt inside the frame'**
  String get keepInFrame;

  /// No description provided for @autoCapture.
  ///
  /// In en, this message translates to:
  /// **'Capturing automatically'**
  String get autoCapture;

  /// No description provided for @flashAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get flashAuto;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get flashOn;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get flashOff;

  /// No description provided for @steps0.
  ///
  /// In en, this message translates to:
  /// **'Detecting receipt'**
  String get steps0;

  /// No description provided for @steps1.
  ///
  /// In en, this message translates to:
  /// **'Reading text'**
  String get steps1;

  /// No description provided for @steps2.
  ///
  /// In en, this message translates to:
  /// **'Finding products'**
  String get steps2;

  /// No description provided for @steps3.
  ///
  /// In en, this message translates to:
  /// **'Checking prices'**
  String get steps3;

  /// No description provided for @reviewReceipt.
  ///
  /// In en, this message translates to:
  /// **'Review receipt'**
  String get reviewReceipt;

  /// No description provided for @autoDetected.
  ///
  /// In en, this message translates to:
  /// **'Auto-detected'**
  String get autoDetected;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @qtyKg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get qtyKg;

  /// No description provided for @qtyL.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get qtyL;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @usedForPrice.
  ///
  /// In en, this message translates to:
  /// **'used for price history'**
  String get usedForPrice;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @itemsMatch.
  ///
  /// In en, this message translates to:
  /// **'Items add up to the printed total'**
  String get itemsMatch;

  /// Auto-ported from i18n.js key "itemsDiffer".
  ///
  /// In en, this message translates to:
  /// **'Items differ from printed total by {d}'**
  String itemsDiffer(String d);

  /// No description provided for @blurry.
  ///
  /// In en, this message translates to:
  /// **'Blurry or cut off? Retake the photo and the receipt is read again.'**
  String get blurry;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @saveReceipt.
  ///
  /// In en, this message translates to:
  /// **'Save Receipt'**
  String get saveReceipt;

  /// Auto-ported from i18n.js key "tSaved".
  ///
  /// In en, this message translates to:
  /// **'Receipt saved · {a}'**
  String tSaved(String a);

  /// No description provided for @tSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the receipt. Please try again.'**
  String get tSaveFailed;

  /// No description provided for @tSaveFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get tSaveFailedGeneric;

  /// Auto-ported from i18n.js key "checkThis".
  ///
  /// In en, this message translates to:
  /// **'Check this · read as \"{r}\" · {q}'**
  String checkThis(String r, String q);

  /// Auto-ported from i18n.js key "readAs".
  ///
  /// In en, this message translates to:
  /// **'Read as \"{r}\"'**
  String readAs(String r);

  /// No description provided for @lowConf.
  ///
  /// In en, this message translates to:
  /// **'low confidence'**
  String get lowConf;

  /// No description provided for @addedManually.
  ///
  /// In en, this message translates to:
  /// **'added manually'**
  String get addedManually;

  /// No description provided for @correctReceipt.
  ///
  /// In en, this message translates to:
  /// **'Correct receipt'**
  String get correctReceipt;

  /// No description provided for @editIntro.
  ///
  /// In en, this message translates to:
  /// **'Anything read incorrectly can be fixed here. The original receipt text stays attached for price history.'**
  String get editIntro;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @itemsTotal.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get itemsTotal;

  /// No description provided for @printedTotal.
  ///
  /// In en, this message translates to:
  /// **'Printed total'**
  String get printedTotal;

  /// No description provided for @applyCorrections.
  ///
  /// In en, this message translates to:
  /// **'Apply corrections'**
  String get applyCorrections;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'this device'**
  String get thisDevice;

  /// No description provided for @trendIncreased.
  ///
  /// In en, this message translates to:
  /// **'increased'**
  String get trendIncreased;

  /// No description provided for @trendDecreased.
  ///
  /// In en, this message translates to:
  /// **'decreased'**
  String get trendDecreased;

  /// No description provided for @homeNoExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get homeNoExpensesTitle;

  /// No description provided for @homeNoExpensesBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a few receipts to see your spending patterns.'**
  String get homeNoExpensesBody;

  /// No description provided for @scanFirstReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan your first receipt'**
  String get scanFirstReceipt;

  /// No description provided for @historyNoRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get historyNoRecordsTitle;

  /// No description provided for @historyNoRecordsBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt or add a cash expense to see it here.'**
  String get historyNoRecordsBody;

  /// No description provided for @historyNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching records'**
  String get historyNoMatchTitle;

  /// No description provided for @historyNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter.'**
  String get historyNoMatchBody;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterReceipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get filterReceipts;

  /// No description provided for @filterCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get filterCash;

  /// No description provided for @storeNoProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get storeNoProductsYet;

  /// No description provided for @storeNoProductsYetBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt from this store to see products and price comparisons here.'**
  String get storeNoProductsYetBody;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{n}\"? This cannot be undone.'**
  String deleteCategoryConfirm(String n);

  /// No description provided for @scanFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read this receipt clearly.'**
  String get scanFailedTitle;

  /// No description provided for @scanFailedTips.
  ///
  /// In en, this message translates to:
  /// **'Try:\n• Move to better lighting\n• Flatten the receipt\n• Keep the whole receipt inside the frame'**
  String get scanFailedTips;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get enterManually;

  /// No description provided for @deleteExpenseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get deleteExpenseConfirmTitle;

  /// No description provided for @deleteExpenseConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes this expense from your history. This can\'t be undone.'**
  String get deleteExpenseConfirmBody;

  /// No description provided for @recordNotFound.
  ///
  /// In en, this message translates to:
  /// **'This record no longer exists.'**
  String get recordNotFound;

  /// No description provided for @historyAllRecords.
  ///
  /// In en, this message translates to:
  /// **'All records'**
  String get historyAllRecords;

  /// No description provided for @recordNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted.'**
  String get recordNotFoundBody;

  /// No description provided for @priceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get priceHistoryTitle;

  /// M6: price-history page's overall first-to-last change line.
  ///
  /// In en, this message translates to:
  /// **'{direction} {percent}% since first tracked'**
  String priceHistoryChangeLabel(String direction, String percent);

  /// No description provided for @priceHistoryNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No price history yet'**
  String get priceHistoryNoDataTitle;

  /// No description provided for @priceHistoryNoDataBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt with this product to start tracking its price over time.'**
  String get priceHistoryNoDataBody;

  /// No description provided for @priceHistoryNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'This product no longer exists.'**
  String get priceHistoryNotFoundTitle;

  /// No description provided for @priceHistoryNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted.'**
  String get priceHistoryNotFoundBody;

  /// No description provided for @scanningStatus.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanningStatus;

  /// No description provided for @scanStatusSupported.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get scanStatusSupported;

  /// No description provided for @scanStatusChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get scanStatusChecking;

  /// No description provided for @scanStatusNoCamera.
  ///
  /// In en, this message translates to:
  /// **'No camera available'**
  String get scanStatusNoCamera;

  /// No description provided for @scanStatusOcrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Text recognition unavailable'**
  String get scanStatusOcrUnavailable;

  /// No description provided for @scanStatusPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission needed'**
  String get scanStatusPermissionDenied;

  /// No description provided for @scanStatusPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access blocked'**
  String get scanStatusPermissionPermanentlyDenied;

  /// No description provided for @scanStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check'**
  String get scanStatusUnavailable;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @scanUnsupportedNoCamera.
  ///
  /// In en, this message translates to:
  /// **'This device has no camera'**
  String get scanUnsupportedNoCamera;

  /// No description provided for @scanUnsupportedOcrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Text recognition isn\'t available on this device'**
  String get scanUnsupportedOcrUnavailable;

  /// No description provided for @scanUnsupportedPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is needed to scan receipts'**
  String get scanUnsupportedPermissionDenied;

  /// No description provided for @scanUnsupportedPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access is blocked — enable it in Settings'**
  String get scanUnsupportedPermissionPermanentlyDenied;

  /// No description provided for @scanUnsupportedUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check the camera — try again'**
  String get scanUnsupportedUnavailable;

  /// Duplicate-detector warning toast (design_spendlens.md §6/§46) — warns only, never blocks saving.
  ///
  /// In en, this message translates to:
  /// **'This looks like a receipt you already saved from {store} on {date}.'**
  String possibleDuplicateReceipt(String store, String date);

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup?'**
  String get importTitle;

  /// Import confirm dialog body (design_spendlens.md §6/§9/§11).
  ///
  /// In en, this message translates to:
  /// **'This adds every record from the file to what you already have. Matching records are updated; nothing already on {device} is removed.'**
  String importBody(String device);

  /// No description provided for @importConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get importConfirm;

  /// Import success toast (design_spendlens.md §6/§9/§11). Converted to a real ICU plural — was raw string interpolation (recorded bug count-plus-noun-concatenated-without-icu-plural).
  ///
  /// In en, this message translates to:
  /// **'Backup restored · {n,plural, =1{1 receipt} other{{n} receipts}}, {m,plural, =1{1 expense} other{{m} expenses}}'**
  String tImported(num n, num m);

  /// No description provided for @importMalformed.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a valid backup.'**
  String get importMalformed;

  /// No description provided for @importUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while restoring this backup.'**
  String get importUnexpected;

  /// No description provided for @importTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup was made with a newer version of the app.'**
  String get importTooNew;

  /// No description provided for @importCanceled.
  ///
  /// In en, this message translates to:
  /// **'No file selected.'**
  String get importCanceled;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncing;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get syncError;

  /// No description provided for @syncRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get syncRetry;

  /// No description provided for @syncDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sign in to back up'**
  String get syncDisabled;

  /// No description provided for @storageEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Photos are measured from your account — receipts, store logos and product images. Records add a negligible amount.'**
  String get storageEstimateNote;

  /// No description provided for @purchasesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases are unavailable right now.'**
  String get purchasesUnavailable;

  /// No description provided for @deleteScopeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete from where?'**
  String get deleteScopeTitle;

  /// No description provided for @deleteScopeLocal.
  ///
  /// In en, this message translates to:
  /// **'This device only'**
  String get deleteScopeLocal;

  /// No description provided for @deleteScopeRemote.
  ///
  /// In en, this message translates to:
  /// **'Cloud only'**
  String get deleteScopeRemote;

  /// No description provided for @deleteScopeBoth.
  ///
  /// In en, this message translates to:
  /// **'This device and the cloud'**
  String get deleteScopeBoth;

  /// Count of records awaiting upload.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 not synchronized} other{{count} not synchronized}}'**
  String syncPending(int count);

  /// Storage usage, e.g. "38 MB of 100 MB".
  ///
  /// In en, this message translates to:
  /// **'{used} of {total}'**
  String storageUsedOf(String used, String total);

  /// No description provided for @premiumUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get premiumUpgradeTitle;

  /// Premium upgrade sheet subtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited history, multi-device sync and {quota} of cloud storage.'**
  String premiumUpgradeSubtitle(String quota);

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @planYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get planYearly;

  /// No description provided for @planMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'€2.99 / month'**
  String get planMonthlyPrice;

  /// No description provided for @planYearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'€24.99 / year'**
  String get planYearlyPrice;

  /// No description provided for @planYearlyNote.
  ///
  /// In en, this message translates to:
  /// **'2 months free'**
  String get planYearlyNote;

  /// No description provided for @planBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get planBestValue;

  /// No description provided for @premiumFeatureHistory.
  ///
  /// In en, this message translates to:
  /// **'Unlimited receipt history'**
  String get premiumFeatureHistory;

  /// No description provided for @premiumFeatureSync.
  ///
  /// In en, this message translates to:
  /// **'Sync across your devices'**
  String get premiumFeatureSync;

  /// Premium benefit row naming the cloud quota.
  ///
  /// In en, this message translates to:
  /// **'{quota} of cloud storage'**
  String premiumFeatureStorage(String quota);

  /// No description provided for @premiumSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get premiumSubscribe;

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get premiumRestore;

  /// No description provided for @premiumRestoreNothing.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found.'**
  String get premiumRestoreNothing;

  /// No description provided for @premiumTerms.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically. Cancel anytime in the App Store.'**
  String get premiumTerms;

  /// No description provided for @syncPendingUpload.
  ///
  /// In en, this message translates to:
  /// **'Not synchronized'**
  String get syncPendingUpload;

  /// No description provided for @syncPendingDelete.
  ///
  /// In en, this message translates to:
  /// **'Waiting to delete'**
  String get syncPendingDelete;

  /// No description provided for @storageDetails.
  ///
  /// In en, this message translates to:
  /// **'Storage details'**
  String get storageDetails;

  /// No description provided for @photoSize.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoSize;

  /// No description provided for @documentSize.
  ///
  /// In en, this message translates to:
  /// **'Record data'**
  String get documentSize;

  /// No description provided for @noPhotoStored.
  ///
  /// In en, this message translates to:
  /// **'No photo'**
  String get noPhotoStored;

  /// No description provided for @cloudCopy.
  ///
  /// In en, this message translates to:
  /// **'Cloud copy'**
  String get cloudCopy;

  /// No description provided for @cloudCopyUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get cloudCopyUploaded;

  /// No description provided for @cloudCopyPending.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded yet'**
  String get cloudCopyPending;

  /// No description provided for @storageDetailsNote.
  ///
  /// In en, this message translates to:
  /// **'Only the photo counts toward your cloud storage. Record data is an estimate of what is uploaded for this receipt.'**
  String get storageDetailsNote;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get syncStatus;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Synchronize now'**
  String get syncNow;

  /// No description provided for @syncSection.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncSection;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Records already backed up will be removed from this device and restored when you sign in again. Anything not synchronized stays.'**
  String get signOutConfirmBody;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get nameHint;

  /// No description provided for @tProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get tProfileSaved;

  /// No description provided for @tProfileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile'**
  String get tProfileSaveFailed;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountSheetTitle;

  /// No description provided for @deleteAccountEverywhere.
  ///
  /// In en, this message translates to:
  /// **'Delete everywhere'**
  String get deleteAccountEverywhere;

  /// No description provided for @deleteAccountEverywhereBody.
  ///
  /// In en, this message translates to:
  /// **'Your account, all cloud data AND every record on this device. Nothing is kept.'**
  String get deleteAccountEverywhereBody;

  /// No description provided for @deleteAccountCloudOnly.
  ///
  /// In en, this message translates to:
  /// **'Delete account and cloud data'**
  String get deleteAccountCloudOnly;

  /// No description provided for @deleteAccountCloudOnlyBody.
  ///
  /// In en, this message translates to:
  /// **'Removes your account and everything stored in the cloud. Records on this device are kept.'**
  String get deleteAccountCloudOnlyBody;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmEverywhere.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account, all cloud data, and every record, receipt photo, store and category on this device. This cannot be undone.'**
  String get deleteAccountConfirmEverywhere;

  /// No description provided for @deleteAccountConfirmCloudOnly.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and everything stored in the cloud. Records on this device are kept. This cannot be undone.'**
  String get deleteAccountConfirmCloudOnly;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountConfirm;

  /// No description provided for @deletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account…'**
  String get deletingAccount;

  /// No description provided for @tAccountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get tAccountDeleted;

  /// No description provided for @deleteAccountSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your subscription stays active'**
  String get deleteAccountSubscriptionTitle;

  /// No description provided for @deleteAccountSubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account does not cancel your Premium subscription — billing is handled by the App Store and continues until you cancel it there.'**
  String get deleteAccountSubscriptionBody;

  /// No description provided for @deleteAccountSubscriptionAction.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get deleteAccountSubscriptionAction;

  /// No description provided for @savingProfile.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingProfile;

  /// No description provided for @uploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo…'**
  String get uploadingPhoto;

  /// No description provided for @processingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Processing photo…'**
  String get processingPhoto;

  /// No description provided for @productTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productTitle;

  /// No description provided for @generalPurpose.
  ///
  /// In en, this message translates to:
  /// **'General purpose'**
  String get generalPurpose;

  /// No description provided for @productNoStore.
  ///
  /// In en, this message translates to:
  /// **'Not tied to a store yet'**
  String get productNoStore;

  /// No description provided for @productPrices.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get productPrices;

  /// No description provided for @productNoPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'No prices yet'**
  String get productNoPricesTitle;

  /// No description provided for @productNoPricesBody.
  ///
  /// In en, this message translates to:
  /// **'Add a price to start tracking how it changes.'**
  String get productNoPricesBody;

  /// No description provided for @fromReceipt.
  ///
  /// In en, this message translates to:
  /// **'From receipt'**
  String get fromReceipt;

  /// No description provided for @editOnReceipt.
  ///
  /// In en, this message translates to:
  /// **'Edit on receipt'**
  String get editOnReceipt;

  /// No description provided for @addPrice.
  ///
  /// In en, this message translates to:
  /// **'Add price'**
  String get addPrice;

  /// No description provided for @addPriceSub.
  ///
  /// In en, this message translates to:
  /// **'Record what it costs today'**
  String get addPriceSub;

  /// No description provided for @editPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit price'**
  String get editPrice;

  /// No description provided for @deletePrice.
  ///
  /// In en, this message translates to:
  /// **'Delete price'**
  String get deletePrice;

  /// No description provided for @deletePriceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this price point? The chart will be recalculated.'**
  String get deletePriceConfirm;

  /// No description provided for @priceAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceAmountLabel;

  /// No description provided for @priceDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get priceDateLabel;

  /// No description provided for @priceStoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get priceStoreLabel;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @addProductSub.
  ///
  /// In en, this message translates to:
  /// **'Name it and record its first price'**
  String get addProductSub;

  /// No description provided for @newProductTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productNameLabel;

  /// No description provided for @productNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Milk 2.5% 1L'**
  String get productNameHint;

  /// No description provided for @productCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productCategoryLabel;

  /// No description provided for @productStoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get productStoreLabel;

  /// No description provided for @makeGeneralPurpose.
  ///
  /// In en, this message translates to:
  /// **'Make general purpose'**
  String get makeGeneralPurpose;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProduct;

  /// Confirm body for deleting a product, counting the price points that go with it.
  ///
  /// In en, this message translates to:
  /// **'{n,plural, =0{Delete this product?} =1{Delete this product and its 1 price point?} other{Delete this product and its {n} price points?}}'**
  String deleteProductConfirm(num n);

  /// No description provided for @chooseProduct.
  ///
  /// In en, this message translates to:
  /// **'Choose product'**
  String get chooseProduct;

  /// No description provided for @searchProductPh.
  ///
  /// In en, this message translates to:
  /// **'Search or type a new product'**
  String get searchProductPh;

  /// No description provided for @createNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Create new product'**
  String get createNewProduct;

  /// No description provided for @createNewProductSub.
  ///
  /// In en, this message translates to:
  /// **'Name, category and unit'**
  String get createNewProductSub;

  /// No description provided for @noMatchingProduct.
  ///
  /// In en, this message translates to:
  /// **'No matching product yet'**
  String get noMatchingProduct;

  /// No description provided for @newProductHint.
  ///
  /// In en, this message translates to:
  /// **'New product · future receipts will link to it'**
  String get newProductHint;

  /// No description provided for @pickProduct.
  ///
  /// In en, this message translates to:
  /// **'Pick product'**
  String get pickProduct;

  /// No description provided for @productUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get productUnitLabel;

  /// No description provided for @tabCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get tabCompare;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare stores'**
  String get compareTitle;

  /// No description provided for @compareNeedsTwoStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a second store'**
  String get compareNeedsTwoStoresTitle;

  /// No description provided for @compareNeedsTwoStoresBody.
  ///
  /// In en, this message translates to:
  /// **'Comparing needs at least two stores.'**
  String get compareNeedsTwoStoresBody;

  /// No description provided for @compareNoProductsHere.
  ///
  /// In en, this message translates to:
  /// **'No products at this store yet.'**
  String get compareNoProductsHere;

  /// No description provided for @compareNoPrice.
  ///
  /// In en, this message translates to:
  /// **'No price yet'**
  String get compareNoPrice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ro',
    'ru',
    'uk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
