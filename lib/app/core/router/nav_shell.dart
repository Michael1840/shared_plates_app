import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/repo/recipe_repo.dart';
import '../theme/theme.dart';
import '../ui/custom/buttons/my_icon_button.dart';
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
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 16),
            child: MyIconButton.colored(
              icon: MyIcons.add_plus,
              padding: 12,
              color: context.green,
              iconSize: 28,
              onTap: () {
                widget.navigationShell.goBranch(2);
              },
              hasGlow: true,
            ),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
              // child: BottomNavigationBar(
              //   backgroundColor: context.container,
              //   selectedItemColor: context.primary,
              //   // fixedColor: context.primary,
              //   // showUnselectedLabels: false,
              //   selectedFontSize: 8,
              //   unselectedFontSize: 8,
              //   iconSize: 22,
              //   elevation: 0,
              //   showSelectedLabels: false,
              //   showUnselectedLabels: false,
              //   enableFeedback: false,
              //   type: BottomNavigationBarType.fixed,
              //   unselectedItemColor: context.textSecondary,
              //   currentIndex: widget.navigationShell.currentIndex,
              //   onTap: (int i) {
              //     if (i == 2) {
              //       return;
              //     }

              //     widget.navigationShell.goBranch(i);
              //   },
              //   items: [
              //     BottomNavigationBarItem(
              //       icon: const Icon(MyIcons.house_02),
              //       label: 'Home',
              //       activeIcon: Icon(MyIcons.house_02, color: context.primary),
              //     ),
              //     BottomNavigationBarItem(
              //       activeIcon: Icon(MyIcons.compass, color: context.primary),
              //       icon: const Icon(MyIcons.compass),
              //       label: 'Discover',
              //     ),
              //     const BottomNavigationBarItem(
              //       activeIcon: Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Icon(
              //             MyIcons.add_plus_circle,
              //             color: Colors.transparent,
              //           ),
              //         ],
              //       ),
              //       icon: Icon(
              //         MyIcons.add_plus_circle,
              //         color: Colors.transparent,
              //       ),

              //       label: 'Add',
              //     ),
              //     BottomNavigationBarItem(
              //       activeIcon: Icon(MyIcons.book, color: context.primary),
              //       icon: const Icon(MyIcons.book),
              //       label: 'Recipes',
              //     ),
              //     BottomNavigationBarItem(
              //       activeIcon: Icon(
              //         MyIcons.users_group,
              //         color: context.primary,
              //       ),
              //       icon: const Icon(MyIcons.users_group),
              //       label: 'Friends',
              //     ),
              //   ],
              // ),
              child: BottomAppBar(
                // currentIndex:
                // onTap: (i) => widget.navigationShell.goBranch(i),
                color: context.container,
                elevation: 0,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _item(
                      context: context,
                      icon: MyIcons.house_02,
                      index: 0,
                      currentIndex: widget.navigationShell.currentIndex,
                      onTap: (i) => widget.navigationShell.goBranch(i),
                    ),
                    const Spacer(),
                    _item(
                      context: context,
                      icon: MyIcons.compass,
                      index: 1,
                      currentIndex: widget.navigationShell.currentIndex,
                      onTap: (i) => widget.navigationShell.goBranch(i),
                    ),

                    const Spacer(flex: 2), // space for FAB

                    _item(
                      context: context,
                      icon: MyIcons.book,
                      index: 3,
                      currentIndex: widget.navigationShell.currentIndex,
                      onTap: (i) => widget.navigationShell.goBranch(i),
                    ),
                    const Spacer(),
                    _item(
                      context: context,
                      icon: MyIcons.users_group,
                      index: 4,
                      currentIndex: widget.navigationShell.currentIndex,
                      onTap: (i) => widget.navigationShell.goBranch(i),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item({
    required BuildContext context,
    required IconData icon,
    required int currentIndex,
    required int index,
    required void Function(int i) onTap,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? context.primary : context.textSecondary;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}
