// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get deleteAllTitle => 'Supprimer toutes les données ?';

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
          'Supprime $nString enregistrements, photos de tickets, magasins et catégories de $device. Les sauvegardes cloud ne sont pas affectées. Irréversible.',
      one:
          'Supprime 1 enregistrement, photos de tickets, magasins et catégories de $device. Les sauvegardes cloud ne sont pas affectées. Irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllConfirm => 'Tout supprimer';

  @override
  String get tDeletedAll => 'Toutes les données supprimées';

  @override
  String get renameCategory => 'Renommer la catégorie';

  @override
  String catRenamed(String n) {
    return 'Renommée en $n';
  }

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get categoryEmpty => 'Aucune catégorie pour le moment';

  @override
  String get createCategory => 'Créer la catégorie';

  @override
  String get newCatPh => 'Nom de la nouvelle catégorie';

  @override
  String get searchCatPh => 'Rechercher ou saisir une nouvelle catégorie';

  @override
  String get newCatHint =>
      'Nouvelle catégorie · apparaît dans tous les sélecteurs';

  @override
  String get catNote =>
      'Les catégories intégrées ne peuvent pas être supprimées. Les personnalisées le sont tant qu’elles sont inutilisées.';

  @override
  String get catDefault => 'Intégrée';

  @override
  String get catCustom => 'Personnalisée · inutilisée';

  @override
  String catUsed(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Personnalisée · $nString enregistrements',
      one: 'Personnalisée · $nString enregistrement',
    );
    return '$_temp0';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString créée';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString supprimée';
  }

  @override
  String get noStore => 'Aucun magasin';

  @override
  String get deleteStore => 'Supprimer le magasin';

  @override
  String get deleteStoreNote => 'Possible uniquement sans tickets liés.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString supprimé';
  }

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabAnalytics => 'Analyse';

  @override
  String get tabStores => 'Magasins';

  @override
  String get tabHistory => 'Historique';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get settings => 'Réglages';

  @override
  String get currency => 'Devise';

  @override
  String get categories => 'Catégories';

  @override
  String get language => 'Langue';

  @override
  String get languageSystemDefault => 'Par défaut du système';

  @override
  String get appearance => 'Apparence';

  @override
  String get deleteAll => 'Supprimer toutes les données';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get about => 'À propos';

  @override
  String get aboutDescription =>
      'Un suivi de dépenses local. Scannez des reçus ou ajoutez des dépenses en espèces et voyez où va votre argent — tout est stocké sur cet appareil.';

  @override
  String get done => 'OK';

  @override
  String get langNote =>
      'Change la langue de l\'app. Les tickets gardent leur texte d\'origine.';

  @override
  String get currencyNote =>
      'Utilisée pour les totaux et l’analyse. Les tickets gardent leur devise imprimée.';

  @override
  String get splashTag => 'Vos tickets, compris.';

  @override
  String onDevice(String device) {
    return 'Tout reste sur $device';
  }

  @override
  String get skip => 'Passer';

  @override
  String get noAccount => 'Sans compte';

  @override
  String get noUpload => 'Sans envoi';

  @override
  String get offline => 'Hors ligne';

  @override
  String get yourCurrency => 'Votre devise';

  @override
  String get continue_ => 'Continuer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get onb0Title => 'Sachez où va votre argent.';

  @override
  String get onb0Point0 => 'Chaque ticket devient une dépense structurée';

  @override
  String get onb0Point1 => 'Catégories et totaux, sans saisie';

  @override
  String get onb0Point2 => 'Prix suivis dans le temps';

  @override
  String get onb1Title => 'Scannez vos tickets en secondes.';

  @override
  String get onb1Point0 => 'Visez le ticket, il est détecté';

  @override
  String onb1Point1(String device) {
    return 'Le texte est lu sur $device';
  }

  @override
  String get onb1Point2 => 'Produits et prix extraits automatiquement';

  @override
  String get onb2Title => 'Vos données restent sur votre appareil.';

  @override
  String get onb2Point0 => 'Local d’abord, fonctionne hors ligne';

  @override
  String get onb2Point1 => 'Aucun compte requis';

  @override
  String get onb2Point2 =>
      'La synchronisation cloud peut être activée plus tard';

  @override
  String get spentThisMonth => 'dépensés ce mois-ci';

  @override
  String vs(String m) {
    return 'vs $m';
  }

  @override
  String get scanReceipt => 'Scanner un ticket';

  @override
  String get addCash => 'Ajouter une dépense en espèces';

  @override
  String get all => 'Tout';

  @override
  String get recent => 'Récents';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get onDeviceShort => 'Sur l’appareil';

  @override
  String get synced => 'Synchronisé';

  @override
  String get average => 'Moyenne';

  @override
  String get purchases => 'Achats';

  @override
  String get thisMonth => 'ce mois-ci';

  @override
  String get cash => 'Espèces';

  @override
  String get ofSpending => 'des dépenses';

  @override
  String get insights => 'Observations';

  @override
  String get cashVsReceipts => 'Espèces vs tickets';

  @override
  String get receiptsLower => 'tickets';

  @override
  String get cashLower => 'espèces';

  @override
  String get period => 'Période';

  @override
  String periodRange(String a, String b) {
    return 'Enregistrements de $a à $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable =>
      'L’export PDF arrivera dans une prochaine mise à jour.';

  @override
  String pdfToast(String m) {
    return 'Rapport $m · PDF prêt à partager';
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
      other: '$nString achats',
      one: '$nString achat',
    );
    return '$_temp0';
  }

  @override
  String get top => 'top';

  @override
  String ins1(int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return 'L’alimentation représente $pString% de vos dépenses.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Les dépenses $category ont $direction de $percentString% ce mois-ci.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Votre achat moyen est passé de $a à $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category représentait $percentString% de vos dépenses.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'Les dépenses $category ont baissé de $percentString% en $month.';
  }

  @override
  String insA3(String value, String c) {
    return 'Votre achat moyen était de $value $c.';
  }

  @override
  String get catFood => 'Alimentation';

  @override
  String get catTransport => 'Transport';

  @override
  String get catHousehold => 'Maison';

  @override
  String get catRestaurantsCoffee => 'Restaurants & café';

  @override
  String get catRestaurants => 'Restaurants';

  @override
  String get catHealth => 'Santé';

  @override
  String get catOther => 'Autre';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catEntertainment => 'Divertissement';

  @override
  String get catUtilities => 'Charges';

  @override
  String get catTravel => 'Voyages';

  @override
  String get catEducation => 'Éducation';

  @override
  String get catPersonalCare => 'Soins personnels';

  @override
  String get months0 => 'Janvier';

  @override
  String get months1 => 'Février';

  @override
  String get months2 => 'Mars';

  @override
  String get months3 => 'Avril';

  @override
  String get months4 => 'Mai';

  @override
  String get months5 => 'Juin';

  @override
  String get months6 => 'Juillet';

  @override
  String get months7 => 'Août';

  @override
  String get months8 => 'Septembre';

  @override
  String get months9 => 'Octobre';

  @override
  String get months10 => 'Novembre';

  @override
  String get months11 => 'Décembre';

  @override
  String get monthsShort0 => 'Jan';

  @override
  String get monthsShort1 => 'Fév';

  @override
  String get monthsShort2 => 'Mar';

  @override
  String get monthsShort3 => 'Avr';

  @override
  String get monthsShort4 => 'Mai';

  @override
  String get monthsShort5 => 'Juin';

  @override
  String get monthsShort6 => 'Juil';

  @override
  String get monthsShort7 => 'Aoû';

  @override
  String get monthsShort8 => 'Sep';

  @override
  String get monthsShort9 => 'Oct';

  @override
  String get monthsShort10 => 'Nov';

  @override
  String get monthsShort11 => 'Déc';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get receipt => 'Ticket';

  @override
  String get cashType => 'Espèces';

  @override
  String get receipts => 'Tickets';

  @override
  String get newStore => 'Nouveau magasin';

  @override
  String get storesIntro =>
      'Créé automatiquement à partir de vos tickets. Ouvrez un magasin pour voir ses produits et comparer les prix.';

  @override
  String get storesEmptyTitle => 'Aucun magasin pour le moment';

  @override
  String get storesEmptyBody =>
      'Ajoutez un magasin pour suivre où vous achetez et comparer les prix.';

  @override
  String get visits => 'Visites';

  @override
  String get spent => 'Dépensé';

  @override
  String get products => 'Produits';

  @override
  String get productsHere => 'Produits achetés ici';

  @override
  String get cmpNote =>
      'Les comparaisons utilisent vos tickets des 60 derniers jours, pas les prix en direct.';

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
      other: '$vString visites',
      one: '$vString visite',
    );
    String _temp1 = intl.Intl.pluralLogic(
      p,
      locale: localeName,
      other: '$pString produits',
      one: '$pString produit',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String storeEmpty(String t) {
    return '$t · aucun ticket pour l’instant';
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
      other: 'Acheté $nString×',
      one: 'Acheté $nString×',
    );
    return '$_temp0';
  }

  @override
  String get byWeight => 'au poids';

  @override
  String cheapestOf(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Le moins cher de $nString magasins',
      one: 'Le moins cher de $nString magasin',
    );
    return '$_temp0';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · moins cher de $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /kg · moins cher ici';
  }

  @override
  String get onlyHere => 'Acheté uniquement ici';

  @override
  String get storeTypeSupermarket => 'Supermarché';

  @override
  String get storeTypeMarket => 'Marché';

  @override
  String get storeTypePharmacy => 'Pharmacie';

  @override
  String get storeTypeCafe => 'Café';

  @override
  String get storeTypeOther => 'Autre';

  @override
  String get storeTypeStore => 'Magasin';

  @override
  String get chooseStore => 'Choisir un magasin';

  @override
  String get searchStorePh => 'Rechercher ou saisir un nouveau magasin';

  @override
  String get create => 'Créer';

  @override
  String get newStoreHint =>
      'Nouveau magasin · les prochains tickets y seront liés';

  @override
  String get noMatch => 'Aucun magasin correspondant';

  @override
  String get createNewStore => 'Créer un magasin';

  @override
  String get createNewStoreSub => 'Nom, alias sur ticket et type';

  @override
  String get cancel => 'Annuler';

  @override
  String get newStoreNote =>
      'Les tickets portant ce nom de magasin seront liés automatiquement.';

  @override
  String get name => 'Nom';

  @override
  String get namePh => 'ex. Nr.1, Green Hills';

  @override
  String get alias => 'Apparaît sur les tickets comme';

  @override
  String get aliasPh => 'Facultatif · ex. NR1 SRL';

  @override
  String get type => 'Type';

  @override
  String get createStore => 'Créer le magasin';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString créé et sélectionné';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString ajouté · les tickets seront liés';
  }

  @override
  String get searchPh => 'Rechercher tickets, produits, magasins';

  @override
  String get profile => 'Profil';

  @override
  String get keepSafe => 'Protégez vos données';

  @override
  String keepSafeBody(String device) {
    return 'Vos tickets ne vivent que sur $device. Connectez-vous pour les sauvegarder et synchroniser. Rien n’est envoyé avant.';
  }

  @override
  String get continueGoogle => 'Continuer avec Google';

  @override
  String get continueApple => 'Continuer avec Apple';

  @override
  String get account => 'Compte';

  @override
  String get plan => 'Forfait';

  @override
  String get cloudSync => 'Synchronisation cloud';

  @override
  String get upToDate => 'À jour';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get yourData => 'Vos données';

  @override
  String get exportBackup => 'Exporter la sauvegarde';

  @override
  String get exportSheet => 'Exporter le tableau';

  @override
  String get importBackup => 'Importer une sauvegarde';

  @override
  String get exportNote =>
      'Les exports passent par la feuille de partage iOS. Les imports sont validés avant restauration.';

  @override
  String get localAccount => 'Compte local';

  @override
  String get notSignedIn => 'Non connecté · sur l’appareil uniquement';

  @override
  String get signedInGoogle => 'Connecté avec Google';

  @override
  String get storage => 'Stockage';

  @override
  String get cloudStorage => 'Stockage cloud';

  @override
  String get unlimited => 'Illimité · sur l’appareil';

  @override
  String storageOf(String a, String b) {
    return '$a sur $b';
  }

  @override
  String limitFree(String quota) {
    return 'Photos et données sont sauvegardées sur votre compte. Les comptes gratuits incluent 100 Mo.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium : $quota de stockage cloud, historique illimité et synchronisation multi-appareils.';
  }

  @override
  String limitLocal(String device) {
    return 'Tout est stocké sur $device sans limite. Connectez-vous pour sauvegarder.';
  }

  @override
  String get free => 'Gratuit';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Passer à Premium · $quota cloud';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium activé · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'Retour au forfait Gratuit · $quota';
  }

  @override
  String get tSignedIn => 'Connecté · synchronisation activée';

  @override
  String get tSignedOut => 'Déconnecté · données conservées sur l’appareil';

  @override
  String tBackup(String filename) {
    return 'Sauvegarde prête · $filename';
  }

  @override
  String tCsv(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tableau prêt · $countString lignes',
      one: 'Tableau prêt · $countString ligne',
    );
    return '$_temp0';
  }

  @override
  String get tImport => 'Choisissez un fichier de sauvegarde';

  @override
  String get dark => 'Sombre';

  @override
  String get light => 'Clair';

  @override
  String get edit => 'Modifier';

  @override
  String get note => 'Note';

  @override
  String get receiptPhoto => 'Photo du ticket';

  @override
  String get view => 'Voir';

  @override
  String get retake => 'Reprendre';

  @override
  String get chooseLibrary => 'Depuis la photothèque';

  @override
  String get pickImageFailed => 'Impossible d\'ouvrir l\'image';

  @override
  String get receiptPhotoEmptyTitle => 'Pas encore de photo';

  @override
  String get receiptPhotoEmptyBody =>
      'Choisissez une photo de ce ticket dans votre photothèque.';

  @override
  String get share => 'Partager';

  @override
  String get cashExpense => 'Dépense en espèces';

  @override
  String get deleteReceipt => 'Supprimer le ticket';

  @override
  String get deleteExpense => 'Supprimer la dépense';

  @override
  String items(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString articles',
      one: '$nString article',
    );
    return '$_temp0';
  }

  @override
  String get photoStored => 'photo du ticket · sur l’appareil';

  @override
  String get photoUpdated => 'photo du ticket · mise à jour à l’instant';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · ticket';
  }

  @override
  String get tRetake => 'La caméra s’ouvre · photo remplacée';

  @override
  String get tLibrary => 'Photo remplacée depuis la photothèque';

  @override
  String get tShare => 'Partage de la photo du ticket…';

  @override
  String get tOpenReceipt => 'Ouvrez le ticket pour corriger les articles';

  @override
  String tDeleted(String t, String a) {
    return '$t supprimé · $a';
  }

  @override
  String get expense => 'Dépense';

  @override
  String get amount => 'Montant';

  @override
  String get enterValidAmount => 'Saisissez un montant valide';

  @override
  String get category => 'Catégorie';

  @override
  String get optional => 'Facultatif';

  @override
  String get date => 'Date';

  @override
  String get save => 'Enregistrer';

  @override
  String tCashAdded(String a) {
    return '$a ajouté';
  }

  @override
  String get receiptDetected => 'Ticket détecté';

  @override
  String get looking => 'Recherche d’un ticket…';

  @override
  String get holdStill => 'Ne bougez pas';

  @override
  String get capturing => 'Capture…';

  @override
  String get keepInFrame => 'Gardez tout le ticket dans le cadre';

  @override
  String get autoCapture => 'Capture automatique';

  @override
  String get flashAuto => 'Auto';

  @override
  String get flashOn => 'Oui';

  @override
  String get flashOff => 'Non';

  @override
  String get steps0 => 'Détection du ticket';

  @override
  String get steps1 => 'Lecture du texte';

  @override
  String get steps2 => 'Recherche des produits';

  @override
  String get steps3 => 'Vérification des prix';

  @override
  String get reviewReceipt => 'Vérifier le ticket';

  @override
  String get autoDetected => 'Détecté automatiquement';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get qty => 'Qté';

  @override
  String get qtyKg => 'Kg';

  @override
  String get qtyL => 'L';

  @override
  String get total => 'Total';

  @override
  String get usedForPrice => 'utilisé pour l’historique des prix';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get discount => 'Remise';

  @override
  String get itemsMatch => 'Les articles correspondent au total imprimé';

  @override
  String itemsDiffer(String d) {
    return 'Les articles diffèrent du total imprimé de $d';
  }

  @override
  String get blurry =>
      'Flou ou coupé ? Reprenez la photo, le ticket sera relu.';

  @override
  String get correct => 'Corriger';

  @override
  String get saveReceipt => 'Enregistrer le ticket';

  @override
  String tSaved(String a) {
    return 'Ticket enregistré · $a';
  }

  @override
  String get tSaveFailed => 'Impossible d\'enregistrer le ticket. Réessayez.';

  @override
  String get tSaveFailedGeneric => 'Impossible d\'enregistrer. Réessayez.';

  @override
  String checkThis(String r, String q) {
    return 'À vérifier · lu comme « $r » · $q';
  }

  @override
  String readAs(String r) {
    return 'Lu comme « $r »';
  }

  @override
  String get lowConf => 'faible confiance';

  @override
  String get addedManually => 'ajouté manuellement';

  @override
  String get correctReceipt => 'Corriger le ticket';

  @override
  String get editIntro =>
      'Tout ce qui a été mal lu peut être corrigé ici. Le texte d’origine reste attaché pour l’historique des prix.';

  @override
  String get store => 'Magasin';

  @override
  String get change => 'Changer';

  @override
  String get time => 'Heure';

  @override
  String get itemsLabel => 'Articles';

  @override
  String get price => 'Prix';

  @override
  String get itemsTotal => 'Total articles';

  @override
  String get printedTotal => 'Total imprimé';

  @override
  String get applyCorrections => 'Appliquer les corrections';

  @override
  String get thisDevice => 'cet appareil';

  @override
  String get trendIncreased => 'augmenté';

  @override
  String get trendDecreased => 'baissé';

  @override
  String get homeNoExpensesTitle => 'Aucune dépense pour le moment';

  @override
  String get homeNoExpensesBody =>
      'Scannez quelques reçus pour voir vos habitudes de dépense.';

  @override
  String get scanFirstReceipt => 'Scanner votre premier reçu';

  @override
  String get historyNoRecordsTitle => 'Aucun enregistrement pour le moment';

  @override
  String get historyNoRecordsBody =>
      'Scannez un reçu ou ajoutez une dépense en espèces pour la voir ici.';

  @override
  String get historyNoMatchTitle => 'Aucune correspondance';

  @override
  String get historyNoMatchBody =>
      'Essayez une autre recherche ou un autre filtre.';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterReceipts => 'Reçus';

  @override
  String get filterCash => 'Espèces';

  @override
  String get storeNoProductsYet => 'Aucun produit pour le moment';

  @override
  String get storeNoProductsYetBody =>
      'Scannez un reçu de ce magasin pour voir ici les produits et les comparaisons de prix.';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String deleteCategoryConfirm(String n) {
    return 'Supprimer « $n » ? Cette action est irréversible.';
  }

  @override
  String get scanFailedTitle => 'Nous n\'avons pas pu lire clairement ce reçu.';

  @override
  String get scanFailedTips =>
      'Essayez :\n• Améliorer l’éclairage\n• Aplatir le reçu\n• Garder tout le reçu dans le cadre';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get enterManually => 'Saisir manuellement';

  @override
  String get deleteExpenseConfirmTitle => 'Supprimer cette dépense ?';

  @override
  String get deleteExpenseConfirmBody =>
      'Cela supprime définitivement la dépense de votre historique. Cette action est irréversible.';

  @override
  String get recordNotFound => 'Cet enregistrement n\'existe plus.';

  @override
  String get historyAllRecords => 'Tous les enregistrements';

  @override
  String get recordNotFoundBody => 'Il a peut-être été supprimé.';

  @override
  String get priceHistoryTitle => 'Historique des prix';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction de $percent% depuis le premier suivi';
  }

  @override
  String get priceHistoryNoDataTitle =>
      'Aucun historique de prix pour le moment';

  @override
  String get priceHistoryNoDataBody =>
      'Scannez un reçu avec ce produit pour commencer à suivre son prix dans le temps.';

  @override
  String get priceHistoryNotFoundTitle => 'Ce produit n\'existe plus.';

  @override
  String get priceHistoryNotFoundBody => 'Il a peut-être été supprimé.';

  @override
  String get scanningStatus => 'Numérisation';

  @override
  String get scanStatusSupported => 'Prêt';

  @override
  String get scanStatusChecking => 'Vérification…';

  @override
  String get scanStatusNoCamera => 'Aucun appareil photo disponible';

  @override
  String get scanStatusOcrUnavailable => 'Reconnaissance de texte indisponible';

  @override
  String get scanStatusPermissionDenied =>
      'Autorisation de l\'appareil photo requise';

  @override
  String get scanStatusPermissionPermanentlyDenied =>
      'Accès à l\'appareil photo bloqué';

  @override
  String get scanStatusUnavailable => 'Impossible de vérifier';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get scanUnsupportedNoCamera =>
      'Cet appareil n\'a pas d\'appareil photo';

  @override
  String get scanUnsupportedOcrUnavailable =>
      'La reconnaissance de texte n\'est pas disponible sur cet appareil';

  @override
  String get scanUnsupportedPermissionDenied =>
      'L\'autorisation de l\'appareil photo est requise pour numériser les reçus';

  @override
  String get scanUnsupportedPermissionPermanentlyDenied =>
      'L\'accès à l\'appareil photo est bloqué — activez-le dans les réglages';

  @override
  String get scanUnsupportedUnavailable =>
      'Impossible de vérifier la caméra — réessayez';

  @override
  String possibleDuplicateReceipt(String store, String date) {
    return 'Cela ressemble à un reçu déjà enregistré depuis $store le $date.';
  }

  @override
  String get importTitle => 'Restaurer depuis la sauvegarde ?';

  @override
  String importBody(String device) {
    return 'Cela ajoute chaque enregistrement du fichier à ce que vous avez déjà. Les enregistrements correspondants sont mis à jour ; rien sur $device n\'est supprimé.';
  }

  @override
  String get importConfirm => 'Restaurer';

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
      other: '$nString reçus',
      one: '$nString reçu',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: '$mString dépenses',
      one: '$mString dépense',
    );
    return 'Sauvegarde restaurée · $_temp0, $_temp1';
  }

  @override
  String get importMalformed => 'Ce fichier n\'est pas une sauvegarde valide.';

  @override
  String get importUnexpected =>
      'Une erreur s\'est produite lors de la restauration de cette sauvegarde.';

  @override
  String get importTooNew =>
      'Cette sauvegarde a été créée avec une version plus récente de l\'application.';

  @override
  String get importCanceled => 'Aucun fichier sélectionné.';
}
