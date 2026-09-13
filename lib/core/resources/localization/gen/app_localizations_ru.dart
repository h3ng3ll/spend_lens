// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get deleteAllTitle => 'Удалить все данные?';

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
          'Будут удалены $nString записи, фото чеков, магазины и категории с $device. Облачные копии не затронуты. Отменить нельзя.',
      many:
          'Будут удалены $nString записей, фото чеков, магазины и категории с $device. Облачные копии не затронуты. Отменить нельзя.',
      few:
          'Будут удалены $nString записи, фото чеков, магазины и категории с $device. Облачные копии не затронуты. Отменить нельзя.',
      one:
          'Будет удалена $nString запись, фото чеков, магазины и категории с $device. Облачные копии не затронуты. Отменить нельзя.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllConfirm => 'Удалить всё';

  @override
  String get tDeletedAll => 'Все данные удалены';

  @override
  String get renameCategory => 'Переименовать категорию';

  @override
  String catRenamed(String n) {
    return 'Переименована в $n';
  }

  @override
  String get newCategory => 'Новая категория';

  @override
  String get categoryEmpty => 'Пока нет категорий';

  @override
  String get createCategory => 'Создать категорию';

  @override
  String get newCatPh => 'Название новой категории';

  @override
  String get searchCatPh => 'Поиск или новая категория';

  @override
  String get newCatHint => 'Новая категория · появится во всех списках';

  @override
  String get catNote =>
      'Встроенные категории нельзя удалить. Свои можно удалить, пока они не используются.';

  @override
  String get catDefault => 'Встроенная';

  @override
  String get catCustom => 'Своя · не используется';

  @override
  String catUsed(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Своя · $nString записи',
      many: 'Своя · $nString записей',
      few: 'Своя · $nString записи',
      one: 'Своя · $nString запись',
    );
    return '$_temp0';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString создана';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString удалена';
  }

  @override
  String get noStore => 'Без магазина';

  @override
  String get deleteStore => 'Удалить магазин';

  @override
  String get deleteStoreNote => 'Доступно, пока к магазину не привязаны чеки.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString удалён';
  }

  @override
  String get tabHome => 'Главная';

  @override
  String get tabAnalytics => 'Аналитика';

  @override
  String get tabStores => 'Магазины';

  @override
  String get tabHistory => 'История';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get settings => 'Настройки';

  @override
  String get currency => 'Валюта';

  @override
  String get categories => 'Категории';

  @override
  String get language => 'Язык';

  @override
  String get languageSystemDefault => 'Как в системе';

  @override
  String get appearance => 'Оформление';

  @override
  String get deleteAll => 'Удалить все данные';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get about => 'О приложении';

  @override
  String get aboutDescription =>
      'Локальный трекер расходов. Сканируйте чеки или добавляйте наличные траты и смотрите, куда уходят деньги — всё хранится на этом устройстве.';

  @override
  String get done => 'Готово';

  @override
  String get langNote =>
      'Меняет язык приложения. Текст чеков остаётся исходным.';

  @override
  String get currencyNote =>
      'Используется для итогов и аналитики. Чеки сохраняют напечатанную валюту.';

  @override
  String get splashTag => 'Ваши чеки — понятны.';

  @override
  String onDevice(String device) {
    return 'Всё остаётся на $device';
  }

  @override
  String get skip => 'Пропустить';

  @override
  String get noAccount => 'Без аккаунта';

  @override
  String get noUpload => 'Без загрузки';

  @override
  String get offline => 'Офлайн';

  @override
  String get yourCurrency => 'Ваша валюта';

  @override
  String get continue_ => 'Далее';

  @override
  String get getStarted => 'Начать';

  @override
  String get onb0Title => 'Знайте, куда уходят деньги.';

  @override
  String get onb0Point0 => 'Каждый чек становится структурированным расходом';

  @override
  String get onb0Point1 => 'Категории и итоги без ввода';

  @override
  String get onb0Point2 => 'Цены отслеживаются во времени';

  @override
  String get onb1Title => 'Сканируйте чеки за секунды.';

  @override
  String get onb1Point0 => 'Наведите камеру — чек найден';

  @override
  String onb1Point1(String device) {
    return 'Текст читается на $device';
  }

  @override
  String get onb1Point2 => 'Товары и цены извлекаются автоматически';

  @override
  String get onb2Title => 'Данные остаются на устройстве.';

  @override
  String get onb2Point0 => 'Local-first, работает офлайн';

  @override
  String get onb2Point1 => 'Аккаунт не требуется';

  @override
  String get onb2Point2 => 'Облачную синхронизацию можно включить позже';

  @override
  String get spentThisMonth => 'потрачено в этом месяце';

  @override
  String vs(String m) {
    return 'к $m';
  }

  @override
  String get scanReceipt => 'Сканировать чек';

  @override
  String get addCash => 'Добавить наличные';

  @override
  String get all => 'Все';

  @override
  String get recent => 'Недавние';

  @override
  String get seeAll => 'Все';

  @override
  String get onDeviceShort => 'На устройстве';

  @override
  String get synced => 'Синхронизировано';

  @override
  String get average => 'Средний';

  @override
  String get purchases => 'Покупки';

  @override
  String get thisMonth => 'в этом месяце';

  @override
  String get cash => 'Наличные';

  @override
  String get ofSpending => 'от расходов';

  @override
  String get insights => 'Наблюдения';

  @override
  String get cashVsReceipts => 'Наличные и чеки';

  @override
  String get receiptsLower => 'чеки';

  @override
  String get cashLower => 'наличные';

  @override
  String get period => 'Период';

  @override
  String periodRange(String a, String b) {
    return 'Записи с $a по $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable =>
      'Экспорт в PDF появится в одном из следующих обновлений.';

  @override
  String pdfToast(String m) {
    return 'Отчёт $m · PDF готов';
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

    return 'Продукты — $pString% ваших расходов.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Расходы на $category $direction на $percentString% в этом месяце.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Средняя покупка выросла с $a до $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category составили $percentString% расходов.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Расходы на $category снизились на $percentString% в $month.';
  }

  @override
  String insA3(String value, String c) {
    return 'Средняя покупка была $value $c.';
  }

  @override
  String get catFood => 'Продукты';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catHousehold => 'Дом';

  @override
  String get catRestaurantsCoffee => 'Рестораны и кофе';

  @override
  String get catRestaurants => 'Рестораны';

  @override
  String get catHealth => 'Здоровье';

  @override
  String get catOther => 'Другое';

  @override
  String get catShopping => 'Покупки';

  @override
  String get catEntertainment => 'Развлечения';

  @override
  String get catUtilities => 'Коммунальные услуги';

  @override
  String get catTravel => 'Путешествия';

  @override
  String get catEducation => 'Образование';

  @override
  String get catPersonalCare => 'Личная гигиена';

  @override
  String get months0 => 'Январь';

  @override
  String get months1 => 'Февраль';

  @override
  String get months2 => 'Март';

  @override
  String get months3 => 'Апрель';

  @override
  String get months4 => 'Май';

  @override
  String get months5 => 'Июнь';

  @override
  String get months6 => 'Июль';

  @override
  String get months7 => 'Август';

  @override
  String get months8 => 'Сентябрь';

  @override
  String get months9 => 'Октябрь';

  @override
  String get months10 => 'Ноябрь';

  @override
  String get months11 => 'Декабрь';

  @override
  String get monthsShort0 => 'Янв';

  @override
  String get monthsShort1 => 'Фев';

  @override
  String get monthsShort2 => 'Мар';

  @override
  String get monthsShort3 => 'Апр';

  @override
  String get monthsShort4 => 'Май';

  @override
  String get monthsShort5 => 'Июн';

  @override
  String get monthsShort6 => 'Июл';

  @override
  String get monthsShort7 => 'Авг';

  @override
  String get monthsShort8 => 'Сен';

  @override
  String get monthsShort9 => 'Окт';

  @override
  String get monthsShort10 => 'Ноя';

  @override
  String get monthsShort11 => 'Дек';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get receipt => 'Чек';

  @override
  String get cashType => 'Наличные';

  @override
  String get receipts => 'Чеки';

  @override
  String get newStore => 'Новый магазин';

  @override
  String get storesIntro =>
      'Создаётся автоматически из чеков. Откройте магазин, чтобы увидеть товары и сравнение цен.';

  @override
  String get storesEmptyTitle => 'Пока нет магазинов';

  @override
  String get storesEmptyBody =>
      'Добавьте магазин, чтобы отслеживать, где вы покупаете, и сравнивать цены.';

  @override
  String get visits => 'Визиты';

  @override
  String get spent => 'Потрачено';

  @override
  String get products => 'Товары';

  @override
  String get productsHere => 'Куплено здесь';

  @override
  String get cmpNote =>
      'Сравнение по вашим чекам за последние 60 дней, а не по живым ценам.';

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
      other: '$vString визита',
      many: '$vString визитов',
      few: '$vString визита',
      one: '$vString визит',
    );
    String _temp1 = intl.Intl.pluralLogic(
      p,
      locale: localeName,
      other: '$pString товара',
      many: '$pString товаров',
      few: '$pString товара',
      one: '$pString товар',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String storeEmpty(String t) {
    return '$t · чеков пока нет';
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
  String get byWeight => 'на вес';

  @override
  String cheapestOf(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Дешевле всего из $nString магазина',
      many: 'Дешевле всего из $nString магазинов',
      few: 'Дешевле всего из $nString магазинов',
      one: 'Дешевле всего из $nString магазина',
    );
    return '$_temp0';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · дешевле на $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /кг · здесь дешевле';
  }

  @override
  String get onlyHere => 'Куплено только здесь';

  @override
  String get storeTypeSupermarket => 'Супермаркет';

  @override
  String get storeTypeMarket => 'Рынок';

  @override
  String get storeTypePharmacy => 'Аптека';

  @override
  String get storeTypeCafe => 'Кафе';

  @override
  String get storeTypeOther => 'Другое';

  @override
  String get storeTypeStore => 'Магазин';

  @override
  String get chooseStore => 'Выбрать магазин';

  @override
  String get searchStorePh => 'Поиск или новый магазин';

  @override
  String get create => 'Создать';

  @override
  String get newStoreHint => 'Новый магазин · будущие чеки привяжутся к нему';

  @override
  String get noMatch => 'Подходящего магазина нет';

  @override
  String get createNewStore => 'Создать магазин';

  @override
  String get createNewStoreSub => 'Название, алиас на чеке и тип';

  @override
  String get cancel => 'Отмена';

  @override
  String get newStoreNote =>
      'Чеки с таким названием магазина будут привязаны автоматически.';

  @override
  String get name => 'Название';

  @override
  String get namePh => 'напр. Nr.1, Green Hills';

  @override
  String get alias => 'На чеках указан как';

  @override
  String get aliasPh => 'Необязательно · напр. NR1 SRL';

  @override
  String get type => 'Тип';

  @override
  String get createStore => 'Создать магазин';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString создан и выбран';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString добавлен · чеки привяжутся автоматически';
  }

  @override
  String get searchPh => 'Поиск чеков, товаров, магазинов';

  @override
  String get profile => 'Профиль';

  @override
  String get keepSafe => 'Сохраните данные';

  @override
  String keepSafeBody(String device) {
    return 'Чеки хранятся только на $device. Войдите для резервной копии и синхронизации. Ничего не загружается без вашего согласия.';
  }

  @override
  String get continueGoogle => 'Продолжить с Google';

  @override
  String get continueApple => 'Продолжить с Apple';

  @override
  String get account => 'Аккаунт';

  @override
  String get plan => 'План';

  @override
  String get cloudSync => 'Облачная синхронизация';

  @override
  String get upToDate => 'Актуально';

  @override
  String get signOut => 'Выйти';

  @override
  String get yourData => 'Ваши данные';

  @override
  String get exportBackup => 'Экспорт резервной копии';

  @override
  String get exportSheet => 'Экспорт таблицы';

  @override
  String get importBackup => 'Импорт резервной копии';

  @override
  String get exportNote =>
      'Экспорт через меню «Поделиться» iOS. Импорт проверяется перед восстановлением.';

  @override
  String get localAccount => 'Локальный аккаунт';

  @override
  String get notSignedIn => 'Не выполнен вход · только на устройстве';

  @override
  String get signedInGoogle => 'Вход через Google';

  @override
  String get signedInApple => 'Вход через Apple';

  @override
  String get storage => 'Хранилище';

  @override
  String get cloudStorage => 'Облачное хранилище';

  @override
  String get unlimited => 'Без ограничений · на устройстве';

  @override
  String storageOf(String a, String b) {
    return '$a из $b';
  }

  @override
  String limitFree(String quota) {
    return 'Фото чеков и данные сохраняются в аккаунт. Бесплатно — 100 МБ.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium: $quota в облаке, безлимитная история и синхронизация устройств.';
  }

  @override
  String limitLocal(String device) {
    return 'Всё хранится на $device без ограничений. Войдите для резервной копии.';
  }

  @override
  String get free => 'Бесплатный';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Перейти на Premium · $quota';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium активирован · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'Снова Бесплатный план · $quota';
  }

  @override
  String get tSignedIn => 'Вход выполнен · синхронизация включена';

  @override
  String get tSignedOut => 'Выход · данные остались на устройстве';

  @override
  String tBackup(String filename) {
    return 'Копия готова · $filename';
  }

  @override
  String tCsv(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Таблица готова · $countString строки',
      many: 'Таблица готова · $countString строк',
      few: 'Таблица готова · $countString строки',
      one: 'Таблица готова · $countString строка',
    );
    return '$_temp0';
  }

  @override
  String get tImport => 'Выберите файл резервной копии';

  @override
  String get dark => 'Тёмная';

  @override
  String get light => 'Светлая';

  @override
  String get edit => 'Изменить';

  @override
  String get note => 'Заметка';

  @override
  String get receiptPhoto => 'Фото чека';

  @override
  String get view => 'Смотреть';

  @override
  String get retake => 'Переснять';

  @override
  String get chooseLibrary => 'Из галереи';

  @override
  String get pickImageFailed => 'Не удалось открыть изображение';

  @override
  String get receiptPhotoEmptyTitle => 'Фото пока нет';

  @override
  String get receiptPhotoEmptyBody => 'Выберите фото этого чека из галереи.';

  @override
  String get share => 'Поделиться';

  @override
  String get cashExpense => 'Наличный расход';

  @override
  String get deleteReceipt => 'Удалить чек';

  @override
  String get deleteExpense => 'Удалить расход';

  @override
  String items(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString позиции',
      many: '$nString позиций',
      few: '$nString позиции',
      one: '$nString позиция',
    );
    return '$_temp0';
  }

  @override
  String get photoStored => 'фото чека · на устройстве';

  @override
  String get photoUpdated => 'фото чека · только что обновлено';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · чек';
  }

  @override
  String get tRetake => 'Открывается камера · фото заменено';

  @override
  String get tLibrary => 'Фото заменено из галереи';

  @override
  String get tShare => 'Отправка фото чека…';

  @override
  String get tOpenReceipt => 'Откройте чек, чтобы исправить позиции';

  @override
  String tDeleted(String t, String a) {
    return '$t удалён · $a';
  }

  @override
  String get expense => 'Расход';

  @override
  String get amount => 'Сумма';

  @override
  String get enterValidAmount => 'Введите корректную сумму';

  @override
  String get category => 'Категория';

  @override
  String get optional => 'Необязательно';

  @override
  String get date => 'Дата';

  @override
  String get save => 'Сохранить';

  @override
  String tCashAdded(String a) {
    return '$a добавлено';
  }

  @override
  String get receiptDetected => 'Чек найден';

  @override
  String get looking => 'Ищу чек…';

  @override
  String get holdStill => 'Не двигайтесь';

  @override
  String get capturing => 'Съёмка…';

  @override
  String get keepInFrame => 'Держите весь чек в кадре';

  @override
  String get autoCapture => 'Автоматическая съёмка';

  @override
  String get flashAuto => 'Авто';

  @override
  String get flashOn => 'Вкл';

  @override
  String get flashOff => 'Выкл';

  @override
  String get steps0 => 'Поиск чека';

  @override
  String get steps1 => 'Чтение текста';

  @override
  String get steps2 => 'Поиск товаров';

  @override
  String get steps3 => 'Проверка цен';

  @override
  String get reviewReceipt => 'Проверка чека';

  @override
  String get autoDetected => 'Определено автоматически';

  @override
  String get addItem => 'Добавить позицию';

  @override
  String get qty => 'Кол-во';

  @override
  String get qtyKg => 'Кг';

  @override
  String get qtyL => 'Л';

  @override
  String get total => 'Итого';

  @override
  String get usedForPrice => 'для истории цен';

  @override
  String get subtotal => 'Подытог';

  @override
  String get discount => 'Скидка';

  @override
  String get itemsMatch => 'Позиции сходятся с итогом';

  @override
  String itemsDiffer(String d) {
    return 'Позиции отличаются от итога на $d';
  }

  @override
  String get blurry =>
      'Размыто или обрезано? Переснимите — чек будет прочитан заново.';

  @override
  String get correct => 'Исправить';

  @override
  String get saveReceipt => 'Сохранить чек';

  @override
  String tSaved(String a) {
    return 'Чек сохранён · $a';
  }

  @override
  String get tSaveFailed => 'Не удалось сохранить чек. Попробуйте снова.';

  @override
  String get tSaveFailedGeneric => 'Не удалось сохранить. Попробуйте снова.';

  @override
  String checkThis(String r, String q) {
    return 'Проверьте · прочитано как «$r» · $q';
  }

  @override
  String readAs(String r) {
    return 'Прочитано как «$r»';
  }

  @override
  String get lowConf => 'низкая уверенность';

  @override
  String get addedManually => 'добавлено вручную';

  @override
  String get correctReceipt => 'Исправить чек';

  @override
  String get editIntro =>
      'Всё, что прочитано неверно, можно исправить здесь. Исходный текст чека сохраняется для истории цен.';

  @override
  String get store => 'Магазин';

  @override
  String get change => 'Изменить';

  @override
  String get time => 'Время';

  @override
  String get itemsLabel => 'Позиции';

  @override
  String get price => 'Цена';

  @override
  String get itemsTotal => 'Сумма позиций';

  @override
  String get printedTotal => 'Напечатанный итог';

  @override
  String get applyCorrections => 'Применить исправления';

  @override
  String get thisDevice => 'этом устройстве';

  @override
  String get trendIncreased => 'выросли';

  @override
  String get trendDecreased => 'снизились';

  @override
  String get homeNoExpensesTitle => 'Пока нет расходов';

  @override
  String get homeNoExpensesBody =>
      'Отсканируйте несколько чеков, чтобы увидеть структуру расходов.';

  @override
  String get scanFirstReceipt => 'Отсканировать первый чек';

  @override
  String get historyNoRecordsTitle => 'Пока нет записей';

  @override
  String get historyNoRecordsBody =>
      'Отсканируйте чек или добавьте наличный расход, чтобы увидеть его здесь.';

  @override
  String get historyNoMatchTitle => 'Совпадений не найдено';

  @override
  String get historyNoMatchBody => 'Попробуйте другой запрос или фильтр.';

  @override
  String get filterAll => 'Все';

  @override
  String get filterReceipts => 'Чеки';

  @override
  String get filterCash => 'Наличные';

  @override
  String get storeNoProductsYet => 'Пока нет товаров';

  @override
  String get storeNoProductsYetBody =>
      'Отсканируйте чек из этого магазина, чтобы увидеть здесь товары и сравнение цен.';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String deleteCategoryConfirm(String n) {
    return 'Удалить «$n»? Это действие нельзя отменить.';
  }

  @override
  String get scanFailedTitle => 'Не удалось чётко распознать чек.';

  @override
  String get scanFailedTips =>
      'Попробуйте:\n• Улучшить освещение\n• Разгладить чек\n• Держать весь чек в кадре';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get enterManually => 'Ввести вручную';

  @override
  String get deleteExpenseConfirmTitle => 'Удалить этот расход?';

  @override
  String get deleteExpenseConfirmBody =>
      'Это навсегда удалит расход из истории. Отменить это действие нельзя.';

  @override
  String get recordNotFound => 'Эта запись больше не существует.';

  @override
  String get historyAllRecords => 'Все записи';

  @override
  String get recordNotFoundBody => 'Возможно, она была удалена.';

  @override
  String get priceHistoryTitle => 'История цены';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction на $percent% с начала отслеживания';
  }

  @override
  String get priceHistoryNoDataTitle => 'Пока нет истории цены';

  @override
  String get priceHistoryNoDataBody =>
      'Отсканируйте чек с этим товаром, чтобы начать отслеживать его цену со временем.';

  @override
  String get priceHistoryNotFoundTitle => 'Этот товар больше не существует.';

  @override
  String get priceHistoryNotFoundBody => 'Возможно, он был удалён.';

  @override
  String get scanningStatus => 'Сканирование';

  @override
  String get scanStatusSupported => 'Готово';

  @override
  String get scanStatusChecking => 'Проверка…';

  @override
  String get scanStatusNoCamera => 'Камера недоступна';

  @override
  String get scanStatusOcrUnavailable => 'Распознавание текста недоступно';

  @override
  String get scanStatusPermissionDenied => 'Требуется разрешение на камеру';

  @override
  String get scanStatusPermissionPermanentlyDenied =>
      'Доступ к камере заблокирован';

  @override
  String get scanStatusUnavailable => 'Не удалось проверить';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get scanUnsupportedNoCamera => 'На этом устройстве нет камеры';

  @override
  String get scanUnsupportedOcrUnavailable =>
      'Распознавание текста недоступно на этом устройстве';

  @override
  String get scanUnsupportedPermissionDenied =>
      'Для сканирования чеков нужно разрешение на камеру';

  @override
  String get scanUnsupportedPermissionPermanentlyDenied =>
      'Доступ к камере заблокирован — включите его в настройках';

  @override
  String get scanUnsupportedUnavailable =>
      'Не удалось проверить камеру — попробуйте снова';

  @override
  String possibleDuplicateReceipt(String store, String date) {
    return 'Похоже, вы уже сохранили этот чек из $store от $date.';
  }

  @override
  String get importTitle => 'Восстановить из резервной копии?';

  @override
  String importBody(String device) {
    return 'Это добавит каждую запись из файла к тем, что уже есть. Совпадающие записи будут обновлены; ничего на $device не будет удалено.';
  }

  @override
  String get importConfirm => 'Восстановить';

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
      many: '$nString чеков',
      few: '$nString чека',
      one: '$nString чек',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: '$mString расхода',
      many: '$mString расходов',
      few: '$mString расхода',
      one: '$mString расход',
    );
    return 'Резервная копия восстановлена · $_temp0, $_temp1';
  }

  @override
  String get importMalformed =>
      'Этот файл не является допустимой резервной копией.';

  @override
  String get importUnexpected =>
      'При восстановлении этой резервной копии произошла ошибка.';

  @override
  String get importTooNew =>
      'Эта резервная копия создана более новой версией приложения.';

  @override
  String get importCanceled => 'Файл не выбран.';

  @override
  String get syncing => 'Синхронизация…';

  @override
  String get syncError => 'Ошибка синхронизации';

  @override
  String get syncRetry => 'Нажмите, чтобы повторить';

  @override
  String get syncDisabled => 'Войдите для резервной копии';

  @override
  String get storageEstimateNote =>
      'Размер фотографий чеков измерен в вашем аккаунте. Записи занимают ничтожно мало.';

  @override
  String get purchasesUnavailable => 'Покупки сейчас недоступны.';

  @override
  String get deleteScopeTitle => 'Откуда удалить?';

  @override
  String get deleteScopeLocal => 'Только это устройство';

  @override
  String get deleteScopeRemote => 'Только в облаке';

  @override
  String get deleteScopeBoth => 'Это устройство и облако';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count не синхронизировано',
      few: '$count не синхронизированы',
      one: '1 не синхронизирована',
    );
    return '$_temp0';
  }

  @override
  String storageUsedOf(String used, String total) {
    return '$used из $total';
  }

  @override
  String get premiumUpgradeTitle => 'Перейти на Premium';

  @override
  String premiumUpgradeSubtitle(String quota) {
    return 'Неограниченная история, синхронизация между устройствами и $quota облачного хранилища.';
  }

  @override
  String get planMonthly => 'Ежемесячно';

  @override
  String get planYearly => 'Ежегодно';

  @override
  String get planMonthlyPrice => '€2,99 / месяц';

  @override
  String get planYearlyPrice => '€24,99 / год';

  @override
  String get planYearlyNote => '2 месяца бесплатно';

  @override
  String get planBestValue => 'Выгоднее';

  @override
  String get premiumFeatureHistory => 'Неограниченная история чеков';

  @override
  String get premiumFeatureSync => 'Синхронизация между устройствами';

  @override
  String premiumFeatureStorage(String quota) {
    return '$quota облачного хранилища';
  }

  @override
  String get premiumSubscribe => 'Оформить подписку';

  @override
  String get premiumRestore => 'Восстановить покупку';

  @override
  String get premiumRestoreNothing => 'Предыдущая покупка не найдена.';

  @override
  String get premiumTerms =>
      'Продлевается автоматически. Отменить можно в App Store.';

  @override
  String get syncPendingUpload => 'Не синхронизировано';

  @override
  String get syncPendingDelete => 'Ожидает удаления';

  @override
  String get storageDetails => 'Сведения о хранилище';

  @override
  String get photoSize => 'Фото';

  @override
  String get documentSize => 'Данные записи';

  @override
  String get noPhotoStored => 'Нет фото';

  @override
  String get cloudCopy => 'Копия в облаке';

  @override
  String get cloudCopyUploaded => 'Выгружено';

  @override
  String get cloudCopyPending => 'Ещё не выгружено';

  @override
  String get storageDetailsNote =>
      'В облачное хранилище засчитывается только фото. Размер данных записи — это оценка того, что выгружается для этого чека.';

  @override
  String get syncStatus => 'Статус синхронизации';

  @override
  String get syncNow => 'Синхронизировать';

  @override
  String get syncSection => 'Синхронизация';

  @override
  String get signOutConfirmTitle => 'Выйти?';

  @override
  String get signOutConfirmBody =>
      'Записи, уже сохранённые в облаке, будут удалены с этого устройства и восстановлены при следующем входе. Несинхронизированные останутся.';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get changePhoto => 'Изменить фото';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get removePhoto => 'Удалить фото';

  @override
  String get nameHint => 'Не указано';

  @override
  String get tProfileSaved => 'Профиль обновлён';

  @override
  String get tProfileSaveFailed => 'Не удалось сохранить профиль';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountSheetTitle => 'Удалить аккаунт';

  @override
  String get deleteAccountEverywhere => 'Удалить везде';

  @override
  String get deleteAccountEverywhereBody =>
      'Ваш аккаунт, все данные в облаке И все записи на этом устройстве. Ничего не сохранится.';

  @override
  String get deleteAccountCloudOnly => 'Удалить аккаунт и данные в облаке';

  @override
  String get deleteAccountCloudOnlyBody =>
      'Удаляет аккаунт и всё, что хранится в облаке. Записи на этом устройстве сохранятся.';

  @override
  String get deleteAccountConfirmTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountConfirmEverywhere =>
      'Аккаунт, все данные в облаке и каждая запись, фото чека, магазин и категория на этом устройстве будут удалены навсегда. Отменить нельзя.';

  @override
  String get deleteAccountConfirmCloudOnly =>
      'Аккаунт и всё, что хранится в облаке, будет удалено навсегда. Записи на этом устройстве сохранятся. Отменить нельзя.';

  @override
  String get deleteAccountConfirm => 'Удалить аккаунт';

  @override
  String get deletingAccount => 'Удаление аккаунта…';

  @override
  String get tAccountDeleted => 'Ваш аккаунт удалён';

  @override
  String get deleteAccountSubscriptionTitle => 'Подписка останется активной';

  @override
  String get deleteAccountSubscriptionBody =>
      'Удаление аккаунта не отменяет подписку Premium — оплата управляется App Store и продолжится, пока вы не отмените её там.';

  @override
  String get deleteAccountSubscriptionAction => 'Управление подпиской';

  @override
  String get savingProfile => 'Сохранение…';

  @override
  String get uploadingPhoto => 'Загрузка фото…';

  @override
  String get processingPhoto => 'Обработка фото…';
}
