import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import 'items/login_sheet.dart';
import 'items/onboarding_item.dart';
import 'items/register_sheet.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageCont = PageController(initialPage: 0);

  double _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageContainer(
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 40,
        ),
        child: Column(
          children: [
            if (_currentIndex > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: MyIconButton(
                  icon: MyIcons.chevron_left,
                  onTap: () {
                    _pageCont.previousPage(
                      duration: 250.ms,
                      curve: Curves.easeIn,
                    );

                    setState(() {
                      _currentIndex--;
                    });
                  },
                ),
              ),
            Expanded(
              child: PageView(
                controller: _pageCont,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  OnboardingItem(
                    title: 'Welcome to\nShared Plates',
                    subtitle:
                        'Where your recipes mingle before your guests do.',
                    asset: onboardingAsset(context, 1),
                  ),
                  OnboardingItem(
                    title: 'Share Your Recipes',
                    subtitle:
                        'Keep your recipes private or share them to the world.',
                    asset: onboardingAsset(context, 2),
                  ),
                  OnboardingItem(
                    title: 'Discover Recipes',
                    subtitle:
                        'Discover recipes that match your palate and your wallet.',
                    asset: onboardingAsset(context, 3),
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
              Column(
                spacing: 10,
                children: [
                  WideTextButton(
                        color: context.containerInverse,
                        textColor: context.darkText,
                        radius: 40,
                        text: 'Login',
                        onTap: () {
                          showModalBottomSheet(
                            barrierColor: Colors.black.withValues(alpha: 0.6),
                            backgroundColor: context.background,
                            isDismissible: true,
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            sheetAnimationStyle: AnimationStyle(
                              duration: 500.ms,
                              curve: Curves.easeIn,
                            ),
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: const SingleChildScrollView(
                                child: LoginSheet(),
                              ),
                            ),
                          );
                        },
                      )
                      .animate(delay: 1250.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 1, end: 0, duration: 500.ms),
                  WideTextButton(
                        radius: 40,
                        text: 'Sign Up',
                        onTap: () {
                          showModalBottomSheet(
                            barrierColor: Colors.black.withValues(alpha: 0.6),
                            backgroundColor: context.background,
                            isScrollControlled: true,
                            isDismissible: true,
                            useSafeArea: true,
                            context: context,
                            sheetAnimationStyle: AnimationStyle(
                              duration: 500.ms,
                              curve: Curves.easeIn,
                            ),
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: const SingleChildScrollView(
                                child: RegisterSheet(),
                              ),
                            ),
                          );
                        },
                      )
                      .animate(delay: 1500.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 1, end: 0, duration: 500.ms),
                ],
              )
            else
              WideTextButton(
                    radius: 40,
                    text: 'Next',
                    onTap: () {
                      _pageCont.nextPage(
                        duration: 250.ms,
                        curve: Curves.easeIn,
                      );

                      setState(() {
                        _currentIndex++;
                      });
                    },
                  )
                  .animate(delay: 1250.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 1, end: 0, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
