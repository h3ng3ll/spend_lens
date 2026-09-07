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
  static const plus = '${_path}plus$_ext';
}
