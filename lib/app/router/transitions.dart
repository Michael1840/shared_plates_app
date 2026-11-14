import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/core/theme/motion.dart';

abstract final class SpPages {
  static Page<void> push(GoRouterState state, Widget child) =>
      MaterialPage<void>(key: state.pageKey, name: state.name, child: child);

  static Page<void> sheet(GoRouterState state, Widget child) =>
      CustomTransitionPage<void>(
        key: state.pageKey,
        name: state.name,
        transitionDuration: Motion.large,
        child: child,
        transitionsBuilder: (context, animation, secondary, child) {
          if (MediaQuery.disableAnimationsOf(context)) return child;
          final curved = CurvedAnimation(
            parent: animation,
            curve: Motion.arrive,
            reverseCurve: Motion.leave,
          );
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
      );

  static Page<void> fade(GoRouterState state, Widget child) =>
      CustomTransitionPage<void>(
        key: state.pageKey,
        name: state.name,
        child: child,
        transitionsBuilder: (context, animation, secondary, child) =>
            MediaQuery.disableAnimationsOf(context)
            ? child
            : FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Motion.arrive,
                ),
                child: child,
              ),
      );
}
