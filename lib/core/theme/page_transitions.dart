import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReduceMotionTransitions extends PageTransitionsBuilder {
  const ReduceMotionTransitions(this._inner);

  final PageTransitionsBuilder _inner;

  static const theme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ReduceMotionTransitions(
        PredictiveBackPageTransitionsBuilder(),
      ),
      TargetPlatform.iOS: ReduceMotionTransitions(
        CupertinoPageTransitionsBuilder(),
      ),
      TargetPlatform.macOS: ReduceMotionTransitions(
        CupertinoPageTransitionsBuilder(),
      ),
      TargetPlatform.windows: ReduceMotionTransitions(
        ZoomPageTransitionsBuilder(),
      ),
      TargetPlatform.linux: ReduceMotionTransitions(
        ZoomPageTransitionsBuilder(),
      ),
    },
  );

  @override
  Duration get transitionDuration => _inner.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _inner.reverseTransitionDuration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return _inner.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
