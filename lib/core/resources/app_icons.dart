/// SVG icon asset paths, resolved via `SvgPicture.asset(AppIcons.x)`.
///
/// M1 seeded only the icons the copied `core/` widgets need to compile
/// (`CustomBackBtn`, `BuildImage`'s placeholder). M2 adds `check` for the
/// Language/Currency sheets' selected-row indicator. Later milestones add
/// the design system's full icon set here as screens need them.
abstract class AppIcons {
  static const _path = 'assets/icons/';
  static const _ext = '.svg';

  static const arrowLeftOutlined = '${_path}arrow_left_outlined$_ext';
  static const user = '${_path}user$_ext';
  static const check = '${_path}check$_ext';

  // M4: the 5-tab shell pill (design_spendlens.md §5).
  static const tabHome = '${_path}tab_home$_ext';
  static const tabAnalytics = '${_path}tab_analytics$_ext';
  static const tabStores = '${_path}tab_stores$_ext';
  static const tabHistory = '${_path}tab_history$_ext';
  static const tabSettings = '${_path}tab_settings$_ext';
  static const tabCompare = '${_path}tab_compare$_ext';
  static const plus = '${_path}plus$_ext';

  // M5: manual-entry screens (design_spendlens.md §10).
  static const chevronRight = '${_path}chevron_right$_ext';
  static const chevronLeft = '${_path}chevron_left$_ext';
  static const chevronDown = '${_path}chevron_down$_ext';
  static const close = '${_path}close$_ext';
  static const edit = '${_path}edit$_ext';
  static const moreVertical = '${_path}more_vertical$_ext';
  static const trash = '${_path}trash$_ext';
  static const search = '${_path}search$_ext';
  static const receipt = '${_path}receipt$_ext';
  static const share = '${_path}share$_ext';
  static const pdf = '${_path}pdf$_ext';
  static const warning = '${_path}warning$_ext';
  static const store = '${_path}store$_ext';
  static const noWifi = '${_path}no_wifi$_ext';
  static const emptyReceipt = '${_path}empty_receipt$_ext';
  static const scanFrame = '${_path}scan_frame$_ext';

  // M7: Scanner artboard's flash toggle + close controls
  // (design_spendlens.md §10). `close` already exists (M5).
  static const flash = '${_path}flash$_ext';

  // M5: Profile screen's sign-in buttons (design_spendlens.md's Profile
  // artboard). `googleLogo` is a real multi-color brand mark — render it
  // via a bare `SvgPicture.asset`, NOT `AppSvgIcon`, since `AppSvgIcon`
  // forces a single-color `colorFilter` that would flatten it.
  static const googleLogo = '${_path}google_logo$_ext';
  static const appleLogo = '${_path}apple_logo$_ext';
}
