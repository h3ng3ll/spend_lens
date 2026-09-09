// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get deleteAllTitle => 'Видалити всі дані?';

  @override
  String deleteAllBody(num n, String device) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          'Буде видалено $nString запису, фото чеків, магазини та категорії з $device. Хмарні копії не зачеплені. Скасувати неможливо.',
      many:
          'Буде видалено $nString записів, фото чеків, магазини та категорії з $device. Хмарні копії не зачеплені. Скасувати неможливо.',
      few:
          'Буде видалено $nString записи, фото чеків, магазини та категорії з $device. Хмарні копії не зачеплені. Скасувати неможливо.',
      one:
          'Буде видалено $nString запис, фото чеків, магазини та категорії з $device. Хмарні копії не зачеплені. Скасувати неможливо.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllConfirm => 'Видалити все';

  @override
  String get tDeletedAll => 'Усі дані видалено';

  @override
  String get renameCategory => 'Перейменувати категорію';

  @override
  String catRenamed(String n) {
    return 'Перейменовано на $n';
  }

  @override
  String get newCategory => 'Нова категорія';

  @override
  String get categoryEmpty => 'Поки що немає категорій';

  @override
  String get createCategory => 'Створити категорію';

  @override
  String get newCatPh => 'Назва нової категорії';

  @override
  String get searchCatPh => 'Пошук або нова категорія';

  @override
  String get newCatHint => 'Нова категорія · з’явиться в усіх списках';

  @override
  String get catNote =>
      'Вбудовані категорії не видаляються. Власні можна видалити, доки вони не використовуються.';

  @override
  String get catDefault => 'Вбудована';

  @override
  String get catCustom => 'Власна · не використовується';

  @override
  String catUsed(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Власна · $nString запису',
      many: 'Власна · $nString записів',
      few: 'Власна · $nString записи',
      one: 'Власна · $nString запис',
    );
    return '$_temp0';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString створено';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString видалено';
  }

  @override
  String get noStore => 'Без магазину';

  @override
  String get deleteStore => 'Видалити магазин';

  @override
  String get deleteStoreNote =>
      'Доступно, доки до магазину не прив’язані чеки.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString видалено';
  }

  @override
  String get tabHome => 'Головна';

  @override
  String get tabAnalytics => 'Аналітика';

  @override
  String get tabStores => 'Магазини';

  @override
  String get tabHistory => 'Історія';

  @override
  String get tabSettings => 'Налаштування';

  @override
  String get settings => 'Налаштування';

  @override
  String get currency => 'Валюта';

  @override
  String get categories => 'Категорії';

  @override
  String get language => 'Мова';

  @override
  String get languageSystemDefault => 'Як у системі';

  @override
  String get appearance => 'Оформлення';

  @override
  String get deleteAll => 'Видалити всі дані';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get about => 'Про застосунок';

  @override
  String get aboutDescription =>
      'Локальний трекер витрат. Скануйте чеки або додавайте готівкові витрати та дивіться, куди йдуть гроші — усе зберігається на цьому пристрої.';

  @override
  String get done => 'Готово';

  @override
  String get langNote =>
      'Змінює мову застосунку. Текст чеків залишається оригінальним.';

  @override
  String get currencyNote =>
      'Використовується для підсумків і аналітики. Чеки зберігають надруковану валюту.';

  @override
  String get splashTag => 'Ваші чеки — зрозумілі.';

  @override
  String onDevice(String device) {
    return 'Усе залишається на $device';
  }

  @override
  String get skip => 'Пропустити';

  @override
  String get noAccount => 'Без акаунта';

  @override
  String get noUpload => 'Без завантаження';

  @override
  String get offline => 'Офлайн';

  @override
  String get yourCurrency => 'Ваша валюта';

  @override
  String get continue_ => 'Далі';

  @override
  String get getStarted => 'Почати';

  @override
  String get onb0Title => 'Знайте, куди йдуть гроші.';

  @override
  String get onb0Point0 => 'Кожен чек стає структурованою витратою';

  @override
  String get onb0Point1 => 'Категорії та підсумки без введення';

  @override
  String get onb0Point2 => 'Ціни відстежуються в часі';

  @override
  String get onb1Title => 'Скануйте чеки за секунди.';

  @override
  String get onb1Point0 => 'Наведіть камеру — чек знайдено';

  @override
  String onb1Point1(String device) {
    return 'Текст читається на $device';
  }

  @override
  String get onb1Point2 => 'Товари й ціни витягуються автоматично';

  @override
  String get onb2Title => 'Дані залишаються на пристрої.';

  @override
  String get onb2Point0 => 'Local-first, працює офлайн';

  @override
  String get onb2Point1 => 'Акаунт не потрібен';

  @override
  String get onb2Point2 => 'Хмарну синхронізацію можна ввімкнути пізніше';

  @override
  String get spentThisMonth => 'витрачено цього місяця';

  @override
  String vs(String m) {
    return 'до $m';
  }

  @override
  String get scanReceipt => 'Сканувати чек';

  @override
  String get addCash => 'Додати готівку';

  @override
  String get all => 'Усі';

  @override
  String get recent => 'Недавні';

  @override
  String get seeAll => 'Усі';

  @override
  String get onDeviceShort => 'На пристрої';

  @override
  String get synced => 'Синхронізовано';

  @override
  String get average => 'Середня';

  @override
  String get purchases => 'Покупки';

  @override
  String get thisMonth => 'цього місяця';

  @override
  String get cash => 'Готівка';

  @override
  String get ofSpending => 'від витрат';

  @override
  String get insights => 'Спостереження';

  @override
  String get cashVsReceipts => 'Готівка та чеки';

  @override
  String get receiptsLower => 'чеки';

  @override
  String get cashLower => 'готівка';

  @override
  String get period => 'Період';

  @override
  String periodRange(String a, String b) {
    return 'Записи з $a по $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable =>
      'Експорт у PDF з’явиться в одному з наступних оновлень.';

  @override
  String pdfToast(String m) {
    return 'Звіт $m · PDF готовий';
  }

  @override
  String purchaseCount(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString покупки',
      many: '$nString покупок',
      few: '$nString покупки',
      one: '$nString покупка',
    );
    return '$_temp0';
  }

  @override
  String get top => 'топ';

  @override
  String ins1(int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return 'Продукти — $pString% ваших витрат.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Витрати на $category $direction на $percentString% цього місяця.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Середня покупка зросла з $a до $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category становили $percentString% витрат.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Витрати на $category знизилися на $percentString% у $month.';
  }

  @override
  String insA3(String value, String c) {
    return 'Середня покупка була $value $c.';
  }

  @override
  String get catFood => 'Продукти';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catHousehold => 'Дім';

  @override
  String get catRestaurantsCoffee => 'Ресторани та кава';

  @override
  String get catRestaurants => 'Ресторани';

  @override
  String get catHealth => 'Здоров\'я';

  @override
  String get catOther => 'Інше';

  @override
  String get catShopping => 'Покупки';

  @override
  String get catEntertainment => 'Розваги';

  @override
  String get catUtilities => 'Комунальні послуги';

  @override
  String get catTravel => 'Подорожі';

  @override
  String get catEducation => 'Освіта';

  @override
  String get catPersonalCare => 'Особиста гігієна';

  @override
  String get months0 => 'Січень';

  @override
  String get months1 => 'Лютий';

  @override
  String get months2 => 'Березень';

  @override
  String get months3 => 'Квітень';

  @override
  String get months4 => 'Травень';

  @override
  String get months5 => 'Червень';

  @override
  String get months6 => 'Липень';

  @override
  String get months7 => 'Серпень';

  @override
  String get months8 => 'Вересень';

  @override
  String get months9 => 'Жовтень';

  @override
  String get months10 => 'Листопад';

  @override
  String get months11 => 'Грудень';

  @override
  String get monthsShort0 => 'Січ';

  @override
  String get monthsShort1 => 'Лют';

  @override
  String get monthsShort2 => 'Бер';

  @override
  String get monthsShort3 => 'Кві';

  @override
  String get monthsShort4 => 'Тра';

  @override
  String get monthsShort5 => 'Чер';

  @override
  String get monthsShort6 => 'Лип';

  @override
  String get monthsShort7 => 'Сер';

  @override
  String get monthsShort8 => 'Вер';

  @override
  String get monthsShort9 => 'Жов';

  @override
  String get monthsShort10 => 'Лис';

  @override
  String get monthsShort11 => 'Гру';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Вчора';

  @override
  String get receipt => 'Чек';

  @override
  String get cashType => 'Готівка';

  @override
  String get receipts => 'Чеки';

  @override
  String get newStore => 'Новий магазин';

  @override
  String get storesIntro =>
      'Створюється автоматично з чеків. Відкрийте магазин, щоб побачити товари та порівняння цін.';

  @override
  String get storesEmptyTitle => 'Ще немає магазинів';

  @override
  String get storesEmptyBody =>
      'Додайте магазин, щоб відстежувати, де ви купуєте, і порівнювати ціни.';

  @override
  String get visits => 'Візити';

  @override
  String get spent => 'Витрачено';

  @override
  String get products => 'Товари';

  @override
  String get productsHere => 'Куплено тут';

  @override
  String get cmpNote =>
      'Порівняння за вашими чеками за останні 60 днів, а не за живими цінами.';

  @override
  String storeMeta(num v, num p) {
    final intl.NumberFormat vNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String vString = vNumberFormat.format(v);
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    String _temp0 = intl.Intl.pluralLogic(
      v,
      locale: localeName,
      other: '$vString візиту',
      many: '$vString візитів',
      few: '$vString візити',
      one: '$vString візит',
    );
    String _temp1 = intl.Intl.pluralLogic(
      p,
      locale: localeName,
      other: '$pString товару',
      many: '$pString товарів',
      few: '$pString товари',
      one: '$pString товар',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String storeEmpty(String t) {
    return '$t · чеків ще немає';
  }

  @override
  String bought(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Куплено $nString×',
      many: 'Куплено $nString×',
      few: 'Куплено $nString×',
      one: 'Куплено $nString×',
    );
    return '$_temp0';
  }

  @override
  String get byWeight => 'на вагу';

  @override
  String cheapestOf(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Найдешевше з $nString магазину',
      many: 'Найдешевше з $nString магазинів',
      few: 'Найдешевше з $nString магазинів',
      one: 'Найдешевше з $nString магазину',
    );
    return '$_temp0';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · дешевше на $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /кг · тут дешевше';
  }

  @override
  String get onlyHere => 'Куплено лише тут';

  @override
  String get storeTypeSupermarket => 'Супермаркет';

  @override
  String get storeTypeMarket => 'Ринок';

  @override
  String get storeTypePharmacy => 'Аптека';

  @override
  String get storeTypeCafe => 'Кафе';

  @override
  String get storeTypeOther => 'Інше';

  @override
  String get storeTypeStore => 'Магазин';

  @override
  String get chooseStore => 'Обрати магазин';

  @override
  String get searchStorePh => 'Пошук або новий магазин';

  @override
  String get create => 'Створити';

  @override
  String get newStoreHint =>
      'Новий магазин · майбутні чеки прив’яжуться до нього';

  @override
  String get noMatch => 'Відповідного магазину немає';

  @override
  String get createNewStore => 'Створити магазин';

  @override
  String get createNewStoreSub => 'Назва, аліас на чеку та тип';

  @override
  String get cancel => 'Скасувати';

  @override
  String get newStoreNote =>
      'Чеки з такою назвою магазину будуть прив’язані автоматично.';

  @override
  String get name => 'Назва';

  @override
  String get namePh => 'напр. Nr.1, Green Hills';

  @override
  String get alias => 'На чеках вказано як';

  @override
  String get aliasPh => 'Необов’язково · напр. NR1 SRL';

  @override
  String get type => 'Тип';

  @override
  String get createStore => 'Створити магазин';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString створено й обрано';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString додано · чеки прив’яжуться автоматично';
  }

  @override
  String get searchPh => 'Пошук чеків, товарів, магазинів';

  @override
  String get profile => 'Профіль';

  @override
  String get keepSafe => 'Збережіть дані';

  @override
  String keepSafeBody(String device) {
    return 'Чеки зберігаються лише на $device. Увійдіть для резервної копії та синхронізації. Нічого не завантажується без вашої згоди.';
  }

  @override
  String get continueGoogle => 'Продовжити з Google';

  @override
  String get continueApple => 'Продовжити з Apple';

  @override
  String get account => 'Акаунт';

  @override
  String get plan => 'План';

  @override
  String get cloudSync => 'Хмарна синхронізація';

  @override
  String get upToDate => 'Актуально';

  @override
  String get signOut => 'Вийти';

  @override
  String get yourData => 'Ваші дані';

  @override
  String get exportBackup => 'Експорт резервної копії';

  @override
  String get exportSheet => 'Експорт таблиці';

  @override
  String get importBackup => 'Імпорт резервної копії';

  @override
  String get exportNote =>
      'Експорт через меню «Поділитися» iOS. Імпорт перевіряється перед відновленням.';

  @override
  String get localAccount => 'Локальний акаунт';

  @override
  String get notSignedIn => 'Не виконано вхід · лише на пристрої';

  @override
  String get signedInGoogle => 'Вхід через Google';

  @override
  String get signedInApple => 'Вхід через Apple';

  @override
  String get storage => 'Сховище';

  @override
  String get cloudStorage => 'Хмарне сховище';

  @override
  String get unlimited => 'Без обмежень · на пристрої';

  @override
  String storageOf(String a, String b) {
    return '$a з $b';
  }

  @override
  String limitFree(String quota) {
    return 'Фото чеків і дані зберігаються в акаунт. Безкоштовно — 100 МБ.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium: $quota у хмарі, безлімітна історія та синхронізація пристроїв.';
  }

  @override
  String limitLocal(String device) {
    return 'Усе зберігається на $device без обмежень. Увійдіть для резервної копії.';
  }

  @override
  String get free => 'Безкоштовний';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Перейти на Premium · $quota';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium активовано · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'Знову Безкоштовний план · $quota';
  }

  @override
  String get tSignedIn => 'Вхід виконано · синхронізація ввімкнена';

  @override
  String get tSignedOut => 'Вихід · дані залишилися на пристрої';

  @override
  String tBackup(String filename) {
    return 'Копія готова · $filename';
  }

  @override
  String tCsv(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Таблиця готова · $countString рядка',
      many: 'Таблиця готова · $countString рядків',
      few: 'Таблиця готова · $countString рядки',
      one: 'Таблиця готова · $countString рядок',
    );
    return '$_temp0';
  }

  @override
  String get tImport => 'Оберіть файл резервної копії';

  @override
  String get dark => 'Темна';

  @override
  String get light => 'Світла';

  @override
  String get edit => 'Змінити';

  @override
  String get note => 'Нотатка';

  @override
  String get receiptPhoto => 'Фото чека';

  @override
  String get view => 'Переглянути';

  @override
  String get retake => 'Перезняти';

  @override
  String get chooseLibrary => 'З галереї';

  @override
  String get pickImageFailed => 'Не вдалося відкрити зображення';

  @override
  String get receiptPhotoEmptyTitle => 'Фото ще немає';

  @override
  String get receiptPhotoEmptyBody => 'Виберіть фото цього чека з галереї.';

  @override
  String get share => 'Поділитися';

  @override
  String get cashExpense => 'Готівкова витрата';

  @override
  String get deleteReceipt => 'Видалити чек';

  @override
  String get deleteExpense => 'Видалити витрату';

  @override
  String items(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString позиції',
      many: '$nString позицій',
      few: '$nString позиції',
      one: '$nString позиція',
    );
    return '$_temp0';
  }

  @override
  String get photoStored => 'фото чека · на пристрої';

  @override
  String get photoUpdated => 'фото чека · щойно оновлено';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · чек';
  }

  @override
  String get tRetake => 'Відкривається камера · фото замінено';

  @override
  String get tLibrary => 'Фото замінено з галереї';

  @override
  String get tShare => 'Надсилання фото чека…';

  @override
  String get tOpenReceipt => 'Відкрийте чек, щоб виправити позиції';

  @override
  String tDeleted(String t, String a) {
    return '$t видалено · $a';
  }

  @override
  String get expense => 'Витрата';

  @override
  String get amount => 'Сума';

  @override
  String get enterValidAmount => 'Введіть коректну суму';

  @override
  String get category => 'Категорія';

  @override
  String get optional => 'Необов’язково';

  @override
  String get date => 'Дата';

  @override
  String get save => 'Зберегти';

  @override
  String tCashAdded(String a) {
    return '$a додано';
  }

  @override
  String get receiptDetected => 'Чек знайдено';

  @override
  String get looking => 'Шукаю чек…';

  @override
  String get holdStill => 'Не рухайтесь';

  @override
  String get capturing => 'Зйомка…';

  @override
  String get keepInFrame => 'Тримайте весь чек у кадрі';

  @override
  String get autoCapture => 'Автоматична зйомка';

  @override
  String get flashAuto => 'Авто';

  @override
  String get flashOn => 'Увімк';

  @override
  String get flashOff => 'Вимк';

  @override
  String get steps0 => 'Пошук чека';

  @override
  String get steps1 => 'Читання тексту';

  @override
  String get steps2 => 'Пошук товарів';

  @override
  String get steps3 => 'Перевірка цін';

  @override
  String get reviewReceipt => 'Перевірка чека';

  @override
  String get autoDetected => 'Визначено автоматично';

  @override
  String get addItem => 'Додати позицію';

  @override
  String get qty => 'К-сть';

  @override
  String get qtyKg => 'Кг';

  @override
  String get qtyL => 'Л';

  @override
  String get total => 'Разом';

  @override
  String get usedForPrice => 'для історії цін';

  @override
  String get subtotal => 'Проміжний підсумок';

  @override
  String get discount => 'Знижка';

  @override
  String get itemsMatch => 'Позиції збігаються з підсумком';

  @override
  String itemsDiffer(String d) {
    return 'Позиції відрізняються від підсумку на $d';
  }

  @override
  String get blurry =>
      'Розмито чи обрізано? Перезніміть — чек буде прочитано знову.';

  @override
  String get correct => 'Виправити';

  @override
  String get saveReceipt => 'Зберегти чек';

  @override
  String tSaved(String a) {
    return 'Чек збережено · $a';
  }

  @override
  String get tSaveFailed => 'Не вдалося зберегти чек. Спробуйте ще раз.';

  @override
  String get tSaveFailedGeneric => 'Не вдалося зберегти. Спробуйте ще раз.';

  @override
  String checkThis(String r, String q) {
    return 'Перевірте · прочитано як «$r» · $q';
  }

  @override
  String readAs(String r) {
    return 'Прочитано як «$r»';
  }

  @override
  String get lowConf => 'низька впевненість';

  @override
  String get addedManually => 'додано вручну';

  @override
  String get correctReceipt => 'Виправити чек';

  @override
  String get editIntro =>
      'Усе, що прочитано невірно, можна виправити тут. Оригінальний текст чека зберігається для історії цін.';

  @override
  String get store => 'Магазин';

  @override
  String get change => 'Змінити';

  @override
  String get time => 'Час';

  @override
  String get itemsLabel => 'Позиції';

  @override
  String get price => 'Ціна';

  @override
  String get itemsTotal => 'Сума позицій';

  @override
  String get printedTotal => 'Надрукований підсумок';

  @override
  String get applyCorrections => 'Застосувати виправлення';

  @override
  String get thisDevice => 'цьому пристрої';

  @override
  String get trendIncreased => 'зросли';

  @override
  String get trendDecreased => 'знизилися';

  @override
  String get homeNoExpensesTitle => 'Ще немає витрат';

  @override
  String get homeNoExpensesBody =>
      'Відскануйте кілька чеків, щоб побачити структуру витрат.';

  @override
  String get scanFirstReceipt => 'Сканувати перший чек';

  @override
  String get historyNoRecordsTitle => 'Ще немає записів';

  @override
  String get historyNoRecordsBody =>
      'Відскануйте чек або додайте готівкову витрату, щоб побачити її тут.';

  @override
  String get historyNoMatchTitle => 'Немає збігів';

  @override
  String get historyNoMatchBody => 'Спробуйте інший пошук або фільтр.';

  @override
  String get filterAll => 'Усі';

  @override
  String get filterReceipts => 'Чеки';

  @override
  String get filterCash => 'Готівка';

  @override
  String get storeNoProductsYet => 'Ще немає товарів';

  @override
  String get storeNoProductsYetBody =>
      'Відскануйте чек із цього магазину, щоб побачити тут товари та порівняння цін.';

  @override
  String get deleteCategory => 'Видалити категорію';

  @override
  String deleteCategoryConfirm(String n) {
    return 'Видалити «$n»? Цю дію не можна скасувати.';
  }

  @override
  String get scanFailedTitle => 'Не вдалося чітко розпізнати чек.';

  @override
  String get scanFailedTips =>
      'Спробуйте:\n• Покращити освітлення\n• Розгладити чек\n• Тримати весь чек у кадрі';

  @override
  String get tryAgain => 'Спробувати ще раз';

  @override
  String get enterManually => 'Ввести вручну';

  @override
  String get deleteExpenseConfirmTitle => 'Видалити цю витрату?';

  @override
  String get deleteExpenseConfirmBody =>
      'Це остаточно видалить витрату з історії. Скасувати цю дію неможливо.';

  @override
  String get recordNotFound => 'Цей запис більше не існує.';

  @override
  String get historyAllRecords => 'Усі записи';

  @override
  String get recordNotFoundBody => 'Можливо, її було видалено.';

  @override
  String get priceHistoryTitle => 'Історія ціни';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction на $percent% від початку відстеження';
  }

  @override
  String get priceHistoryNoDataTitle => 'Ще немає історії ціни';

  @override
  String get priceHistoryNoDataBody =>
      'Відскануйте чек із цим товаром, щоб почати відстежувати його ціну з часом.';

  @override
  String get priceHistoryNotFoundTitle => 'Цей товар більше не існує.';

  @override
  String get priceHistoryNotFoundBody => 'Можливо, його було видалено.';

  @override
  String get scanningStatus => 'Сканування';

  @override
  String get scanStatusSupported => 'Готово';

  @override
  String get scanStatusChecking => 'Перевірка…';

  @override
  String get scanStatusNoCamera => 'Камера недоступна';

  @override
  String get scanStatusOcrUnavailable => 'Розпізнавання тексту недоступне';

  @override
  String get scanStatusPermissionDenied => 'Потрібен дозвіл на камеру';

  @override
  String get scanStatusPermissionPermanentlyDenied =>
      'Доступ до камери заблоковано';

  @override
  String get scanStatusUnavailable => 'Не вдалося перевірити';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get scanUnsupportedNoCamera => 'На цьому пристрої немає камери';

  @override
  String get scanUnsupportedOcrUnavailable =>
      'Розпізнавання тексту недоступне на цьому пристрої';

  @override
  String get scanUnsupportedPermissionDenied =>
      'Для сканування чеків потрібен дозвіл на камеру';

  @override
  String get scanUnsupportedPermissionPermanentlyDenied =>
      'Доступ до камери заблоковано — увімкніть його в налаштуваннях';

  @override
  String get scanUnsupportedUnavailable =>
      'Не вдалося перевірити камеру — спробуйте ще раз';

  @override
  String possibleDuplicateReceipt(String store, String date) {
    return 'Схоже, цей чек із $store від $date вже збережено.';
  }

  @override
  String get importTitle => 'Відновити з резервної копії?';

  @override
  String importBody(String device) {
    return 'Це додасть кожен запис із файлу до тих, що вже є. Записи, що збігаються, буде оновлено; нічого на $device не буде видалено.';
  }

  @override
  String get importConfirm => 'Відновити';

  @override
  String tImported(num n, num m) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);
    final intl.NumberFormat mNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String mString = mNumberFormat.format(m);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString чека',
      many: '$nString чеків',
      few: '$nString чеки',
      one: '$nString чек',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: '$mString витрати',
      many: '$mString витрат',
      few: '$mString витрати',
      one: '$mString витрата',
    );
    return 'Резервну копію відновлено · $_temp0, $_temp1';
  }

  @override
  String get importMalformed => 'Цей файл не є дійсною резервною копією.';

  @override
  String get importUnexpected =>
      'Під час відновлення цієї резервної копії сталася помилка.';

  @override
  String get importTooNew =>
      'Цю резервну копію створено новішою версією застосунку.';

  @override
  String get importCanceled => 'Файл не вибрано.';

  @override
  String get syncing => 'Синхронізація…';

  @override
  String get syncError => 'Помилка синхронізації';

  @override
  String get syncRetry => 'Натисніть, щоб повторити';

  @override
  String get syncDisabled => 'Увійдіть для резервної копії';

  @override
  String get storageEstimateNote =>
      'Розмір фотографій чеків виміряно у вашому акаунті. Записи займають незначний обсяг.';

  @override
  String get purchasesUnavailable => 'Покупки зараз недоступні.';

  @override
  String get deleteScopeTitle => 'Звідки видалити?';

  @override
  String get deleteScopeLocal => 'Лише цей пристрій';

  @override
  String get deleteScopeRemote => 'Лише у хмарі';

  @override
  String get deleteScopeBoth => 'Цей пристрій і хмара';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count у черзі',
      many: '$count у черзі',
      few: '$count у черзі',
      one: '$count у черзі',
    );
    return '$_temp0';
  }

  @override
  String storageUsedOf(String used, String total) {
    return '$used з $total';
  }
}
