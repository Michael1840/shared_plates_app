import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeInContainer extends StatelessWidget {
  final Widget child;
  const FadeInContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Animate(
      value: 0,
      effects: [
        const SlideEffect(
          begin: Offset(-1, 0),
          end: Offset(0, 0),
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 250),
        ),
        const FadeEffect(
          begin: 0,
          end: 1,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 400),
        ),
      ],
      child: child,
    );
  }
}
