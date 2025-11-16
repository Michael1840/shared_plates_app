import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/repo/recipe_repo.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecipeBloc(context.read<RecipesRepository>()),
        ),
      ],
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUnauthenticated) {
            NavigationRouter.router.refresh();
          }

          if (state is UserAuthenticated && state.message != null) {
            context.showSnackBarMessage(state.message!);
          }

          if (state is UserAuthenticated && state.error != null) {
            context.showSnackBarError(state.error!);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                selectedItemColor: context.primary,
                // fixedColor: context.primary,
                // showUnselectedLabels: false,
                selectedFontSize: 8,
                unselectedFontSize: 8,
                iconSize: 22,
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: true,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: context.textSecondary,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: widget.navigationShell.goBranch,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(MyIcons.house_02),
                    label: 'Home',
                    activeIcon: Icon(MyIcons.house_02, color: context.primary),
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(MyIcons.compass, color: context.primary),
                    icon: const Icon(MyIcons.compass),
                    label: 'Discover',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      MyIcons.add_plus_circle,
                      color: context.primary,
                    ),
                    icon: const Icon(MyIcons.add_plus_circle),
                    label: 'Add',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(MyIcons.book, color: context.primary),
                    icon: const Icon(MyIcons.book),
                    label: 'Recipes',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      MyIcons.users_group,
                      color: context.primary,
                    ),
                    icon: const Icon(MyIcons.users_group),
                    label: 'Friends',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
