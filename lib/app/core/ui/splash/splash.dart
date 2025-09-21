import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../theme/theme.dart';
import '../../utils/constants.dart';
import '../../utils/extensions.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    int i = Random().nextInt(3) + 1;

    String animation;

    if (i == 3) {
      animation = Animations.shoppingBasket;
    } else if (i == 2) {
      animation = Animations.friedEgg;
    } else {
      animation = Animations.mixing;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AccentColors.green, AccentColors.green],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(),
          Center(
            child: LottieBuilder.asset(
              animation,
              width: MediaQuery.sizeOf(context).width * 0.6,
            ),
          ),
          AppText.heading(text: 'Loading...', size: 16, color: context.white),
        ],
      ),
    );
  }
}
