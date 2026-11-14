import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/app_shell.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/app/router/transitions.dart';
import 'package:shared_plates_app/features/create/presentation/pages/create_start_page.dart';
import 'package:shared_plates_app/features/discover/presentation/pages/discover_page.dart';
import 'package:shared_plates_app/features/friends/presentation/pages/friends_page.dart';
import 'package:shared_plates_app/features/gallery/presentation/pages/widget_gallery_page.dart';
import 'package:shared_plates_app/features/home/presentation/pages/home_page.dart';
import 'package:shared_plates_app/features/recipes/presentation/pages/recipes_page.dart';

GoRouter buildRouter() {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: Routes.home,
    routes: [
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
