import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/theme.dart';

class OnboardingItem extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;
  const OnboardingItem({
    super.key,
    required this.asset,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 40,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SvgPicture.asset(
                //   asset,
                //   height: MediaQuery.sizeOf(context).height * 0.25,
                // ),
                LottieBuilder.asset(
                  asset,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ],
            )
            .animate(delay: 750.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 1, end: 0, duration: 500.ms),
        Expanded(
          child:
              Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 20,
                      children: [
                        AppText.heading(
                          text: title,
                          alignment: TextAlign.center,
                        ),
                        AppText.secondary(
                          text: subtitle,
                          alignment: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  .animate(delay: 250.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 1, end: 0, duration: 500.ms),
        ),
        // const SizedBox(),
      ],
    );
  }
}
