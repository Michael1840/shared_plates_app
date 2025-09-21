import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../main.dart';
import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import 'items/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageCont = PageController(initialPage: 0);

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageContainer(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if (_currentIndex > 0)
                //   Align(
                //     alignment: Alignment.centerLeft,
                //     child: MyIconButton(
                //       icon: MyIcons.chevron_left,
                //       onTap: () {
                //         _pageCont.previousPage(
                //           duration: 250.ms,
                //           curve: Curves.easeIn,
                //         );

                //         setState(() {
                //           _currentIndex--;
                //         });
                //       },
                //     ),
                //   ),
                // const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      const AppText.primary(
                        text: 'Skip',
                        color: TextColors.secondary,
                      ).onTap(() {
                        tokenStorage.setOnboardingCompleted();
                        context.goNamed(Routes.auth);
                      }),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageCont,
                onPageChanged: (i) {
                  setState(() {
                    _currentIndex = i;
                  });
                },
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  const OnboardingItem(
                    title: 'Welcome to\nShared Plates',
                    subtitle:
                        'The table is set, and we\'re hungry for what you\'ll cook up.',
                    // asset: onboarding1,
                    asset: Animations.cooking,
                  ),
                  const OnboardingItem(
                    title: 'Share Your Recipes',
                    subtitle:
                        'Keep your recipes private or share them to the world.',
                    asset: Animations.lunchPost,
                    // asset: onboarding2,
                  ),
                  const OnboardingItem(
                    title: 'Discover Recipes',
                    subtitle:
                        'Discover recipes that match your palate and your wallet.',
                    asset: Animations.eatingSushi,
                    // asset: onboarding3,
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
                  controller: _pageCont,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: context.onContainer,
                    dotColor: context.onContainer.withValues(alpha: 0.2),
                  ),
                )
                .animate(delay: 1250.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 1, end: 0, duration: 500.ms),
            const SizedBox(height: 40),
            if (_currentIndex == 2)
              WideTextButton(
                    radius: 40,
                    text: _currentIndex == 2 ? 'Get Started' : 'Next',
                    onTap: () {
                      if (_currentIndex == 2) {
                        tokenStorage.setOnboardingCompleted();
                        context.goNamed(Routes.auth);
                      } else {
                        _pageCont.nextPage(
                          duration: 250.ms,
                          curve: Curves.easeIn,
                        );

                        setState(() {
                          _currentIndex++;
                        });
                      }
                    },
                  )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 1, end: 0, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
