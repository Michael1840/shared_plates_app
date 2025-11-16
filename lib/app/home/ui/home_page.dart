import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../core/router/routes.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/animations/ball_animation.dart';
import '../../core/ui/custom/animations/my_sliver_column.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/create_recipe_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/containers/view_all_row.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import 'filter_home_page.dart';
import 'items/full_width_card.dart';
import 'skeleton/home_skeleton_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Throttler _throttler = Throttler();

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

                  ViewAllRow(
                    title: 'Hot This Week',
                    onTap: () {},
                  ).paddingBottom(20).toSliver(),

                  MySliverList(
                    scrollable: false,
                    emptyText: 'No recipes found',
                    gap: 40,

                    itemBuilder: (context, index) =>
                        FullWidthCard(
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
                            .listAnimate(index),
                    itemCount: trendingRecipes.length,
                  ),

                  if (state.isMoreLoading)
                    const BallAnimation(
                      ballSize: 15,
                    ).paddingSymmetric(vertical: 32).toSliver(),

                  // ViewAllRow(
                  //   title: 'Friends Recipes',
                  //   onTap: () {},
                  // ).paddingBottom(20).toSliver(),

                  // MySliverList(
                  //   emptyText: 'No recipes found',
                  //   itemBuilder: (context, index) =>
                  //       RecipeItem(recipe: friendsRecipes[index])
                  //           .onTap(() {
                  //             context.pushNamed(
                  //               Routes.dashRecipeDetail,
                  //               pathParameters: {
                  //                 'id': friendsRecipes[index].id.toString(),
                  //               },
                  //             );
                  //           })
                  //           .paddingBottom(
                  //             (index + 1) == friendsRecipes.length ? 20 : 0,
                  //           )
                  //           .listAnimate(index),
                  //   itemCount: friendsRecipes.length,
                  // ).paddingBottom(20).toSliver(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
