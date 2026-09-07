/// SVG icon asset paths, resolved via `SvgPicture.asset(AppIcons.x)`.
///
/// M1 seeds only the icons the copied `core/` widgets need to compile
/// (`CustomBackBtn`, `BuildImage`'s placeholder). Later milestones add the
/// design system's full icon set here as screens need them.
abstract class AppIcons {
  static const _path = 'assets/icons/';
  static const _ext = '.svg';

  static const arrowLeftOutlined = '${_path}arrow_left_outlined$_ext';
  static const user = '${_path}user$_ext';
}
