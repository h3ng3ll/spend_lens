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
}
