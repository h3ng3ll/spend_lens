// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/NotoSans-Regular.ttf
  String get notoSansRegular => 'assets/fonts/NotoSans-Regular.ttf';

  /// File path: assets/fonts/NotoSans-SemiBold.ttf
  String get notoSansSemiBold => 'assets/fonts/NotoSans-SemiBold.ttf';

  /// File path: assets/fonts/OFL.txt
  String get ofl => 'assets/fonts/OFL.txt';

  /// List of all assets
  List<String> get values => [notoSansRegular, notoSansSemiBold, ofl];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple_logo.svg
  String get appleLogo => 'assets/icons/apple_logo.svg';

  /// File path: assets/icons/arrow_left_outlined.svg
  String get arrowLeftOutlined => 'assets/icons/arrow_left_outlined.svg';

  /// File path: assets/icons/check.svg
  String get check => 'assets/icons/check.svg';

  /// File path: assets/icons/chevron_down.svg
  String get chevronDown => 'assets/icons/chevron_down.svg';

  /// File path: assets/icons/chevron_left.svg
  String get chevronLeft => 'assets/icons/chevron_left.svg';

  /// File path: assets/icons/chevron_right.svg
  String get chevronRight => 'assets/icons/chevron_right.svg';

  /// File path: assets/icons/close.svg
  String get close => 'assets/icons/close.svg';

  /// File path: assets/icons/edit.svg
  String get edit => 'assets/icons/edit.svg';

  /// File path: assets/icons/empty_receipt.svg
  String get emptyReceipt => 'assets/icons/empty_receipt.svg';

  /// File path: assets/icons/flash.svg
  String get flash => 'assets/icons/flash.svg';

  /// File path: assets/icons/google_logo.svg
  String get googleLogo => 'assets/icons/google_logo.svg';

  /// File path: assets/icons/more_vertical.svg
  String get moreVertical => 'assets/icons/more_vertical.svg';

  /// File path: assets/icons/no_wifi.svg
  String get noWifi => 'assets/icons/no_wifi.svg';

  /// File path: assets/icons/pdf.svg
  String get pdf => 'assets/icons/pdf.svg';

  /// File path: assets/icons/plus.svg
  String get plus => 'assets/icons/plus.svg';

  /// File path: assets/icons/receipt.svg
  String get receipt => 'assets/icons/receipt.svg';

  /// File path: assets/icons/scan_frame.svg
  String get scanFrame => 'assets/icons/scan_frame.svg';

  /// File path: assets/icons/search.svg
  String get search => 'assets/icons/search.svg';

  /// File path: assets/icons/share.svg
  String get share => 'assets/icons/share.svg';

  /// File path: assets/icons/store.svg
  String get store => 'assets/icons/store.svg';

  /// File path: assets/icons/tab_analytics.svg
  String get tabAnalytics => 'assets/icons/tab_analytics.svg';

  /// File path: assets/icons/tab_compare.svg
  String get tabCompare => 'assets/icons/tab_compare.svg';

  /// File path: assets/icons/tab_history.svg
  String get tabHistory => 'assets/icons/tab_history.svg';

  /// File path: assets/icons/tab_home.svg
  String get tabHome => 'assets/icons/tab_home.svg';

  /// File path: assets/icons/tab_settings.svg
  String get tabSettings => 'assets/icons/tab_settings.svg';

  /// File path: assets/icons/tab_stores.svg
  String get tabStores => 'assets/icons/tab_stores.svg';

  /// File path: assets/icons/trash.svg
  String get trash => 'assets/icons/trash.svg';

  /// File path: assets/icons/user.svg
  String get user => 'assets/icons/user.svg';

  /// File path: assets/icons/warning.svg
  String get warning => 'assets/icons/warning.svg';

  /// List of all assets
  List<String> get values => [
    appleLogo,
    arrowLeftOutlined,
    check,
    chevronDown,
    chevronLeft,
    chevronRight,
    close,
    edit,
    emptyReceipt,
    flash,
    googleLogo,
    moreVertical,
    noWifi,
    pdf,
    plus,
    receipt,
    scanFrame,
    search,
    share,
    store,
    tabAnalytics,
    tabCompare,
    tabHistory,
    tabHome,
    tabSettings,
    tabStores,
    trash,
    user,
    warning,
  ];
}

class $AssetsLauncherGen {
  const $AssetsLauncherGen();

  /// File path: assets/launcher/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/launcher/icon.png');

  /// File path: assets/launcher/icon_background.png
  AssetGenImage get iconBackground =>
      const AssetGenImage('assets/launcher/icon_background.png');

  /// File path: assets/launcher/icon_foreground.png
  AssetGenImage get iconForeground =>
      const AssetGenImage('assets/launcher/icon_foreground.png');

  /// List of all assets
  List<AssetGenImage> get values => [icon, iconBackground, iconForeground];
}

class $AssetsLegalGen {
  const $AssetsLegalGen();

  /// File path: assets/legal/privacy_policy.md
  String get privacyPolicy => 'assets/legal/privacy_policy.md';

  /// File path: assets/legal/terms_of_use.md
  String get termsOfUse => 'assets/legal/terms_of_use.md';

  /// List of all assets
  List<String> get values => [privacyPolicy, termsOfUse];
}

class $AssetsSplashGen {
  const $AssetsSplashGen();

  /// File path: assets/splash/splash_glyph.png
  AssetGenImage get splashGlyph =>
      const AssetGenImage('assets/splash/splash_glyph.png');

  /// List of all assets
  List<AssetGenImage> get values => [splashGlyph];
}

abstract final class Assets {
  static const String aEnv = '.env';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsLauncherGen launcher = $AssetsLauncherGen();
  static const $AssetsLegalGen legal = $AssetsLegalGen();
  static const $AssetsSplashGen splash = $AssetsSplashGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
