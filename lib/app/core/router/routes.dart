import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/ui/home_page.dart';
import 'nav_shell.dart';

class Routes {
  // MAIN ROUTES
  static const String login = '/login';

  static const String dashboard = '/';

  static const String recipes = '/recipes';

  static const String discover = '/discover';

  static const String friends = '/friends';

  // SUB ROUTES
}

class NavigationRouter {
  static final key = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.dashboard,
    navigatorKey: key,
    routes: [
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              // Return the widget that implements the custom shell (in this case
              // using a BottomNavigationBar). The StatefulNavigationShell is passed
              // to be able access the state of the shell and to navigate to other
              // branches in a stateful way.
              return NavigationShell(navigationShell: navigationShell);
            },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.dashboard,
                name: Routes.dashboard,
                pageBuilder: (context, state) =>
                    buildSlideTransition(const HomePage(), state.pageKey),
                routes: [],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // PAGE TRANSITIONS

  // Fade
  static CustomTransitionPage buildFadeTransition(
    Widget child,
    LocalKey? key,
  ) => CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );

  // Slide
  static CustomTransitionPage buildSlideTransition(
    Widget child,
    LocalKey? key,
  ) => CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
