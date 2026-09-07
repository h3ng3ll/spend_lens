// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get deleteAllTitle => '¿Borrar todos los datos?';

  @override
  String deleteAllBody(int n, String device) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Se eliminarán $nString registros, fotos de tickets, tiendas y categorías de $device. Las copias en la nube no se ven afectadas. No se puede deshacer.';
  }

  @override
  String get deleteAllConfirm => 'Borrar todo';

  @override
  String get tDeletedAll => 'Todos los datos borrados';

  @override
  String get renameCategory => 'Renombrar categoría';

  @override
  String catRenamed(String n) {
    return 'Renombrada a $n';
  }

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get categoryEmpty => 'Aún no hay categorías';

  @override
  String get createCategory => 'Crear categoría';

  @override
  String get newCatPh => 'Nombre de la nueva categoría';

  @override
  String get searchCatPh => 'Busca o escribe una categoría nueva';

  @override
  String get newCatHint => 'Nueva categoría · aparece en todos los selectores';

  @override
  String get catNote =>
      'Las categorías integradas no se pueden eliminar. Las personalizadas se pueden borrar mientras no se usen.';

  @override
  String get catDefault => 'Integrada';

  @override
  String get catCustom => 'Personalizada · sin uso';

  @override
  String catUsed(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Personalizada · $nString registros';
  }

  @override
  String catCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString creada';
  }

  @override
  String catDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString eliminada';
  }

  @override
  String get noStore => 'Sin tienda';

  @override
  String get deleteStore => 'Eliminar tienda';

  @override
  String get deleteStoreNote =>
      'Solo posible mientras no tenga tickets vinculados.';

  @override
  String storeDeleted(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString eliminada';
  }

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabAnalytics => 'Análisis';

  @override
  String get tabStores => 'Tiendas';

  @override
  String get tabHistory => 'Historial';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get settings => 'Ajustes';

  @override
  String get currency => 'Moneda';

  @override
  String get categories => 'Categorías';

  @override
  String get language => 'Idioma';

  @override
  String get appearance => 'Apariencia';

  @override
  String get deleteAll => 'Borrar todos los datos';

  @override
  String get privacy => 'Privacidad';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDescription =>
      'Un rastreador de gastos local. Escanea recibos o añade gastos en efectivo y descubre en qué se va tu dinero — todo se guarda en este dispositivo.';

  @override
  String get done => 'Listo';

  @override
  String get langNote =>
      'Cambia el idioma de la app. Los tickets conservan su texto original.';

  @override
  String get currencyNote =>
      'Se usa para totales y análisis. Los tickets conservan su moneda impresa.';

  @override
  String get splashTag => 'Tus tickets, entendidos.';

  @override
  String onDevice(String device) {
    return 'Todo se queda en $device';
  }

  @override
  String get skip => 'Omitir';

  @override
  String get noAccount => 'Sin cuenta';

  @override
  String get noUpload => 'Sin subida';

  @override
  String get offline => 'Sin conexión';

  @override
  String get yourCurrency => 'Tu moneda';

  @override
  String get continue_ => 'Continuar';

  @override
  String get getStarted => 'Empezar';

  @override
  String get onb0Title => 'Sabe a dónde va tu dinero.';

  @override
  String get onb0Point0 => 'Cada ticket se convierte en un gasto estructurado';

  @override
  String get onb0Point1 => 'Categorías y totales, sin teclear';

  @override
  String get onb0Point2 => 'Precios seguidos en el tiempo';

  @override
  String get onb1Title => 'Escanea tickets en segundos.';

  @override
  String get onb1Point0 => 'Apunta la cámara, el ticket se detecta';

  @override
  String get onb1Point1 => 'El texto se lee en tu iPhone';

  @override
  String get onb1Point2 => 'Productos y precios extraídos automáticamente';

  @override
  String get onb2Title => 'Tus datos se quedan en tu dispositivo.';

  @override
  String get onb2Point0 => 'Local primero, funciona sin conexión';

  @override
  String get onb2Point1 => 'No requiere cuenta';

  @override
  String get onb2Point2 =>
      'La sincronización en la nube se puede activar después';

  @override
  String get spentThisMonth => 'gastado este mes';

  @override
  String vs(String m) {
    return 'vs $m';
  }

  @override
  String get scanReceipt => 'Escanear ticket';

  @override
  String get addCash => 'Añadir gasto en efectivo';

  @override
  String get all => 'Todo';

  @override
  String get recent => 'Recientes';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get onDeviceShort => 'En el dispositivo';

  @override
  String get synced => 'Sincronizado';

  @override
  String get average => 'Promedio';

  @override
  String get purchases => 'Compras';

  @override
  String get thisMonth => 'este mes';

  @override
  String get cash => 'Efectivo';

  @override
  String get ofSpending => 'del gasto';

  @override
  String get insights => 'Observaciones';

  @override
  String get cashVsReceipts => 'Efectivo vs tickets';

  @override
  String get receiptsLower => 'tickets';

  @override
  String get cashLower => 'efectivo';

  @override
  String get period => 'Periodo';

  @override
  String periodRange(String a, String b) {
    return 'Registros de $a a $b';
  }

  @override
  String get pdf => 'PDF';

  @override
  String get pdfExportUnavailable =>
      'La exportación a PDF llegará en una futura actualización.';

  @override
  String get signInComingSoon =>
      'El inicio de sesión llegará en una futura actualización.';

  @override
  String get exportComingSoon =>
      'La exportación e importación llegarán en una futura actualización.';

  @override
  String pdfToast(String m) {
    return 'Informe $m · PDF listo para compartir';
  }

  @override
  String purchase1(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString compra';
  }

  @override
  String purchaseN(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString compras';
  }

  @override
  String get top => 'top';

  @override
  String ins1(int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return 'Alimentación es el $pString% de tu gasto.';
  }

  @override
  String ins2(String category, String direction, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'El gasto en $category $direction un $percentString% este mes.';
  }

  @override
  String ins3(String a, String b, String c) {
    return 'Tu compra media subió de $a a $b $c.';
  }

  @override
  String insA1(String category, int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$category fue el $percentString% de tu gasto.';
  }

  @override
  String insA2(String category, int percent, String month) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'El gasto en $category bajó un $percentString% en $month.';
  }

  @override
  String insA3(String value, String c) {
    return 'Tu compra media fue $value $c.';
  }

  @override
  String get catFood => 'Alimentación';

  @override
  String get catTransport => 'Transporte';

  @override
  String get catHousehold => 'Hogar';

  @override
  String get catRestaurantsCoffee => 'Restaurantes y café';

  @override
  String get catRestaurants => 'Restaurantes';

  @override
  String get catHealth => 'Salud';

  @override
  String get catOther => 'Otros';

  @override
  String get catShopping => 'Compras';

  @override
  String get catEntertainment => 'Entretenimiento';

  @override
  String get catUtilities => 'Servicios públicos';

  @override
  String get catTravel => 'Viajes';

  @override
  String get catEducation => 'Educación';

  @override
  String get catPersonalCare => 'Cuidado personal';

  @override
  String get months0 => 'Enero';

  @override
  String get months1 => 'Febrero';

  @override
  String get months2 => 'Marzo';

  @override
  String get months3 => 'Abril';

  @override
  String get months4 => 'Mayo';

  @override
  String get months5 => 'Junio';

  @override
  String get months6 => 'Julio';

  @override
  String get months7 => 'Agosto';

  @override
  String get months8 => 'Septiembre';

  @override
  String get months9 => 'Octubre';

  @override
  String get months10 => 'Noviembre';

  @override
  String get months11 => 'Diciembre';

  @override
  String get monthsShort0 => 'Ene';

  @override
  String get monthsShort1 => 'Feb';

  @override
  String get monthsShort2 => 'Mar';

  @override
  String get monthsShort3 => 'Abr';

  @override
  String get monthsShort4 => 'May';

  @override
  String get monthsShort5 => 'Jun';

  @override
  String get monthsShort6 => 'Jul';

  @override
  String get monthsShort7 => 'Ago';

  @override
  String get monthsShort8 => 'Sep';

  @override
  String get monthsShort9 => 'Oct';

  @override
  String get monthsShort10 => 'Nov';

  @override
  String get monthsShort11 => 'Dic';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get receipt => 'Ticket';

  @override
  String get cashType => 'Efectivo';

  @override
  String get receipts => 'Tickets';

  @override
  String get newStore => 'Nueva tienda';

  @override
  String get storesIntro =>
      'Creado automáticamente a partir de tus tickets. Abre una tienda para ver sus productos y comparar precios.';

  @override
  String get storesEmptyTitle => 'Aún no hay tiendas';

  @override
  String get storesEmptyBody =>
      'Añade una tienda para hacer seguimiento de dónde compras y comparar precios.';

  @override
  String get visits => 'Visitas';

  @override
  String get spent => 'Gastado';

  @override
  String get products => 'Productos';

  @override
  String get productsHere => 'Productos comprados aquí';

  @override
  String get cmpNote =>
      'Las comparaciones usan tus tickets de los últimos 60 días, no precios en vivo.';

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

    return '$vString visitas · $pString productos';
  }

  @override
  String storeEmpty(String t) {
    return '$t · aún sin tickets';
  }

  @override
  String bought(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'Comprado $nString×';
  }

  @override
  String get byWeight => 'a peso';

  @override
  String cheapestOf(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return 'El más barato de $nString tiendas';
  }

  @override
  String cheaperBy(String s, int p, String d) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString · más barato por $d';
  }

  @override
  String cheaperHere(String s, int p) {
    final intl.NumberFormat pNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String pString = pNumberFormat.format(p);

    return '$s $pString /kg · más barato aquí';
  }

  @override
  String get onlyHere => 'Solo comprado aquí';

  @override
  String get storeTypeSupermarket => 'Supermercado';

  @override
  String get storeTypeMarket => 'Mercado';

  @override
  String get storeTypePharmacy => 'Farmacia';

  @override
  String get storeTypeCafe => 'Cafetería';

  @override
  String get storeTypeOther => 'Otros';

  @override
  String get storeTypeStore => 'Tienda';

  @override
  String get chooseStore => 'Elegir tienda';

  @override
  String get searchStorePh => 'Busca o escribe una tienda nueva';

  @override
  String get create => 'Crear';

  @override
  String get newStoreHint =>
      'Nueva tienda · los próximos tickets se vincularán';

  @override
  String get noMatch => 'Ninguna tienda coincide';

  @override
  String get createNewStore => 'Crear tienda nueva';

  @override
  String get createNewStoreSub => 'Nombre, alias en ticket y tipo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get newStoreNote =>
      'Los tickets con este nombre de tienda se vincularán automáticamente.';

  @override
  String get name => 'Nombre';

  @override
  String get namePh => 'p. ej. Nr.1, Green Hills';

  @override
  String get alias => 'Aparece en tickets como';

  @override
  String get aliasPh => 'Opcional · p. ej. NR1 SRL';

  @override
  String get type => 'Tipo';

  @override
  String get createStore => 'Crear tienda';

  @override
  String storeCreated(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString creada y seleccionada';
  }

  @override
  String storeAdded(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString añadida · los tickets se vincularán';
  }

  @override
  String get searchPh => 'Buscar tickets, productos, tiendas';

  @override
  String get profile => 'Perfil';

  @override
  String get keepSafe => 'Protege tus datos';

  @override
  String keepSafeBody(String device) {
    return 'Tus tickets solo viven en $device. Inicia sesión para respaldarlos y sincronizar. No se sube nada hasta que lo hagas.';
  }

  @override
  String get continueGoogle => 'Continuar con Google';

  @override
  String get continueApple => 'Continuar con Apple';

  @override
  String get account => 'Cuenta';

  @override
  String get plan => 'Plan';

  @override
  String get cloudSync => 'Sincronización';

  @override
  String get upToDate => 'Al día';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get yourData => 'Tus datos';

  @override
  String get exportBackup => 'Exportar copia';

  @override
  String get exportSheet => 'Exportar hoja de cálculo';

  @override
  String get importBackup => 'Importar copia';

  @override
  String get exportNote =>
      'Las exportaciones se comparten con la hoja de compartir de iOS. Las importaciones se validan antes de restaurar.';

  @override
  String get localAccount => 'Cuenta local';

  @override
  String get notSignedIn => 'Sin sesión · solo en el dispositivo';

  @override
  String get signedInGoogle => 'Sesión con Google';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get cloudStorage => 'Almacenamiento en la nube';

  @override
  String get unlimited => 'Ilimitado · en el dispositivo';

  @override
  String storageOf(String a, String b) {
    return '$a de $b';
  }

  @override
  String limitFree(String quota) {
    return 'Fotos y datos se respaldan en tu cuenta. Las cuentas gratis incluyen $quota.';
  }

  @override
  String limitPremium(String quota) {
    return 'Premium: $quota en la nube, historial ilimitado y sincronización multidispositivo.';
  }

  @override
  String limitLocal(String device) {
    return 'Todo se guarda en $device sin límite. Inicia sesión para respaldar.';
  }

  @override
  String get free => 'Gratis';

  @override
  String get premium => 'Premium';

  @override
  String toPremium(String quota) {
    return 'Pasar a Premium · $quota en la nube';
  }

  @override
  String tPremiumOn(String quota) {
    return 'Premium activado · $quota';
  }

  @override
  String tPremiumOff(String quota) {
    return 'De vuelta al plan Gratis · $quota';
  }

  @override
  String get tSignedIn => 'Sesión iniciada · sincronización activa';

  @override
  String get tSignedOut => 'Sesión cerrada · datos en el dispositivo';

  @override
  String tBackup(String filename) {
    return 'Copia lista · $filename';
  }

  @override
  String tCsv(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Hoja lista · $countString filas';
  }

  @override
  String get tImport => 'Elige un archivo de copia';

  @override
  String get dark => 'Oscuro';

  @override
  String get light => 'Claro';

  @override
  String get edit => 'Editar';

  @override
  String get note => 'Nota';

  @override
  String get receiptPhoto => 'Foto del ticket';

  @override
  String get view => 'Ver';

  @override
  String get retake => 'Repetir foto';

  @override
  String get chooseLibrary => 'Elegir de la galería';

  @override
  String get share => 'Compartir';

  @override
  String get cashExpense => 'Gasto en efectivo';

  @override
  String get deleteReceipt => 'Eliminar ticket';

  @override
  String get deleteExpense => 'Eliminar gasto';

  @override
  String items(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString artículos';
  }

  @override
  String get photoStored => 'foto del ticket · en el dispositivo';

  @override
  String get photoUpdated => 'foto del ticket · actualizada ahora';

  @override
  String photoTitle(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString · ticket';
  }

  @override
  String get tRetake => 'Se abre la cámara · foto reemplazada';

  @override
  String get tLibrary => 'Foto reemplazada desde la galería';

  @override
  String get tShare => 'Compartiendo foto del ticket…';

  @override
  String get tOpenReceipt => 'Abre el ticket para corregir artículos';

  @override
  String tDeleted(String t, String a) {
    return '$t eliminado · $a';
  }

  @override
  String get expense => 'Gasto';

  @override
  String get amount => 'Importe';

  @override
  String get enterValidAmount => 'Introduce un importe válido';

  @override
  String get category => 'Categoría';

  @override
  String get optional => 'Opcional';

  @override
  String get date => 'Fecha';

  @override
  String get save => 'Guardar';

  @override
  String tCashAdded(String a) {
    return '$a añadido';
  }

  @override
  String get receiptDetected => 'Ticket detectado';

  @override
  String get looking => 'Buscando un ticket…';

  @override
  String get holdStill => 'No te muevas';

  @override
  String get capturing => 'Capturando…';

  @override
  String get keepInFrame => 'Mantén todo el ticket dentro del marco';

  @override
  String get autoCapture => 'Captura automática';

  @override
  String get flashAuto => 'Auto';

  @override
  String get flashOn => 'Sí';

  @override
  String get flashOff => 'No';

  @override
  String get steps0 => 'Detectando ticket';

  @override
  String get steps1 => 'Leyendo texto';

  @override
  String get steps2 => 'Buscando productos';

  @override
  String get steps3 => 'Comprobando precios';

  @override
  String get reviewReceipt => 'Revisar ticket';

  @override
  String get autoDetected => 'Detectado automáticamente';

  @override
  String get addItem => 'Añadir artículo';

  @override
  String get qty => 'Cant.';

  @override
  String get total => 'Total';

  @override
  String get usedForPrice => 'usado para el historial de precios';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Descuento';

  @override
  String get itemsMatch => 'Los artículos coinciden con el total impreso';

  @override
  String itemsDiffer(String d) {
    return 'Los artículos difieren del total impreso en $d';
  }

  @override
  String get blurry =>
      '¿Borroso o cortado? Repite la foto y el ticket se leerá de nuevo.';

  @override
  String get correct => 'Corregir';

  @override
  String get saveReceipt => 'Guardar ticket';

  @override
  String tSaved(String a) {
    return 'Ticket guardado · $a';
  }

  @override
  String checkThis(String r, String q) {
    return 'Revisa · leído como \"$r\" · $q';
  }

  @override
  String readAs(String r) {
    return 'Leído como \"$r\"';
  }

  @override
  String get lowConf => 'baja confianza';

  @override
  String get addedManually => 'añadido a mano';

  @override
  String get correctReceipt => 'Corregir ticket';

  @override
  String get editIntro =>
      'Todo lo leído incorrectamente se puede corregir aquí. El texto original del ticket se conserva para el historial de precios.';

  @override
  String get store => 'Tienda';

  @override
  String get change => 'Cambiar';

  @override
  String get time => 'Hora';

  @override
  String get itemsLabel => 'Artículos';

  @override
  String get price => 'Precio';

  @override
  String get itemsTotal => 'Total artículos';

  @override
  String get printedTotal => 'Total impreso';

  @override
  String get applyCorrections => 'Aplicar correcciones';

  @override
  String get thisDevice => 'este dispositivo';

  @override
  String get trendIncreased => 'subió';

  @override
  String get trendDecreased => 'bajó';

  @override
  String get homeNoExpensesTitle => 'Aún no hay gastos';

  @override
  String get homeNoExpensesBody =>
      'Escanea algunos recibos para ver tus patrones de gasto.';

  @override
  String get scanFirstReceipt => 'Escanea tu primer recibo';

  @override
  String get scanComingSoon => 'El escaneo llegará en una futura actualización';

  @override
  String get historyNoRecordsTitle => 'Aún no hay registros';

  @override
  String get historyNoRecordsBody =>
      'Escanea un recibo o añade un gasto en efectivo para verlo aquí.';

  @override
  String get historyNoMatchTitle => 'Sin coincidencias';

  @override
  String get historyNoMatchBody => 'Prueba otra búsqueda o filtro.';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterReceipts => 'Recibos';

  @override
  String get filterCash => 'Efectivo';

  @override
  String get storeNoProductsYet => 'Aún no hay productos';

  @override
  String get storeNoProductsYetBody =>
      'Escanea un recibo de esta tienda para ver aquí los productos y las comparaciones de precio.';

  @override
  String get deleteCategory => 'Eliminar categoría';

  @override
  String deleteCategoryConfirm(String n) {
    return '¿Eliminar \"$n\"? Esta acción no se puede deshacer.';
  }

  @override
  String get scanFailedTitle => 'No pudimos leer este recibo con claridad.';

  @override
  String get scanFailedTips =>
      'Prueba:\n• Mejorar la iluminación\n• Aplanar el recibo\n• Mantener todo el recibo dentro del marco';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get enterManually => 'Ingresar manualmente';

  @override
  String get deleteExpenseConfirmTitle => '¿Eliminar este gasto?';

  @override
  String get deleteExpenseConfirmBody =>
      'Esto elimina permanentemente el gasto de tu historial. No se puede deshacer.';

  @override
  String get recordNotFound => 'Este registro ya no existe.';

  @override
  String get editComingSoon =>
      'La edición llegará en una futura actualización.';

  @override
  String get historyAllRecords => 'Todos los registros';

  @override
  String get recordNotFoundBody => 'Puede que se haya eliminado.';

  @override
  String get priceHistoryTitle => 'Historial de precios';

  @override
  String priceHistoryChangeLabel(String direction, String percent) {
    return '$direction $percent% desde el primer seguimiento';
  }

  @override
  String get priceHistoryNoDataTitle => 'Aún no hay historial de precios';

  @override
  String get priceHistoryNoDataBody =>
      'Escanea un recibo con este producto para empezar a seguir su precio en el tiempo.';

  @override
  String get priceHistoryNotFoundTitle => 'Este producto ya no existe.';

  @override
  String get priceHistoryNotFoundBody => 'Puede que se haya eliminado.';
}
