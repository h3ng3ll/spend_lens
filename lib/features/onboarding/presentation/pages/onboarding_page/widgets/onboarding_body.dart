import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import 'onboarding_footer_row.dart';
import 'onboarding_privacy_hero.dart';
import 'onboarding_receipt_card.dart';
import 'onboarding_skip_row.dart';
import 'onboarding_step_content.dart';

/// The real 3-step onboarding carousel (design_spendlens.md M10 — the
/// design's `onb0`/`onb1`/`onb2` copy). Owns the `PageController` and the
/// current-step index; navigation/persistence decisions stay in
/// [OnboardingPage] (A2 — no bloc dispatch here), which supplies
/// [onGetStarted] and [onSkip].
///
/// CHRONIC BUG GUARD (`db:min-column-pageview-expanded-top-aligns-void`):
/// each `PageView` page is `OnboardingStepContent`, whose min-size Column
/// carries `mainAxisAlignment: MainAxisAlignment.center` — see that file's
/// doc comment for why `center` is live here (a `PageView` page is a tight
/// full-height constraint, unlike a `SingleChildScrollView` child).
class OnboardingBody extends StatefulWidget {
  final VoidCallback onGetStarted;
  final String getStartedLabel;

  const OnboardingBody({
    super.key,
    required this.onGetStarted,
    required this.getStartedLabel,
  });

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  static const _kStepCount = 3;
  static const _kPageAnimationDuration = Duration(milliseconds: 300);

  final PageController _pageController = PageController();
  int _activeIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) => setState(() => _activeIndex = index);

  void _onSkip() => widget.onGetStarted();

  void _onCta() {
    if (_activeIndex == _kStepCount - 1) {
      widget.onGetStarted();
      return;
    }
    _pageController.nextPage(
      duration: _kPageAnimationDuration,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    final steps = [
      OnboardingStepContent(
        hero: const OnboardingReceiptCard(width: 160.0, height: 130.0),
        title: lo.onb0Title,
        points: [lo.onb0Point0, lo.onb0Point1, lo.onb0Point2],
      ),
      OnboardingStepContent(
        hero: Stack(
          alignment: Alignment.center,
          children: [
            const OnboardingReceiptCard(
              width: 180.0,
              height: 150.0,
              highlighted: true,
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: AppSvgIcon(
                asset: AppIcons.scanFrame,
                color: scheme.accent,
                size: 40.0,
              ),
            ),
          ],
        ),
        title: lo.onb1Title,
        points: [lo.onb1Point0, lo.onb1Point1, lo.onb1Point2],
      ),
      OnboardingStepContent(
        hero: const OnboardingPrivacyHero(size: 130.0),
        title: lo.onb2Title,
        points: [lo.onb2Point0, lo.onb2Point1, lo.onb2Point2],
      ),
    ];

    return SafeArea(
      child: Column(
        spacing: 16.0,
        children: [
          OnboardingSkipRow(onSkip: _onSkip, skipLabel: lo.skip),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: steps,
            ),
          ),
          OnboardingFooterRow(
            stepCount: _kStepCount,
            activeIndex: _activeIndex,
            ctaLabel: _activeIndex == _kStepCount - 1
                ? widget.getStartedLabel
                : lo.continue_,
            onCta: _onCta,
          ),
        ],
      ),
    );
  }
}
