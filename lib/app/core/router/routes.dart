import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../auth/ui/auth_check.dart';
import '../../auth/ui/auth_page.dart';
import '../../home/ui/home_page.dart';
import '../../onboarding/ui/onboarding_page.dart';
import '../../recipe/bloc/recipe_detail_cubit/recipe_detail_cubit.dart';
import '../../recipe/data/repo/recipe_repo.dart';
import '../../recipe/ui/recipe_detail/recipe_detail_view.dart';
import '../../recipe/ui/recipe_page.dart';
import 'nav_shell.dart';

class Routes {
  // MAIN ROUTES
  static const String onboarding = 'onboarding';

  static const String authCheck = 'authentication-check';
  static const String auth = 'authentication';

  static const String dashboard = 'dashboard';
  static const String dashRecipeDetail = 'dash-recipe-detail';

  static const String recipes = 'recipes';
  static const String recipeDetail = 'recipe-detail';

  static const String discover = 'discover';

  static const String friends = 'friends';

  // SUB ROUTES
}

class NavigationRouter {
  static final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/authentication-check',
    navigatorKey: _key,
    redirect: (context, state) {
      final String? path = state.fullPath;

      final userState = context.read<UserBloc>().state;
      if (userState is UserUnauthenticated &&
          (path != Routes.authCheck &&
              path != Routes.onboarding &&
              path != Routes.auth)) {
        return Routes.auth;
      }
      return null;
    },

    routes: [
      GoRoute(
        path: '/authentication-check',
        name: Routes.authCheck,
        pageBuilder: (context, state) =>
            buildSlideTransition(const AuthCheck(), state.pageKey),
        routes: [],
      ),
      GoRoute(
        path: '/onboarding',
        name: Routes.onboarding,
        pageBuilder: (context, state) =>
            buildSlideTransition(const OnboardingPage(), state.pageKey),
        routes: [],
      ),
      GoRoute(
        path: '/authentication',
        name: Routes.auth,
        pageBuilder: (context, state) =>
            buildSlideTransition(const AuthPage(), state.pageKey),
        routes: [],
      ),

      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              debugPrint('Route: ${state.fullPath}');

              return NavigationShell(navigationShell: navigationShell);
            },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: Routes.dashboard,
                pageBuilder: (context, state) =>
                    buildSlideTransition(const HomePage(), state.pageKey),
                routes: [
                  GoRoute(
                    path: '${Routes.dashRecipeDetail}/:id',
                    name: Routes.dashRecipeDetail,
                    pageBuilder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');

                      return buildSlideTransition(
                        BlocProvider(
                          create: (context) => RecipeDetailCubit(
                            context.read<RecipesRepository>(),
                          ),
                          child: RecipeDetailView(id: id),
                        ),
                        state.pageKey,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recipes',
                name: Routes.recipes,
                pageBuilder: (context, state) =>
                    buildSlideTransition(const RecipesPage(), state.pageKey),
                routes: [
                  GoRoute(
                    path: '${Routes.recipeDetail}/:id',
                    name: Routes.recipeDetail,
                    pageBuilder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');

                      return buildSlideTransition(
                        BlocProvider(
                          create: (context) => RecipeDetailCubit(
                            context.read<RecipesRepository>(),
                          ),
                          child: RecipeDetailView(id: id),
                        ),
                        state.pageKey,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                name: Routes.discover,
                pageBuilder: (context, state) =>
                    buildSlideTransition(const RecipesPage(), state.pageKey),
                routes: [],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/friends',
                name: Routes.friends,
                pageBuilder: (context, state) =>
                    buildSlideTransition(const RecipesPage(), state.pageKey),
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
