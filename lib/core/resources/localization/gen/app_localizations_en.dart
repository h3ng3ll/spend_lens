// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get deleteAllTitle => 'Delete all data?';

  @override
  String deleteAllBody(int n, String device) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'This removes $nString records, receipt photos, stores and categories from $device. Cloud backups are not affected. This cannot be undone.';
  }

  @override
  String get deleteAllConfirm => 'Delete everything';

  @override
  String get tDeletedAll => 'All data deleted';

  @override
  String get renameCategory => 'Rename category';

  @override
  String catRenamed(String n) {
    return 'Renamed to $n';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get categoryEmpty => 'No categories yet';

  @override
  String get createCategory => 'Create category';

  @override
  String get newCatPh => 'New category name';

  @override
  String get searchCatPh => 'Search or type a new category';

  @override
  String get newCatHint => 'New category · appears in every category picker';

  @override
  String get catNote =>
      'Built-in categories cannot be deleted. Custom categories can be removed while unused.';

  @override
  String get catDefault => 'Built-in';

  @override
  String get catCustom => 'Custom · unused';

  @override
  String catUsed(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Custom · $nString records';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString created';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString deleted';
  }

  @override
  String get noStore => 'No store';

  @override
  String get deleteStore => 'Delete store';

  @override
  String get deleteStoreNote => 'Only possible while no receipts are linked.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString deleted';
  }

  @override
  String get tabHome => 'Home';

  @override
  String get tabAnalytics => 'Analytics';

  @override
  String get tabStores => 'Stores';

  @override
  String get tabHistory => 'History';

  @override
  String get tabSettings => 'Settings';

  @override
  String get settings => 'Settings';

  @override
  String get currency => 'Currency';

  @override
  String get categories => 'Categories';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get deleteAll => 'Delete all data';

  @override
  String get privacy => 'Privacy';

  @override
  String get about => 'About';

  @override
  String get aboutDescription =>
      'A local-first expense tracker. Scan receipts or add cash expenses, and see where your money goes — all stored on this device.';

  @override
  String get done => 'Done';

  @override
  String get langNote =>
      'Changes the app language. Receipts keep their original text.';

  @override
  String get currencyNote =>
      'Used for totals and analytics. Receipts keep their printed currency.';

  @override
  String get splashTag => 'Your receipts, understood.';

  @override
  String onDevice(String device) {
    return 'Everything stays on $device';
  }

  @override
  String get skip => 'Skip';

  @override
  String get noAccount => 'No account';

  @override
  String get noUpload => 'No upload';

  @override
  String get offline => 'Offline';

  @override
  String get yourCurrency => 'Your currency';

  @override
  String get continue_ => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onb0Title => 'Know where your money goes.';

  @override
  String get onb0Point0 => 'Every receipt becomes structured spending';

  @override
  String get onb0Point1 => 'Categories and totals, no typing';

  @override
  String get onb0Point2 => 'Prices tracked over time';

  @override
  String get onb1Title => 'Scan receipts in seconds.';

  @override
  String get onb1Point0 => 'Point the camera, the receipt is found';

  @override
  String get onb1Point1 => 'Text is read on your iPhone';

  @override
  String get onb1Point2 => 'Products and prices extracted automatically';

  @override
  String get onb2Title => 'Your data stays on your device.';

  @override
  String get onb2Point0 => 'Local-first, works offline';

  @override
  String get onb2Point1 => 'No account required';

  @override
  String get onb2Point2 => 'Cloud sync can be enabled later';

  @override
  String get spentThisMonth => 'spent this month';

  @override
  String vs(String m) {
    return 'vs $m';
  }

  @override
  String get scanReceipt => 'Scan Receipt';

  @override
  String get addCash => 'Add Cash Expense';

  @override
  String get all => 'All';

  @override
  String get recent => 'Recent';

  @override
  String get seeAll => 'See all';

  @override
  String get onDeviceShort => 'On device';

  @override
  String get synced => 'Synced';

  @override
  String get average => 'Average';

  @override
  String get purchases => 'Purchases';

  @override
  String get thisMonth => 'this month';

  @override
  String get cash => 'Cash';

  @override
  String get ofSpending => 'of spending';

  @override
  String get insights => 'Insights';

  @override
  String get cashVsReceipts => 'Cash vs receipts';

  @override
  String get receiptsLower => 'receipts';

  @override
  String get cashLower => 'cash';

  @override
  String get period => 'Period';

  @override
  String periodRange(String a, String b) {
    return 'Records from $a to $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable => 'PDF export arrives in a later update.';

  @override
  String get signInComingSoon => 'Sign-in arrives in a later update.';

  @override
  String get exportComingSoon => 'Export and import arrive in a later update.';

  @override
  String pdfToast(String m) {
    return '$m report · PDF ready to share';
  }

  @override
  String purchase1(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString purchase';
  }

  @override
  String purchaseN(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString purchases';
  }

  @override
  String get top => 'top';

  @override
  String ins1(int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return 'Food represents $pString% of your spending.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category spending $direction $percentString% this month.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Your average purchase increased from $a to $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category represented $percentString% of your spending.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category spending fell $percentString% in $month.';
  }

  @override
  String insA3(String value, String c) {
    return 'Your average purchase was $value $c.';
  }

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catHousehold => 'Household';

  @override
  String get catRestaurantsCoffee => 'Restaurants & Coffee';

  @override
  String get catRestaurants => 'Restaurants';

  @override
  String get catHealth => 'Health';

  @override
  String get catOther => 'Other';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catUtilities => 'Utilities';

  @override
  String get catTravel => 'Travel';

  @override
  String get catEducation => 'Education';

  @override
  String get catPersonalCare => 'Personal Care';

  @override
  String get months0 => 'January';

  @override
  String get months1 => 'February';

  @override
  String get months2 => 'March';

  @override
  String get months3 => 'April';

  @override
  String get months4 => 'May';

  @override
  String get months5 => 'June';

  @override
  String get months6 => 'July';

  @override
  String get months7 => 'August';

  @override
  String get months8 => 'September';

  @override
  String get months9 => 'October';

  @override
  String get months10 => 'November';

  @override
  String get months11 => 'December';

  @override
  String get monthsShort0 => 'Jan';

  @override
  String get monthsShort1 => 'Feb';

  @override
  String get monthsShort2 => 'Mar';

  @override
  String get monthsShort3 => 'Apr';

  @override
  String get monthsShort4 => 'May';

  @override
  String get monthsShort5 => 'Jun';

  @override
  String get monthsShort6 => 'Jul';

  @override
  String get monthsShort7 => 'Aug';

  @override
  String get monthsShort8 => 'Sep';

  @override
  String get monthsShort9 => 'Oct';

  @override
  String get monthsShort10 => 'Nov';

  @override
  String get monthsShort11 => 'Dec';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get receipt => 'Receipt';

  @override
  String get cashType => 'Cash';

  @override
  String get receipts => 'Receipts';

  @override
  String get newStore => 'New store';

  @override
  String get storesIntro =>
      'Built automatically from your receipts. Open a store to see its products and how their prices compare elsewhere.';

  @override
  String get storesEmptyTitle => 'No stores yet';

  @override
  String get storesEmptyBody =>
      'Add a store to start tracking where you shop and how prices compare.';

  @override
  String get visits => 'Visits';

  @override
  String get spent => 'Spent';

  @override
  String get products => 'Products';

  @override
  String get productsHere => 'Products bought here';

  @override
  String get cmpNote =>
      'Comparisons use your own receipts from the last 60 days, not live store prices.';

  @override
  String storeMeta(int v, int p) {
    final intl.NumberFormat vNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String vString = vNumberFormat.format(v);
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$vString visits · $pString products';
  }

  @override
  String storeEmpty(String t) {
    return '$t · no receipts yet';
  }

  @override
  String bought(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Bought $nString×';
  }

  @override
  String get byWeight => 'by weight';

  @override
  String cheapestOf(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Cheapest of $nString stores';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · cheaper by $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /kg · cheaper here';
  }

  @override
  String get onlyHere => 'Only bought here';

  @override
  String get storeTypeSupermarket => 'Supermarket';

  @override
  String get storeTypeMarket => 'Market';

  @override
  String get storeTypePharmacy => 'Pharmacy';

  @override
  String get storeTypeCafe => 'Café';

  @override
  String get storeTypeOther => 'Other';

  @override
  String get storeTypeStore => 'Store';

  @override
  String get chooseStore => 'Choose store';

  @override
  String get searchStorePh => 'Search or type a new store';

  @override
  String get create => 'Create';

  @override
  String get newStoreHint => 'New store · future receipts will link to it';

  @override
  String get noMatch => 'No matching store yet';

  @override
  String get createNewStore => 'Create new store';

  @override
  String get createNewStoreSub => 'Name, receipt alias and type';

  @override
  String get cancel => 'Cancel';

  @override
  String get newStoreNote =>
      'Receipts whose store name matches will be linked here automatically.';

  @override
  String get name => 'Name';

  @override
  String get namePh => 'e.g. Nr.1, Green Hills';

  @override
  String get alias => 'Also appears on receipts as';

  @override
  String get aliasPh => 'Optional · e.g. NR1 SRL';

  @override
  String get type => 'Type';

  @override
  String get createStore => 'Create store';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString created and selected';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString added · receipts will link automatically';
  }

  @override
  String get searchPh => 'Search receipts, products, stores';

  @override
  String get profile => 'Profile';

  @override
  String get keepSafe => 'Keep your data safe';

  @override
  String keepSafeBody(String device) {
    return 'Your receipts live only on $device. Sign in to back them up and sync across devices. Nothing is uploaded until you do.';
  }

  @override
  String get continueGoogle => 'Continue with Google';

  @override
  String get continueApple => 'Continue with Apple';

  @override
  String get account => 'Account';

  @override
  String get plan => 'Plan';

  @override
  String get cloudSync => 'Cloud sync';

  @override
  String get upToDate => 'Up to date';

  @override
  String get signOut => 'Sign out';

  @override
  String get yourData => 'Your data';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get exportSheet => 'Export spreadsheet';

  @override
  String get importBackup => 'Import backup';

  @override
  String get exportNote =>
      'Exports are shared through the iOS share sheet. Imports are validated before anything is restored.';

  @override
  String get localAccount => 'Local account';

  @override
  String get notSignedIn => 'Not signed in · on device only';

  @override
  String get signedInGoogle => 'Signed in with Google';

  @override
  String get storage => 'Storage';

  @override
  String get cloudStorage => 'Cloud storage';

  @override
  String get unlimited => 'Unlimited · on device';

  @override
  String storageOf(String a, String b) {
    return '$a of $b';
  }

  @override
  String limitFree(String quota) {
    return 'Receipt photos and data are backed up to your account. Free accounts include $quota.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium: $quota of cloud storage, unlimited history and multi-device sync.';
  }

  @override
  String limitLocal(String device) {
    return 'Everything is stored on $device with no limit. Sign in to back it up.';
  }

  @override
  String get free => 'Free';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Upgrade to Premium · $quota cloud storage';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium activated · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'Back on Free plan · $quota';
  }

  @override
  String get tSignedIn => 'Signed in · sync enabled';

  @override
  String get tSignedOut => 'Signed out · data kept on device';

  @override
  String tBackup(String filename) {
    return 'Backup ready · $filename';
  }

  @override
  String tCsv(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Spreadsheet ready · $countString rows';
  }

  @override
  String get tImport => 'Choose a backup file to validate';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get edit => 'Edit';

  @override
  String get note => 'Note';

  @override
  String get receiptPhoto => 'Receipt photo';

  @override
  String get view => 'View';

  @override
  String get retake => 'Retake';

  @override
  String get chooseLibrary => 'Choose from library';

  @override
  String get share => 'Share';

  @override
  String get cashExpense => 'Cash expense';

  @override
  String get deleteReceipt => 'Delete receipt';

  @override
  String get deleteExpense => 'Delete expense';

  @override
  String items(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString items';
  }

  @override
  String get photoStored => 'receipt photo · stored on device';

  @override
  String get photoUpdated => 'receipt photo · updated just now';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · receipt';
  }

  @override
  String get tRetake => 'Camera opens to retake · photo replaced';

  @override
  String get tLibrary => 'Photo replaced from library';

  @override
  String get tShare => 'Sharing receipt photo…';

  @override
  String get tOpenReceipt => 'Open the receipt to correct items';

  @override
  String tDeleted(String t, String a) {
    return '$t deleted · $a';
  }

  @override
  String get expense => 'Expense';

  @override
  String get amount => 'Amount';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get category => 'Category';

  @override
  String get optional => 'Optional';

  @override
  String get date => 'Date';

  @override
  String get save => 'Save';

  @override
  String tCashAdded(String a) {
    return '$a added';
  }

  @override
  String get receiptDetected => 'Receipt detected';

  @override
  String get looking => 'Looking for a receipt…';

  @override
  String get holdStill => 'Hold still';

  @override
  String get capturing => 'Capturing…';

  @override
  String get keepInFrame => 'Keep the whole receipt inside the frame';

  @override
  String get autoCapture => 'Capturing automatically';

  @override
  String get flashAuto => 'Auto';

  @override
  String get flashOn => 'On';

  @override
  String get flashOff => 'Off';

  @override
  String get steps0 => 'Detecting receipt';

  @override
  String get steps1 => 'Reading text';

  @override
  String get steps2 => 'Finding products';

  @override
  String get steps3 => 'Checking prices';

  @override
  String get reviewReceipt => 'Review receipt';

  @override
  String get autoDetected => 'Auto-detected';

  @override
  String get addItem => 'Add item';

  @override
  String get qty => 'Qty';

  @override
  String get total => 'Total';

  @override
  String get usedForPrice => 'used for price history';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get itemsMatch => 'Items add up to the printed total';

  @override
  String itemsDiffer(String d) {
    return 'Items differ from printed total by $d';
  }

  @override
  String get blurry =>
      'Blurry or cut off? Retake the photo and the receipt is read again.';

  @override
  String get correct => 'Correct';

  @override
  String get saveReceipt => 'Save Receipt';

  @override
  String tSaved(String a) {
    return 'Receipt saved · $a';
  }

  @override
  String checkThis(String r, String q) {
    return 'Check this · read as \"$r\" · $q';
  }

  @override
  String readAs(String r) {
    return 'Read as \"$r\"';
  }

  @override
  String get lowConf => 'low confidence';

  @override
  String get addedManually => 'added manually';

  @override
  String get correctReceipt => 'Correct receipt';

  @override
  String get editIntro =>
      'Anything read incorrectly can be fixed here. The original receipt text stays attached for price history.';

  @override
  String get store => 'Store';

  @override
  String get change => 'Change';

  @override
  String get time => 'Time';

  @override
  String get itemsLabel => 'Items';

  @override
  String get price => 'Price';

  @override
  String get itemsTotal => 'Items total';

  @override
  String get printedTotal => 'Printed total';

  @override
  String get applyCorrections => 'Apply corrections';

  @override
  String get thisDevice => 'this device';

  @override
  String get trendIncreased => 'increased';

  @override
  String get trendDecreased => 'decreased';

  @override
  String get homeNoExpensesTitle => 'No expenses yet';

  @override
  String get homeNoExpensesBody =>
      'Scan a few receipts to see your spending patterns.';

  @override
  String get scanFirstReceipt => 'Scan your first receipt';

  @override
  String get scanComingSoon => 'Scanning arrives in a later update';

  @override
  String get historyNoRecordsTitle => 'No records yet';

  @override
  String get historyNoRecordsBody =>
      'Scan a receipt or add a cash expense to see it here.';

  @override
  String get historyNoMatchTitle => 'No matching records';

  @override
  String get historyNoMatchBody => 'Try a different search or filter.';

  @override
  String get filterAll => 'All';

  @override
  String get filterReceipts => 'Receipts';

  @override
  String get filterCash => 'Cash';

  @override
  String get storeNoProductsYet => 'No products yet';

  @override
  String get storeNoProductsYetBody =>
      'Scan a receipt from this store to see products and price comparisons here.';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String deleteCategoryConfirm(String n) {
    return 'Delete \"$n\"? This cannot be undone.';
  }

  @override
  String get scanFailedTitle => 'We couldn\'t read this receipt clearly.';

  @override
  String get scanFailedTips =>
      'Try:\n• Move to better lighting\n• Flatten the receipt\n• Keep the whole receipt inside the frame';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get enterManually => 'Enter Manually';

  @override
  String get deleteExpenseConfirmTitle => 'Delete this expense?';

  @override
  String get deleteExpenseConfirmBody =>
      'This permanently removes this expense from your history. This can\'t be undone.';

  @override
  String get recordNotFound => 'This record no longer exists.';

  @override
  String get editComingSoon => 'Editing arrives in a later update.';

  @override
  String get historyAllRecords => 'All records';

  @override
  String get recordNotFoundBody => 'It may have been deleted.';

  @override
  String get priceHistoryTitle => 'Price history';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction $percent% since first tracked';
  }

  @override
  String get priceHistoryNoDataTitle => 'No price history yet';

  @override
  String get priceHistoryNoDataBody =>
      'Scan a receipt with this product to start tracking its price over time.';

  @override
  String get priceHistoryNotFoundTitle => 'This product no longer exists.';

  @override
  String get priceHistoryNotFoundBody => 'It may have been deleted.';

  @override
  String get scanningStatus => 'Scanning';

  @override
  String get scanStatusSupported => 'Ready';

  @override
  String get scanStatusChecking => 'Checking…';

  @override
  String get scanStatusNoCamera => 'No camera available';

  @override
  String get scanStatusOcrUnavailable => 'Text recognition unavailable';

  @override
  String get scanStatusPermissionDenied => 'Camera permission needed';

  @override
  String get scanStatusPermissionPermanentlyDenied => 'Camera access blocked';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get scanUnsupportedNoCamera => 'This device has no camera';

  @override
  String get scanUnsupportedOcrUnavailable =>
      'Text recognition isn\'t available on this device';

  @override
  String get scanUnsupportedPermissionDenied =>
      'Camera permission is needed to scan receipts';

  @override
  String get scanUnsupportedPermissionPermanentlyDenied =>
      'Camera access is blocked — enable it in Settings';
}
