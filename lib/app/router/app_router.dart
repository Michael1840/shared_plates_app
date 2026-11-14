import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/app_shell.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/app/router/session_listenable.dart';
import 'package:shared_plates_app/app/router/transitions.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/email_sign_in_page.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/splash_page.dart';
import 'package:shared_plates_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:shared_plates_app/features/create/presentation/pages/create_start_page.dart';
import 'package:shared_plates_app/features/discover/presentation/pages/discover_page.dart';
import 'package:shared_plates_app/features/friends/presentation/pages/friends_page.dart';
import 'package:shared_plates_app/features/gallery/presentation/pages/widget_gallery_page.dart';
import 'package:shared_plates_app/features/home/presentation/pages/home_page.dart';
import 'package:shared_plates_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:shared_plates_app/features/onboarding/presentation/pages/onboarding_friends_page.dart';
import 'package:shared_plates_app/features/onboarding/presentation/pages/onboarding_taste_page.dart';
import 'package:shared_plates_app/features/onboarding/presentation/pages/onboarding_you_page.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/recipes/presentation/pages/recipes_page.dart';

String? sessionRedirect(SessionStatus status, String location) {
  final inAuth = location == Routes.welcome || location == Routes.signIn;
  final inOnboarding = location.startsWith(Routes.onboarding);
  final isSplash = location == Routes.splash;
  if (location == Routes.gallery) return null;
  return switch (status) {
    SessionStatus.unknown => isSplash ? null : Routes.splash,
    SessionStatus.signedOut => inAuth ? null : Routes.welcome,
    SessionStatus.guest =>
      isSplash || inOnboarding || location == Routes.signIn
          ? Routes.home
          : null,
    SessionStatus.onboarding => inOnboarding ? null : Routes.onboardingYou,
    SessionStatus.signedIn =>
      isSplash || inAuth || inOnboarding ? Routes.home : null,
  };
}

GoRouter buildRouter(SessionCubit session) {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final refresh = StreamListenable(session.stream);
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) =>
        sessionRedirect(session.state.status, state.matchedLocation),
    routes: [
      GoRoute(
        path: Routes.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) =>
            SpPages.fade(state, const SplashPage()),
      ),
      GoRoute(
        path: Routes.welcome,
        name: RouteNames.welcome,
        pageBuilder: (context, state) =>
            SpPages.fade(state, const WelcomePage()),
      ),
      GoRoute(
        path: Routes.signIn,
        name: RouteNames.signIn,
        pageBuilder: (context, state) =>
            SpPages.push(state, const EmailSignInPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) {
            final cubit = OnboardingCubit(
              profiles: sl<ProfileRepository>(),
              userId: session.state.userId ?? '',
              countryCode: PlatformDispatcher.instance.locale.countryCode,
            );
            unawaited(cubit.load());
            return cubit;
          },
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.onboardingYou,
            name: RouteNames.onboardingYou,
            pageBuilder: (context, state) =>
                SpPages.fade(state, const OnboardingYouPage()),
          ),
          GoRoute(
            path: Routes.onboardingTaste,
            name: RouteNames.onboardingTaste,
            pageBuilder: (context, state) =>
                SpPages.push(state, const OnboardingTastePage()),
          ),
          GoRoute(
            path: Routes.onboardingFriends,
            name: RouteNames.onboardingFriends,
            pageBuilder: (context, state) =>
                SpPages.push(state, const OnboardingFriendsPage()),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                name: RouteNames.home,
                pageBuilder: (context, state) =>
                    SpPages.fade(state, const HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.discover,
                name: RouteNames.discover,
                pageBuilder: (context, state) =>
                    SpPages.fade(state, const DiscoverPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.recipes,
                name: RouteNames.recipes,
                pageBuilder: (context, state) =>
                    SpPages.fade(state, const RecipesPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.friends,
                name: RouteNames.friends,
                pageBuilder: (context, state) =>
                    SpPages.fade(state, const FriendsPage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: Routes.create,
        name: RouteNames.create,
        pageBuilder: (context, state) =>
            SpPages.sheet(state, const CreateStartPage()),
      ),
      if (Env.isDev)
        GoRoute(
          parentNavigatorKey: rootKey,
          path: Routes.gallery,
          name: RouteNames.gallery,
          pageBuilder: (context, state) =>
              SpPages.push(state, const WidgetGalleryPage()),
        ),
    ],
  );
}
