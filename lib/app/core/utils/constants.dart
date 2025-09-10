import 'package:flutter/material.dart';

const String onboarding1Dark = 'assets/svgs/onboard-1-dark.svg';
const String onboarding2Dark = 'assets/svgs/onboard-2-dark.svg';
const String onboarding3Dark = 'assets/svgs/onboard-3-dark.svg';
const String onboarding1Light = 'assets/svgs/onboard-1-light.svg';
const String onboarding2Light = 'assets/svgs/onboard-2-light.svg';
const String onboarding3Light = 'assets/svgs/onboard-3-light.svg';

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
