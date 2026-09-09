// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get deleteAllTitle => 'Alle Daten löschen?';

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
          'Entfernt $nString Einträge, Belegfotos, Läden und Kategorien von $device. Cloud-Backups bleiben erhalten. Das kann nicht rückgängig gemacht werden.',
      one:
          'Entfernt 1 Eintrag, Belegfotos, Läden und Kategorien von $device. Cloud-Backups bleiben erhalten. Das kann nicht rückgängig gemacht werden.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllConfirm => 'Alles löschen';

  @override
  String get tDeletedAll => 'Alle Daten gelöscht';

  @override
  String get renameCategory => 'Kategorie umbenennen';

  @override
  String catRenamed(String n) {
    return 'Umbenannt in $n';
  }

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get categoryEmpty => 'Noch keine Kategorien';

  @override
  String get createCategory => 'Kategorie erstellen';

  @override
  String get newCatPh => 'Name der neuen Kategorie';

  @override
  String get searchCatPh => 'Suchen oder neue Kategorie eingeben';

  @override
  String get newCatHint => 'Neue Kategorie · erscheint in jeder Auswahl';

  @override
  String get catNote =>
      'Eingebaute Kategorien können nicht gelöscht werden. Eigene lassen sich löschen, solange sie ungenutzt sind.';

  @override
  String get catDefault => 'Eingebaut';

  @override
  String get catCustom => 'Eigene · ungenutzt';

  @override
  String catUsed(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Eigene · $nString Einträge',
      one: 'Eigene · 1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString erstellt';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString gelöscht';
  }

  @override
  String get noStore => 'Kein Laden';

  @override
  String get deleteStore => 'Laden löschen';

  @override
  String get deleteStoreNote =>
      'Nur möglich, solange keine Belege verknüpft sind.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString gelöscht';
  }

  @override
  String get tabHome => 'Start';

  @override
  String get tabAnalytics => 'Analyse';

  @override
  String get tabStores => 'Läden';

  @override
  String get tabHistory => 'Verlauf';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get currency => 'Währung';

  @override
  String get categories => 'Kategorien';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystemDefault => 'Systemstandard';

  @override
  String get appearance => 'Darstellung';

  @override
  String get deleteAll => 'Alle Daten löschen';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get about => 'Über die App';

  @override
  String get aboutDescription =>
      'Ein lokaler Ausgaben-Tracker. Scanne Belege oder erfasse Barausgaben und sieh, wohin dein Geld geht — alles wird auf diesem Gerät gespeichert.';

  @override
  String get done => 'Fertig';

  @override
  String get langNote =>
      'Ändert die App-Sprache. Belege behalten ihren Originaltext.';

  @override
  String get currencyNote =>
      'Für Summen und Analyse. Belege behalten ihre gedruckte Währung.';

  @override
  String get splashTag => 'Deine Belege, verstanden.';

  @override
  String onDevice(String device) {
    return 'Alles bleibt auf $device';
  }

  @override
  String get skip => 'Überspringen';

  @override
  String get noAccount => 'Kein Konto';

  @override
  String get noUpload => 'Kein Upload';

  @override
  String get offline => 'Offline';

  @override
  String get yourCurrency => 'Deine Währung';

  @override
  String get continue_ => 'Weiter';

  @override
  String get getStarted => 'Los geht’s';

  @override
  String get onb0Title => 'Wissen, wohin dein Geld geht.';

  @override
  String get onb0Point0 => 'Jeder Beleg wird zu strukturierten Ausgaben';

  @override
  String get onb0Point1 => 'Kategorien und Summen ohne Tippen';

  @override
  String get onb0Point2 => 'Preise über die Zeit verfolgt';

  @override
  String get onb1Title => 'Belege in Sekunden scannen.';

  @override
  String get onb1Point0 => 'Kamera draufhalten, Beleg wird erkannt';

  @override
  String onb1Point1(String device) {
    return 'Text wird auf $device gelesen';
  }

  @override
  String get onb1Point2 => 'Produkte und Preise automatisch extrahiert';

  @override
  String get onb2Title => 'Deine Daten bleiben auf dem Gerät.';

  @override
  String get onb2Point0 => 'Local-first, funktioniert offline';

  @override
  String get onb2Point1 => 'Kein Konto nötig';

  @override
  String get onb2Point2 => 'Cloud-Sync kann später aktiviert werden';

  @override
  String get spentThisMonth => 'diesen Monat ausgegeben';

  @override
  String vs(String m) {
    return 'vs. $m';
  }

  @override
  String get scanReceipt => 'Beleg scannen';

  @override
  String get addCash => 'Barausgabe hinzufügen';

  @override
  String get all => 'Alle';

  @override
  String get recent => 'Zuletzt';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get onDeviceShort => 'Auf dem Gerät';

  @override
  String get synced => 'Synchronisiert';

  @override
  String get average => 'Durchschnitt';

  @override
  String get purchases => 'Einkäufe';

  @override
  String get thisMonth => 'diesen Monat';

  @override
  String get cash => 'Bar';

  @override
  String get ofSpending => 'der Ausgaben';

  @override
  String get insights => 'Erkenntnisse';

  @override
  String get cashVsReceipts => 'Bar vs. Belege';

  @override
  String get receiptsLower => 'Belege';

  @override
  String get cashLower => 'bar';

  @override
  String get period => 'Zeitraum';

  @override
  String periodRange(String a, String b) {
    return 'Einträge von $a bis $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable =>
      'PDF-Export folgt in einem späteren Update.';

  @override
  String pdfToast(String m) {
    return 'Bericht $m · PDF bereit zum Teilen';
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
      other: '$nString Einkäufe',
      one: '$nString Einkauf',
    );
    return '$_temp0';
  }

  @override
  String get top => 'Top';

  @override
  String ins1(int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return 'Lebensmittel machen $pString% deiner Ausgaben aus.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '${category}ausgaben $direction diesen Monat um $percentString%.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Dein durchschnittlicher Einkauf stieg von $a auf $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category machten $percentString% deiner Ausgaben aus.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '${category}ausgaben sanken im $month um $percentString%.';
  }

  @override
  String insA3(String value, String c) {
    return 'Dein durchschnittlicher Einkauf lag bei $value $c.';
  }

  @override
  String get catFood => 'Lebensmittel';

  @override
  String get catTransport => 'Verkehr';

  @override
  String get catHousehold => 'Haushalt';

  @override
  String get catRestaurantsCoffee => 'Restaurants & Kaffee';

  @override
  String get catRestaurants => 'Restaurants';

  @override
  String get catHealth => 'Gesundheit';

  @override
  String get catOther => 'Sonstiges';

  @override
  String get catShopping => 'Einkaufen';

  @override
  String get catEntertainment => 'Unterhaltung';

  @override
  String get catUtilities => 'Nebenkosten';

  @override
  String get catTravel => 'Reisen';

  @override
  String get catEducation => 'Bildung';

  @override
  String get catPersonalCare => 'Körperpflege';

  @override
  String get months0 => 'Januar';

  @override
  String get months1 => 'Februar';

  @override
  String get months2 => 'März';

  @override
  String get months3 => 'April';

  @override
  String get months4 => 'Mai';

  @override
  String get months5 => 'Juni';

  @override
  String get months6 => 'Juli';

  @override
  String get months7 => 'August';

  @override
  String get months8 => 'September';

  @override
  String get months9 => 'Oktober';

  @override
  String get months10 => 'November';

  @override
  String get months11 => 'Dezember';

  @override
  String get monthsShort0 => 'Jan';

  @override
  String get monthsShort1 => 'Feb';

  @override
  String get monthsShort2 => 'Mär';

  @override
  String get monthsShort3 => 'Apr';

  @override
  String get monthsShort4 => 'Mai';

  @override
  String get monthsShort5 => 'Jun';

  @override
  String get monthsShort6 => 'Jul';

  @override
  String get monthsShort7 => 'Aug';

  @override
  String get monthsShort8 => 'Sep';

  @override
  String get monthsShort9 => 'Okt';

  @override
  String get monthsShort10 => 'Nov';

  @override
  String get monthsShort11 => 'Dez';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get receipt => 'Beleg';

  @override
  String get cashType => 'Bar';

  @override
  String get receipts => 'Belege';

  @override
  String get newStore => 'Neuer Laden';

  @override
  String get storesIntro =>
      'Automatisch aus deinen Belegen erstellt. Öffne einen Laden für Produkte und Preisvergleiche.';

  @override
  String get storesEmptyTitle => 'Noch keine Geschäfte';

  @override
  String get storesEmptyBody =>
      'Füge ein Geschäft hinzu, um zu verfolgen, wo du einkaufst, und Preise zu vergleichen.';

  @override
  String get visits => 'Besuche';

  @override
  String get spent => 'Ausgegeben';

  @override
  String get products => 'Produkte';

  @override
  String get productsHere => 'Hier gekaufte Produkte';

  @override
  String get cmpNote =>
      'Vergleiche basieren auf deinen Belegen der letzten 60 Tage, nicht auf Live-Preisen.';

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
      other: '$vString Besuche',
      one: '1 Besuch',
    );
    String _temp1 = intl.Intl.pluralLogic(
      p,
      locale: localeName,
      other: '$pString Produkte',
      one: '1 Produkt',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String storeEmpty(String t) {
    return '$t · noch keine Belege';
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
      other: '$nString× gekauft',
      one: '1× gekauft',
    );
    return '$_temp0';
  }

  @override
  String get byWeight => 'nach Gewicht';

  @override
  String cheapestOf(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Günstigster von $nString Läden',
      one: 'Günstigster von 1 Laden',
    );
    return '$_temp0';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · günstiger um $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /kg · hier günstiger';
  }

  @override
  String get onlyHere => 'Nur hier gekauft';

  @override
  String get storeTypeSupermarket => 'Supermarkt';

  @override
  String get storeTypeMarket => 'Markt';

  @override
  String get storeTypePharmacy => 'Apotheke';

  @override
  String get storeTypeCafe => 'Café';

  @override
  String get storeTypeOther => 'Sonstiges';

  @override
  String get storeTypeStore => 'Laden';

  @override
  String get chooseStore => 'Laden wählen';

  @override
  String get searchStorePh => 'Suchen oder neuen Laden eingeben';

  @override
  String get create => 'Erstellen';

  @override
  String get newStoreHint => 'Neuer Laden · künftige Belege werden verknüpft';

  @override
  String get noMatch => 'Kein passender Laden';

  @override
  String get createNewStore => 'Neuen Laden erstellen';

  @override
  String get createNewStoreSub => 'Name, Beleg-Alias und Typ';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get newStoreNote =>
      'Belege mit passendem Ladennamen werden automatisch verknüpft.';

  @override
  String get name => 'Name';

  @override
  String get namePh => 'z. B. Nr.1, Green Hills';

  @override
  String get alias => 'Erscheint auf Belegen als';

  @override
  String get aliasPh => 'Optional · z. B. NR1 SRL';

  @override
  String get type => 'Typ';

  @override
  String get createStore => 'Laden erstellen';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString erstellt und ausgewählt';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString hinzugefügt · Belege werden verknüpft';
  }

  @override
  String get searchPh => 'Belege, Produkte, Läden suchen';

  @override
  String get profile => 'Profil';

  @override
  String get keepSafe => 'Deine Daten sichern';

  @override
  String keepSafeBody(String device) {
    return 'Deine Belege liegen nur auf $device. Melde dich an, um sie zu sichern und zu synchronisieren. Nichts wird vorher hochgeladen.';
  }

  @override
  String get continueGoogle => 'Weiter mit Google';

  @override
  String get continueApple => 'Weiter mit Apple';

  @override
  String get account => 'Konto';

  @override
  String get plan => 'Tarif';

  @override
  String get cloudSync => 'Cloud-Sync';

  @override
  String get upToDate => 'Aktuell';

  @override
  String get signOut => 'Abmelden';

  @override
  String get yourData => 'Deine Daten';

  @override
  String get exportBackup => 'Backup exportieren';

  @override
  String get exportSheet => 'Tabelle exportieren';

  @override
  String get importBackup => 'Backup importieren';

  @override
  String get exportNote =>
      'Exporte laufen über das iOS-Teilen-Menü. Importe werden vor der Wiederherstellung geprüft.';

  @override
  String get localAccount => 'Lokales Konto';

  @override
  String get notSignedIn => 'Nicht angemeldet · nur auf dem Gerät';

  @override
  String get signedInGoogle => 'Angemeldet mit Google';

  @override
  String get signedInApple => 'Angemeldet mit Apple';

  @override
  String get storage => 'Speicher';

  @override
  String get cloudStorage => 'Cloud-Speicher';

  @override
  String get unlimited => 'Unbegrenzt · auf dem Gerät';

  @override
  String storageOf(String a, String b) {
    return '$a von $b';
  }

  @override
  String limitFree(String quota) {
    return 'Belegfotos und Daten werden in deinem Konto gesichert. Kostenlos sind $quota.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium: $quota Cloud-Speicher, unbegrenzter Verlauf und Multi-Geräte-Sync.';
  }

  @override
  String limitLocal(String device) {
    return 'Alles wird ohne Limit auf $device gespeichert. Melde dich an, um zu sichern.';
  }

  @override
  String get free => 'Kostenlos';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Auf Premium upgraden · $quota Cloud';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium aktiviert · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'Zurück im Kostenlos-Tarif · $quota';
  }

  @override
  String get tSignedIn => 'Angemeldet · Sync aktiv';

  @override
  String get tSignedOut => 'Abgemeldet · Daten bleiben auf dem Gerät';

  @override
  String tBackup(String filename) {
    return 'Backup bereit · $filename';
  }

  @override
  String tCsv(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tabelle bereit · $countString Zeilen',
      one: 'Tabelle bereit · 1 Zeile',
    );
    return '$_temp0';
  }

  @override
  String get tImport => 'Backup-Datei auswählen';

  @override
  String get dark => 'Dunkel';

  @override
  String get light => 'Hell';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get note => 'Notiz';

  @override
  String get receiptPhoto => 'Belegfoto';

  @override
  String get view => 'Ansehen';

  @override
  String get retake => 'Neu aufnehmen';

  @override
  String get chooseLibrary => 'Aus Mediathek';

  @override
  String get pickImageFailed => 'Bild konnte nicht geöffnet werden';

  @override
  String get receiptPhotoEmptyTitle => 'Noch kein Foto';

  @override
  String get receiptPhotoEmptyBody =>
      'Wähle ein Foto dieses Belegs aus deiner Mediathek.';

  @override
  String get share => 'Teilen';

  @override
  String get cashExpense => 'Barausgabe';

  @override
  String get deleteReceipt => 'Beleg löschen';

  @override
  String get deleteExpense => 'Ausgabe löschen';

  @override
  String items(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString Artikel',
      one: '$nString Artikel',
    );
    return '$_temp0';
  }

  @override
  String get photoStored => 'Belegfoto · auf dem Gerät';

  @override
  String get photoUpdated => 'Belegfoto · gerade aktualisiert';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · Beleg';
  }

  @override
  String get tRetake => 'Kamera öffnet sich · Foto ersetzt';

  @override
  String get tLibrary => 'Foto aus Mediathek ersetzt';

  @override
  String get tShare => 'Belegfoto wird geteilt…';

  @override
  String get tOpenReceipt => 'Beleg öffnen, um Artikel zu korrigieren';

  @override
  String tDeleted(String t, String a) {
    return '$t gelöscht · $a';
  }

  @override
  String get expense => 'Ausgabe';

  @override
  String get amount => 'Betrag';

  @override
  String get enterValidAmount => 'Gib einen gültigen Betrag ein';

  @override
  String get category => 'Kategorie';

  @override
  String get optional => 'Optional';

  @override
  String get date => 'Datum';

  @override
  String get save => 'Sichern';

  @override
  String tCashAdded(String a) {
    return '$a hinzugefügt';
  }

  @override
  String get receiptDetected => 'Beleg erkannt';

  @override
  String get looking => 'Suche nach Beleg…';

  @override
  String get holdStill => 'Ruhig halten';

  @override
  String get capturing => 'Aufnahme…';

  @override
  String get keepInFrame => 'Den ganzen Beleg im Rahmen halten';

  @override
  String get autoCapture => 'Automatische Aufnahme';

  @override
  String get flashAuto => 'Auto';

  @override
  String get flashOn => 'An';

  @override
  String get flashOff => 'Aus';

  @override
  String get steps0 => 'Beleg erkennen';

  @override
  String get steps1 => 'Text lesen';

  @override
  String get steps2 => 'Produkte finden';

  @override
  String get steps3 => 'Preise prüfen';

  @override
  String get reviewReceipt => 'Beleg prüfen';

  @override
  String get autoDetected => 'Automatisch erkannt';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get qty => 'Menge';

  @override
  String get qtyKg => 'Kg';

  @override
  String get qtyL => 'L';

  @override
  String get total => 'Gesamt';

  @override
  String get usedForPrice => 'für den Preisverlauf';

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get discount => 'Rabatt';

  @override
  String get itemsMatch => 'Artikel ergeben die gedruckte Summe';

  @override
  String itemsDiffer(String d) {
    return 'Artikel weichen um $d von der Summe ab';
  }

  @override
  String get blurry =>
      'Unscharf oder abgeschnitten? Neu aufnehmen, der Beleg wird erneut gelesen.';

  @override
  String get correct => 'Korrigieren';

  @override
  String get saveReceipt => 'Beleg sichern';

  @override
  String tSaved(String a) {
    return 'Beleg gesichert · $a';
  }

  @override
  String get tSaveFailed =>
      'Der Beleg konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get tSaveFailedGeneric =>
      'Speichern fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String checkThis(String r, String q) {
    return 'Prüfen · gelesen als „$r“ · $q';
  }

  @override
  String readAs(String r) {
    return 'Gelesen als „$r“';
  }

  @override
  String get lowConf => 'geringe Sicherheit';

  @override
  String get addedManually => 'manuell hinzugefügt';

  @override
  String get correctReceipt => 'Beleg korrigieren';

  @override
  String get editIntro =>
      'Alles falsch Gelesene kann hier korrigiert werden. Der Originaltext bleibt für den Preisverlauf erhalten.';

  @override
  String get store => 'Laden';

  @override
  String get change => 'Ändern';

  @override
  String get time => 'Uhrzeit';

  @override
  String get itemsLabel => 'Artikel';

  @override
  String get price => 'Preis';

  @override
  String get itemsTotal => 'Artikelsumme';

  @override
  String get printedTotal => 'Gedruckte Summe';

  @override
  String get applyCorrections => 'Korrekturen übernehmen';

  @override
  String get thisDevice => 'diesem Gerät';

  @override
  String get trendIncreased => 'stiegen um';

  @override
  String get trendDecreased => 'sanken um';

  @override
  String get homeNoExpensesTitle => 'Noch keine Ausgaben';

  @override
  String get homeNoExpensesBody =>
      'Scanne ein paar Belege, um deine Ausgabenmuster zu sehen.';

  @override
  String get scanFirstReceipt => 'Ersten Beleg scannen';

  @override
  String get historyNoRecordsTitle => 'Noch keine Einträge';

  @override
  String get historyNoRecordsBody =>
      'Scanne einen Beleg oder füge eine Barausgabe hinzu, um sie hier zu sehen.';

  @override
  String get historyNoMatchTitle => 'Keine Treffer';

  @override
  String get historyNoMatchBody =>
      'Versuche eine andere Suche oder einen anderen Filter.';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterReceipts => 'Belege';

  @override
  String get filterCash => 'Bar';

  @override
  String get storeNoProductsYet => 'Noch keine Produkte';

  @override
  String get storeNoProductsYetBody =>
      'Scanne einen Beleg dieses Ladens, um hier Produkte und Preisvergleiche zu sehen.';

  @override
  String get deleteCategory => 'Kategorie löschen';

  @override
  String deleteCategoryConfirm(String n) {
    return '„$n\" löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get scanFailedTitle =>
      'Dieser Beleg konnte nicht klar gelesen werden.';

  @override
  String get scanFailedTips =>
      'Versuche:\n• Besseres Licht\n• Beleg glätten\n• Den ganzen Beleg im Rahmen halten';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get enterManually => 'Manuell eingeben';

  @override
  String get deleteExpenseConfirmTitle => 'Diese Ausgabe löschen?';

  @override
  String get deleteExpenseConfirmBody =>
      'Dies entfernt die Ausgabe dauerhaft aus deinem Verlauf. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get recordNotFound => 'Dieser Eintrag existiert nicht mehr.';

  @override
  String get historyAllRecords => 'Alle Einträge';

  @override
  String get recordNotFoundBody => 'Er wurde möglicherweise gelöscht.';

  @override
  String get priceHistoryTitle => 'Preisverlauf';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction um $percent% seit der ersten Erfassung';
  }

  @override
  String get priceHistoryNoDataTitle => 'Noch kein Preisverlauf';

  @override
  String get priceHistoryNoDataBody =>
      'Scanne einen Beleg mit diesem Produkt, um seinen Preis im Zeitverlauf zu verfolgen.';

  @override
  String get priceHistoryNotFoundTitle =>
      'Dieses Produkt existiert nicht mehr.';

  @override
  String get priceHistoryNotFoundBody => 'Es wurde möglicherweise gelöscht.';

  @override
  String get scanningStatus => 'Scannen';

  @override
  String get scanStatusSupported => 'Bereit';

  @override
  String get scanStatusChecking => 'Wird geprüft…';

  @override
  String get scanStatusNoCamera => 'Keine Kamera verfügbar';

  @override
  String get scanStatusOcrUnavailable => 'Texterkennung nicht verfügbar';

  @override
  String get scanStatusPermissionDenied => 'Kamerazugriff erforderlich';

  @override
  String get scanStatusPermissionPermanentlyDenied => 'Kamerazugriff blockiert';

  @override
  String get scanStatusUnavailable => 'Prüfung fehlgeschlagen';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get scanUnsupportedNoCamera => 'Dieses Gerät hat keine Kamera';

  @override
  String get scanUnsupportedOcrUnavailable =>
      'Die Texterkennung ist auf diesem Gerät nicht verfügbar';

  @override
  String get scanUnsupportedPermissionDenied =>
      'Für das Scannen von Belegen ist Kamerazugriff erforderlich';

  @override
  String get scanUnsupportedPermissionPermanentlyDenied =>
      'Der Kamerazugriff ist blockiert — aktiviere ihn in den Einstellungen';

  @override
  String get scanUnsupportedUnavailable =>
      'Kamera konnte nicht geprüft werden — erneut versuchen';

  @override
  String possibleDuplicateReceipt(String store, String date) {
    return 'Das sieht nach einem Beleg aus, den du bereits von $store am $date gespeichert hast.';
  }

  @override
  String get importTitle => 'Aus Backup wiederherstellen?';

  @override
  String importBody(String device) {
    return 'Dadurch wird jeder Eintrag aus der Datei zu deinen vorhandenen Daten hinzugefügt. Übereinstimmende Einträge werden aktualisiert; nichts auf $device wird entfernt.';
  }

  @override
  String get importConfirm => 'Wiederherstellen';

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
      other: '$nString Belege',
      one: '1 Beleg',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: '$mString Ausgaben',
      one: '1 Ausgabe',
    );
    return 'Backup wiederhergestellt · $_temp0, $_temp1';
  }

  @override
  String get importMalformed => 'Diese Datei ist kein gültiges Backup.';

  @override
  String get importUnexpected =>
      'Beim Wiederherstellen dieses Backups ist ein Fehler aufgetreten.';

  @override
  String get importTooNew =>
      'Dieses Backup wurde mit einer neueren App-Version erstellt.';

  @override
  String get importCanceled => 'Keine Datei ausgewählt.';
}
