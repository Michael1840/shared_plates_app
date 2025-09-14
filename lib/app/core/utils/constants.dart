import 'package:flutter/material.dart';

const String sharedPlatesSvg = 'assets/svgs/shared-plates-logo.svg';
const String appleSvg = 'assets/svgs/apple.svg';
const String googleSvg = 'assets/svgs/google.svg';
const String onboarding1Dark = 'assets/svgs/onboard-1-dark.svg';
const String onboarding2Dark = 'assets/svgs/onboard-2-dark.svg';
const String onboarding3Dark = 'assets/svgs/onboard-3-dark.svg';
const String onboarding1Light = 'assets/svgs/onboard-1-dark.svg';
const String onboarding2Light = 'assets/svgs/onboard-2-dark.svg';
const String onboarding3Light = 'assets/svgs/onboard-3-dark.svg';

const String onboarding1 = 'assets/svgs/onboarding-1.svg';
const String onboarding2 = 'assets/svgs/onboarding-2.svg';
const String onboarding3 = 'assets/svgs/onboarding-3.svg';

String onboardingAsset(BuildContext context, int index) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  switch (index) {
    case 1:
      return isDark ? onboarding1Dark : onboarding1Light;
    case 2:
      return isDark ? onboarding2Dark : onboarding2Light;
    case 3:
      return isDark ? onboarding3Dark : onboarding3Light;
    default:
      throw Exception('Invalid onboarding index');
  }
}
