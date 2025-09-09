import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme.dart';
import '../ui/custom/icons/my_icons.dart';
import '../utils/extensions.dart';
import 'routes.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class NavigationShell extends StatefulWidget {
  /// Constructs an [NavigationShell].
  const NavigationShell({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('NavigationShell'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: context.container,
          boxShadow: [Shadows.dark],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            backgroundColor: context.container,
            fixedColor: context.primary,
            showUnselectedLabels: true,
            selectedFontSize: 8,
            unselectedFontSize: 8,
            iconSize: 18,
            elevation: 0,
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: context.textSecondary,
            currentIndex: widget.navigationShell.currentIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  context.goNamed(Routes.dashboard);
                  break;
                case 1:
                  context.goNamed(Routes.recipes);
                  break;
                case 2:
                  context.goNamed(Routes.discover);
                  break;
                case 3:
                  context.goNamed(Routes.friends);
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(MyIcons.house_02).paddingBottom(4),
                label: 'Home',
                activeIcon: Icon(
                  MyIcons.house_02,
                  color: context.primary,
                ).paddingBottom(4),
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  MyIcons.book,
                  color: context.primary,
                ).paddingBottom(4),
                icon: const Icon(MyIcons.book).paddingBottom(4),
                label: 'Recipes',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  MyIcons.compass,
                  color: context.primary,
                ).paddingBottom(4),
                icon: const Icon(MyIcons.compass).paddingBottom(4),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  MyIcons.users_group,
                  color: context.primary,
                ).paddingBottom(4),
                icon: const Icon(MyIcons.users_group).paddingBottom(4),
                label: 'Friends',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
