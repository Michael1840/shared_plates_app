import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/ball_animation.dart';
import '../../core/ui/custom/animations/my_sliver_column.dart';
import '../../core/ui/custom/animations/my_sliver_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/create_recipe_button.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import 'filter_home_page.dart';
import 'items/full_width_card.dart';
import 'items/recipe_item.dart';
import 'skeleton/home_skeleton_page.dart';

enum _Filter { card, items }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Throttler _throttler = Throttler();

  _Filter _filter = _Filter.card;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    _throttler.throttle(
      duration: const Duration(seconds: 1),
      onThrottle: () {
        if (_scrollController.position.extentAfter < 150) {
          print('Fetching more trending recipes...');
          context.read<RecipeBloc>().add(RecipeFetchTrendingMore());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: const MainAppBar(),
      body: BlocListener<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state.isTrendingError) {
            context.showSnackBarError(
              state.trendingRecipesResult.error ?? 'An error occurred',
            );
          }

          if (state.isFriendsError) {
            context.showSnackBarError(
              state.friendsRecipesResult.error ?? 'An error occurred',
            );
          }
        },
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state.isFriendsLoading || state.isTrendingLoading) {
              return const HomeSkeletonPage();
            }

            final List<RecipeModel> friendsRecipes = state.friendsRecipes;
            final List<RecipeModel> trendingRecipes = state.trendingRecipes;

            return PageContainer(
              padding: const EdgeInsets.only(
                top: 0,
                left: 20,
                right: 20,
                bottom: 0,
              ),
              child: MySliverColumn(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollController: _scrollController,
                onRefresh: () async {
                  context.read<RecipeBloc>().add(RecipeFetchDashboardRecipes());
                },
                slivers: [
                  const CustomSliverAppBar(),

                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      String title;

                      if (state is UserAuthenticated) {
                        title = state.user.displayName;
                      } else {
                        title = 'User';
                      }

                      return CustomSliverTitle(
                        title: title,
                        subtitle: 'Welcome,',
                      );
                    },
                  ),

                  CustomSliverImageButton(
                    type: ButtonType.recipe1,
                    onTap: () {
                      context.goNamed(Routes.createRecipe);
                    },
                  ),

                  CustomPinnedSliverSearchContainer(
                    searchHint: 'What\'s cooking today?',
                    onSearchTap: () {
                      Methods.showBottomSheet(
                        context,
                        const FilterHomePage(),
                        isFull: true,
                      );
                    },
                  ),

                  // ViewAllRow(
                  //   title: 'Hot This Week',
                  //   onTap: () {},
                  // ).paddingBottom(20).toSliver(),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          _filter == _Filter.card
                              ? const MyIconButton.colored(
                                  icon: Icons.view_agenda_outlined,
                                )
                              : MyIconButton(
                                  icon: Icons.view_agenda_outlined,
                                  onTap: () {
                                    setState(() {
                                      _filter = _Filter.card;
                                    });
                                  },
                                ),
                          _filter == _Filter.items
                              ? const MyIconButton.colored(
                                  icon: MyIcons.menu_alt_04,
                                )
                              : MyIconButton(
                                  icon: MyIcons.menu_alt_04,
                                  onTap: () {
                                    setState(() {
                                      _filter = _Filter.items;
                                    });
                                  },
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          const AppText.secondary(text: 'Sort: ', size: 12),
                          AppText.heading(
                            text: 'Default ',
                            size: 12,
                            color: context.textSecondary,
                          ),
                          Icon(
                            MyIcons.arrow_down_up,
                            color: context.textSecondary,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ).paddingBottom(20).toSliver(),

                  CustomSliverList(
                    emptyText: 'No recipes found',
                    itemBuilder: (context, index) => _filter == _Filter.card
                        ? FullWidthCard(
                                recipe: trendingRecipes[index],
                                onLike: () {
                                  context.read<RecipeBloc>().add(
                                    LikeRecipe(
                                      RecipeType.trending,
                                      trendingRecipes[index].id,
                                    ),
                                  );
                                },
                              )
                              .onTap(() {
                                context.pushNamed(
                                  Routes.dashRecipeDetail,
                                  pathParameters: {
                                    'id': trendingRecipes[index].id.toString(),
                                  },
                                );
                              })
                              .listAnimate(index)
                        : RecipeItem(recipe: trendingRecipes[index])
                              .onTap(() {
                                context.pushNamed(
                                  Routes.dashRecipeDetail,
                                  pathParameters: {
                                    'id': trendingRecipes[index].id.toString(),
                                  },
                                );
                              })
                              .listAnimate(index),
                    itemCount: trendingRecipes.length,
                    gap: 20,
                  ),

                  const SizedBox(height: 20).toSliver(),

                  if (state.isMoreLoading)
                    const BallAnimation(
                      ballSize: 15,
                    ).paddingSymmetric(vertical: 32).toSliver(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
