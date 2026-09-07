// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get deleteAllTitle => 'Ștergi toate datele?';

  @override
  String deleteAllBody(int n, String device) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Se vor șterge $nString înregistrări, pozele bonurilor, magazinele și categoriile de pe $device. Backup-urile cloud nu sunt afectate. Acțiunea este ireversibilă.';
  }

  @override
  String get deleteAllConfirm => 'Șterge tot';

  @override
  String get tDeletedAll => 'Toate datele au fost șterse';

  @override
  String get renameCategory => 'Redenumește categoria';

  @override
  String catRenamed(String n) {
    return 'Redenumită în $n';
  }

  @override
  String get newCategory => 'Categorie nouă';

  @override
  String get categoryEmpty => 'Nicio categorie încă';

  @override
  String get createCategory => 'Creează categoria';

  @override
  String get newCatPh => 'Nume categorie nouă';

  @override
  String get searchCatPh => 'Caută sau scrie o categorie nouă';

  @override
  String get newCatHint => 'Categorie nouă · apare în toate selectoarele';

  @override
  String get catNote =>
      'Categoriile implicite nu pot fi șterse. Cele personalizate se pot șterge cât nu sunt folosite.';

  @override
  String get catDefault => 'Implicită';

  @override
  String get catCustom => 'Personalizată · nefolosită';

  @override
  String catUsed(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Personalizată · $nString înregistrări';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString creată';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString ștearsă';
  }

  @override
  String get noStore => 'Fără magazin';

  @override
  String get deleteStore => 'Șterge magazinul';

  @override
  String get deleteStoreNote => 'Posibil doar cât timp nu are bonuri legate.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString șters';
  }

  @override
  String get tabHome => 'Acasă';

  @override
  String get tabAnalytics => 'Analiză';

  @override
  String get tabStores => 'Magazine';

  @override
  String get tabHistory => 'Istoric';

  @override
  String get tabSettings => 'Setări';

  @override
  String get settings => 'Setări';

  @override
  String get currency => 'Monedă';

  @override
  String get categories => 'Categorii';

  @override
  String get language => 'Limbă';

  @override
  String get appearance => 'Aspect';

  @override
  String get deleteAll => 'Șterge toate datele';

  @override
  String get privacy => 'Confidențialitate';

  @override
  String get about => 'Despre aplicație';

  @override
  String get aboutDescription =>
      'O aplicație de urmărire a cheltuielilor, local-first. Scanează bonuri sau adaugă cheltuieli în numerar și vezi unde îți duci banii — totul stocat pe acest dispozitiv.';

  @override
  String get done => 'Gata';

  @override
  String get langNote =>
      'Schimbă limba aplicației. Bonurile își păstrează textul original.';

  @override
  String get currencyNote =>
      'Folosită pentru totaluri și analiză. Bonurile păstrează moneda tipărită.';

  @override
  String get splashTag => 'Bonurile tale, înțelese.';

  @override
  String onDevice(String device) {
    return 'Totul rămâne pe $device';
  }

  @override
  String get skip => 'Sari';

  @override
  String get noAccount => 'Fără cont';

  @override
  String get noUpload => 'Fără încărcare';

  @override
  String get offline => 'Offline';

  @override
  String get yourCurrency => 'Moneda ta';

  @override
  String get continue_ => 'Continuă';

  @override
  String get getStarted => 'Începe';

  @override
  String get onb0Title => 'Află unde se duc banii.';

  @override
  String get onb0Point0 => 'Fiecare bon devine cheltuială structurată';

  @override
  String get onb0Point1 => 'Categorii și totaluri, fără tastat';

  @override
  String get onb0Point2 => 'Prețuri urmărite în timp';

  @override
  String get onb1Title => 'Scanează bonuri în secunde.';

  @override
  String get onb1Point0 => 'Îndreaptă camera, bonul este găsit';

  @override
  String get onb1Point1 => 'Textul este citit pe iPhone-ul tău';

  @override
  String get onb1Point2 => 'Produse și prețuri extrase automat';

  @override
  String get onb2Title => 'Datele rămân pe dispozitivul tău.';

  @override
  String get onb2Point0 => 'Local-first, funcționează offline';

  @override
  String get onb2Point1 => 'Nu este necesar un cont';

  @override
  String get onb2Point2 => 'Sincronizarea cloud poate fi activată mai târziu';

  @override
  String get spentThisMonth => 'cheltuiți luna aceasta';

  @override
  String vs(String m) {
    return 'față de $m';
  }

  @override
  String get scanReceipt => 'Scanează bonul';

  @override
  String get addCash => 'Adaugă cheltuială cash';

  @override
  String get all => 'Toate';

  @override
  String get recent => 'Recente';

  @override
  String get seeAll => 'Vezi toate';

  @override
  String get onDeviceShort => 'Pe dispozitiv';

  @override
  String get synced => 'Sincronizat';

  @override
  String get average => 'Medie';

  @override
  String get purchases => 'Cumpărături';

  @override
  String get thisMonth => 'luna aceasta';

  @override
  String get cash => 'Cash';

  @override
  String get ofSpending => 'din cheltuieli';

  @override
  String get insights => 'Observații';

  @override
  String get cashVsReceipts => 'Cash vs bonuri';

  @override
  String get receiptsLower => 'bonuri';

  @override
  String get cashLower => 'cash';

  @override
  String get period => 'Perioadă';

  @override
  String periodRange(String a, String b) {
    return 'Înregistrări din $a până în $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable =>
      'Exportul PDF va fi disponibil într-o actualizare viitoare.';

  @override
  String get signInComingSoon =>
      'Autentificarea va fi disponibilă într-o actualizare viitoare.';

  @override
  String get exportComingSoon =>
      'Exportul și importul vor fi disponibile într-o actualizare viitoare.';

  @override
  String pdfToast(String m) {
    return 'Raport $m · PDF gata de trimis';
  }

  @override
  String purchase1(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString cumpărătură';
  }

  @override
  String purchaseN(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString cumpărături';
  }

  @override
  String get top => 'top';

  @override
  String ins1(int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return 'Alimentele reprezintă $pString% din cheltuieli.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Cheltuielile la $category au $direction cu $percentString% luna aceasta.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Cumpărătura medie a crescut de la $a la $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category au reprezentat $percentString% din cheltuieli.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Cheltuielile $category au scăzut cu $percentString% în $month.';
  }

  @override
  String insA3(String value, String c) {
    return 'Cumpărătura medie a fost $value $c.';
  }

  @override
  String get catFood => 'Alimente';

  @override
  String get catTransport => 'Transport';

  @override
  String get catHousehold => 'Casă';

  @override
  String get catRestaurantsCoffee => 'Restaurante & Cafea';

  @override
  String get catRestaurants => 'Restaurante';

  @override
  String get catHealth => 'Sănătate';

  @override
  String get catOther => 'Altele';

  @override
  String get catShopping => 'Cumpărături';

  @override
  String get catEntertainment => 'Divertisment';

  @override
  String get catUtilities => 'Utilități';

  @override
  String get catTravel => 'Călătorii';

  @override
  String get catEducation => 'Educație';

  @override
  String get catPersonalCare => 'Îngrijire personală';

  @override
  String get months0 => 'Ianuarie';

  @override
  String get months1 => 'Februarie';

  @override
  String get months2 => 'Martie';

  @override
  String get months3 => 'Aprilie';

  @override
  String get months4 => 'Mai';

  @override
  String get months5 => 'Iunie';

  @override
  String get months6 => 'Iulie';

  @override
  String get months7 => 'August';

  @override
  String get months8 => 'Septembrie';

  @override
  String get months9 => 'Octombrie';

  @override
  String get months10 => 'Noiembrie';

  @override
  String get months11 => 'Decembrie';

  @override
  String get monthsShort0 => 'Ian';

  @override
  String get monthsShort1 => 'Feb';

  @override
  String get monthsShort2 => 'Mar';

  @override
  String get monthsShort3 => 'Apr';

  @override
  String get monthsShort4 => 'Mai';

  @override
  String get monthsShort5 => 'Iun';

  @override
  String get monthsShort6 => 'Iul';

  @override
  String get monthsShort7 => 'Aug';

  @override
  String get monthsShort8 => 'Sep';

  @override
  String get monthsShort9 => 'Oct';

  @override
  String get monthsShort10 => 'Noi';

  @override
  String get monthsShort11 => 'Dec';

  @override
  String get today => 'Azi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get receipt => 'Bon';

  @override
  String get cashType => 'Cash';

  @override
  String get receipts => 'Bonuri';

  @override
  String get newStore => 'Magazin nou';

  @override
  String get storesIntro =>
      'Creat automat din bonurile tale. Deschide un magazin pentru produse și comparații de preț.';

  @override
  String get storesEmptyTitle => 'Încă niciun magazin';

  @override
  String get storesEmptyBody =>
      'Adaugă un magazin ca să urmărești unde cumperi și cum se compară prețurile.';

  @override
  String get visits => 'Vizite';

  @override
  String get spent => 'Cheltuit';

  @override
  String get products => 'Produse';

  @override
  String get productsHere => 'Produse cumpărate aici';

  @override
  String get cmpNote =>
      'Comparațiile folosesc bonurile tale din ultimele 60 de zile, nu prețuri live.';

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

    return '$vString vizite · $pString produse';
  }

  @override
  String storeEmpty(String t) {
    return '$t · fără bonuri încă';
  }

  @override
  String bought(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Cumpărat $nString×';
  }

  @override
  String get byWeight => 'la cântar';

  @override
  String cheapestOf(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Cel mai ieftin din $nString magazine';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · mai ieftin cu $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /kg · mai ieftin aici';
  }

  @override
  String get onlyHere => 'Cumpărat doar aici';

  @override
  String get storeTypeSupermarket => 'Supermarket';

  @override
  String get storeTypeMarket => 'Piață';

  @override
  String get storeTypePharmacy => 'Farmacie';

  @override
  String get storeTypeCafe => 'Cafenea';

  @override
  String get storeTypeOther => 'Altele';

  @override
  String get storeTypeStore => 'Magazin';

  @override
  String get chooseStore => 'Alege magazinul';

  @override
  String get searchStorePh => 'Caută sau scrie un magazin nou';

  @override
  String get create => 'Creează';

  @override
  String get newStoreHint =>
      'Magazin nou · bonurile viitoare se vor lega de el';

  @override
  String get noMatch => 'Niciun magazin potrivit';

  @override
  String get createNewStore => 'Creează magazin nou';

  @override
  String get createNewStoreSub => 'Nume, alias pe bon și tip';

  @override
  String get cancel => 'Anulează';

  @override
  String get newStoreNote =>
      'Bonurile cu același nume de magazin vor fi legate automat.';

  @override
  String get name => 'Nume';

  @override
  String get namePh => 'ex. Nr.1, Green Hills';

  @override
  String get alias => 'Apare pe bonuri ca';

  @override
  String get aliasPh => 'Opțional · ex. NR1 SRL';

  @override
  String get type => 'Tip';

  @override
  String get createStore => 'Creează magazinul';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString creat și selectat';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString adăugat · bonurile se vor lega automat';
  }

  @override
  String get searchPh => 'Caută bonuri, produse, magazine';

  @override
  String get profile => 'Profil';

  @override
  String get keepSafe => 'Păstrează-ți datele în siguranță';

  @override
  String keepSafeBody(String device) {
    return 'Bonurile tale există doar pe $device. Conectează-te pentru backup și sincronizare. Nimic nu se încarcă până nu o faci.';
  }

  @override
  String get continueGoogle => 'Continuă cu Google';

  @override
  String get continueApple => 'Continuă cu Apple';

  @override
  String get account => 'Cont';

  @override
  String get plan => 'Plan';

  @override
  String get cloudSync => 'Sincronizare cloud';

  @override
  String get upToDate => 'Actualizat';

  @override
  String get signOut => 'Deconectare';

  @override
  String get yourData => 'Datele tale';

  @override
  String get exportBackup => 'Exportă backup';

  @override
  String get exportSheet => 'Exportă tabel';

  @override
  String get importBackup => 'Importă backup';

  @override
  String get exportNote =>
      'Exporturile se trimit prin foaia de partajare iOS. Importurile sunt validate înainte de restaurare.';

  @override
  String get localAccount => 'Cont local';

  @override
  String get notSignedIn => 'Neconectat · doar pe dispozitiv';

  @override
  String get signedInGoogle => 'Conectat cu Google';

  @override
  String get storage => 'Stocare';

  @override
  String get cloudStorage => 'Stocare cloud';

  @override
  String get unlimited => 'Nelimitat · pe dispozitiv';

  @override
  String storageOf(String a, String b) {
    return '$a din $b';
  }

  @override
  String limitFree(String quota) {
    return 'Pozele și datele sunt salvate în contul tău. Conturile gratuite includ $quota.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium: $quota stocare cloud, istoric nelimitat și sincronizare multi-dispozitiv.';
  }

  @override
  String limitLocal(String device) {
    return 'Totul este stocat pe $device, fără limită. Conectează-te pentru backup.';
  }

  @override
  String get free => 'Gratuit';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Treci la Premium · $quota cloud';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium activat · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'Înapoi la Gratuit · $quota';
  }

  @override
  String get tSignedIn => 'Conectat · sincronizare activă';

  @override
  String get tSignedOut => 'Deconectat · datele rămân pe dispozitiv';

  @override
  String tBackup(String filename) {
    return 'Backup gata · $filename';
  }

  @override
  String tCsv(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Tabel gata · $countString rânduri';
  }

  @override
  String get tImport => 'Alege un fișier de backup';

  @override
  String get dark => 'Întunecat';

  @override
  String get light => 'Luminos';

  @override
  String get edit => 'Editează';

  @override
  String get note => 'Notă';

  @override
  String get receiptPhoto => 'Poza bonului';

  @override
  String get view => 'Vezi';

  @override
  String get retake => 'Refă poza';

  @override
  String get chooseLibrary => 'Alege din galerie';

  @override
  String get share => 'Trimite';

  @override
  String get cashExpense => 'Cheltuială cash';

  @override
  String get deleteReceipt => 'Șterge bonul';

  @override
  String get deleteExpense => 'Șterge cheltuiala';

  @override
  String items(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString produse';
  }

  @override
  String get photoStored => 'poza bonului · pe dispozitiv';

  @override
  String get photoUpdated => 'poza bonului · actualizată acum';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · bon';
  }

  @override
  String get tRetake => 'Camera se deschide · poza înlocuită';

  @override
  String get tLibrary => 'Poză înlocuită din galerie';

  @override
  String get tShare => 'Se trimite poza bonului…';

  @override
  String get tOpenReceipt => 'Deschide bonul pentru a corecta produsele';

  @override
  String tDeleted(String t, String a) {
    return '$t șters · $a';
  }

  @override
  String get expense => 'Cheltuială';

  @override
  String get amount => 'Sumă';

  @override
  String get enterValidAmount => 'Introdu o sumă validă';

  @override
  String get category => 'Categorie';

  @override
  String get optional => 'Opțional';

  @override
  String get date => 'Data';

  @override
  String get save => 'Salvează';

  @override
  String tCashAdded(String a) {
    return '$a adăugat';
  }

  @override
  String get receiptDetected => 'Bon detectat';

  @override
  String get looking => 'Caut bonul…';

  @override
  String get holdStill => 'Ține nemișcat';

  @override
  String get capturing => 'Se capturează…';

  @override
  String get keepInFrame => 'Ține tot bonul în cadru';

  @override
  String get autoCapture => 'Capturare automată';

  @override
  String get flashAuto => 'Auto';

  @override
  String get flashOn => 'Pornit';

  @override
  String get flashOff => 'Oprit';

  @override
  String get steps0 => 'Detectez bonul';

  @override
  String get steps1 => 'Citesc textul';

  @override
  String get steps2 => 'Găsesc produsele';

  @override
  String get steps3 => 'Verific prețurile';

  @override
  String get reviewReceipt => 'Verifică bonul';

  @override
  String get autoDetected => 'Detectat automat';

  @override
  String get addItem => 'Adaugă produs';

  @override
  String get qty => 'Cant.';

  @override
  String get total => 'Total';

  @override
  String get usedForPrice => 'folosit pentru istoricul prețurilor';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Reducere';

  @override
  String get itemsMatch => 'Produsele corespund totalului tipărit';

  @override
  String itemsDiffer(String d) {
    return 'Produsele diferă de totalul tipărit cu $d';
  }

  @override
  String get blurry =>
      'Neclar sau tăiat? Refă poza și bonul va fi citit din nou.';

  @override
  String get correct => 'Corectează';

  @override
  String get saveReceipt => 'Salvează bonul';

  @override
  String tSaved(String a) {
    return 'Bon salvat · $a';
  }

  @override
  String checkThis(String r, String q) {
    return 'Verifică · citit ca „$r” · $q';
  }

  @override
  String readAs(String r) {
    return 'Citit ca „$r”';
  }

  @override
  String get lowConf => 'încredere scăzută';

  @override
  String get addedManually => 'adăugat manual';

  @override
  String get correctReceipt => 'Corectează bonul';

  @override
  String get editIntro =>
      'Orice a fost citit greșit se poate corecta aici. Textul original rămâne atașat pentru istoricul prețurilor.';

  @override
  String get store => 'Magazin';

  @override
  String get change => 'Schimbă';

  @override
  String get time => 'Ora';

  @override
  String get itemsLabel => 'Produse';

  @override
  String get price => 'Preț';

  @override
  String get itemsTotal => 'Total produse';

  @override
  String get printedTotal => 'Total tipărit';

  @override
  String get applyCorrections => 'Aplică corecțiile';

  @override
  String get thisDevice => 'acest dispozitiv';

  @override
  String get trendIncreased => 'crescut';

  @override
  String get trendDecreased => 'scăzut';

  @override
  String get homeNoExpensesTitle => 'Încă nicio cheltuială';

  @override
  String get homeNoExpensesBody =>
      'Scanează câteva bonuri pentru a-ți vedea tiparele de cheltuieli.';

  @override
  String get scanFirstReceipt => 'Scanează primul bon';

  @override
  String get scanComingSoon =>
      'Scanarea va fi disponibilă într-o actualizare viitoare';

  @override
  String get historyNoRecordsTitle => 'Încă nicio înregistrare';

  @override
  String get historyNoRecordsBody =>
      'Scanează un bon sau adaugă o cheltuială cash pentru a o vedea aici.';

  @override
  String get historyNoMatchTitle => 'Nicio înregistrare potrivită';

  @override
  String get historyNoMatchBody => 'Încearcă altă căutare sau alt filtru.';

  @override
  String get filterAll => 'Toate';

  @override
  String get filterReceipts => 'Bonuri';

  @override
  String get filterCash => 'Cash';

  @override
  String get storeNoProductsYet => 'Încă niciun produs';

  @override
  String get storeNoProductsYetBody =>
      'Scanează un bon de la acest magazin ca să vezi produsele și comparațiile de preț aici.';

  @override
  String get deleteCategory => 'Șterge categoria';

  @override
  String deleteCategoryConfirm(String n) {
    return 'Ștergi „$n”? Această acțiune nu poate fi anulată.';
  }

  @override
  String get scanFailedTitle => 'Nu am putut citi clar acest bon.';

  @override
  String get scanFailedTips =>
      'Încearcă:\n• Mută-te la o lumină mai bună\n• Aplatizează bonul\n• Ține tot bonul în cadru';

  @override
  String get tryAgain => 'Încearcă din nou';

  @override
  String get enterManually => 'Introdu manual';

  @override
  String get deleteExpenseConfirmTitle => 'Ștergi această cheltuială?';

  @override
  String get deleteExpenseConfirmBody =>
      'Aceasta elimină definitiv cheltuiala din istoric. Nu poate fi anulată.';

  @override
  String get recordNotFound => 'Această înregistrare nu mai există.';

  @override
  String get editComingSoon =>
      'Editarea va fi disponibilă într-o actualizare viitoare.';

  @override
  String get historyAllRecords => 'Toate înregistrările';

  @override
  String get recordNotFoundBody => 'Este posibil să fi fost ștearsă.';

  @override
  String get priceHistoryTitle => 'Istoric preț';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction $percent% de la prima urmărire';
  }

  @override
  String get priceHistoryNoDataTitle => 'Încă niciun istoric de preț';

  @override
  String get priceHistoryNoDataBody =>
      'Scanează un bon cu acest produs pentru a începe să-i urmărești prețul în timp.';

  @override
  String get priceHistoryNotFoundTitle => 'Acest produs nu mai există.';

  @override
  String get priceHistoryNotFoundBody => 'Este posibil să fi fost șters.';

  @override
  String get scanningStatus => 'Scanare';

  @override
  String get scanStatusSupported => 'Pregătit';

  @override
  String get scanStatusChecking => 'Se verifică…';

  @override
  String get scanStatusNoCamera => 'Nicio cameră disponibilă';

  @override
  String get scanStatusOcrUnavailable => 'Recunoașterea textului indisponibilă';

  @override
  String get scanStatusPermissionDenied =>
      'Este necesară permisiunea pentru cameră';

  @override
  String get scanStatusPermissionPermanentlyDenied =>
      'Accesul la cameră este blocat';

  @override
  String get openSettings => 'Deschide Setările';

  @override
  String get scanUnsupportedNoCamera => 'Acest dispozitiv nu are cameră';

  @override
  String get scanUnsupportedOcrUnavailable =>
      'Recunoașterea textului nu este disponibilă pe acest dispozitiv';

  @override
  String get scanUnsupportedPermissionDenied =>
      'Este necesară permisiunea pentru cameră pentru a scana bonuri';

  @override
  String get scanUnsupportedPermissionPermanentlyDenied =>
      'Accesul la cameră este blocat — activează-l din Setări';
}
