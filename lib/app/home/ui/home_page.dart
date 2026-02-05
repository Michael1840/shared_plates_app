import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/ball_animation.dart';
import '../../core/ui/custom/animations/my_sliver_column.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/create_recipe_button.dart';
import '../../core/ui/custom/buttons/image_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/containers/view_all_row.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../search/ui/filter_page.dart';
import 'items/dashboard_button.dart';
import 'skeleton/home_skeleton_page.dart';

enum _Filter { card, items }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Throttler _throttler = Throttler();

  final _Filter _filter = _Filter.card;

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
            final List<RecipeModel> recipes = state.userRecipes;

            final recipe = trendingRecipes[1];

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

                  CustomSliverImageButton(
                    type: ButtonType.recipe1,
                    onTap: () {
                      context.goNamed(Routes.createRecipe);
                    },
                  ),

                  ViewAllRow(
                    title: 'Featured Today',
                    onTap: () {},
                  ).paddingBottom(20).toSliver(),

                  ImageButton(
                    onTap: () {
                      context.pushNamed(
                        Routes.recipeDetail,
                        pathParameters: {'id': recipe.id.toString()},
                      );
                    },
                    customAsset: recipe.image,
                    child: Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AccentColors.star.withValues(
                            alpha: 0.15,
                          ),
                          child: const Icon(
                            Icons.emoji_events_outlined,
                            color: AccentColors.star,
                            size: 22,
                          ),
                        ),
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.primary(
                              text: recipe.title,
                              size: 18,
                              weight: Weights.semiBold,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: context.textPrimary.withValues(
                                    alpha: 0.8,
                                  ),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                AppText.primary(
                                  text: '324 ',
                                  size: 12,
                                  color: context.textPrimary,
                                ),
                                AppText.secondary(
                                  text: 'people viewed today',
                                  size: 12,
                                  color: context.textPrimary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).paddingBottom(20).toSliver(),

                  IntrinsicHeight(
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: DashboardButton(
                            title: 'Discover Recipes',
                            subtitle: 'Find your perfect meal',
                            icon: MyIcons.compass,
                            iconColor: context.green,
                            onTap: () {
                              context.goNamed(Routes.discover);
                            },
                          ),
                        ),
                        Expanded(
                          child: DashboardButton(
                            title: 'Meal Planner',
                            subtitle: 'Organise your menu',
                            icon: MyIcons.calendar_check,
                            iconColor: context.primary,
                            onTap: () {
                              context.goNamed(Routes.menuPlanner);
                            },
                          ),
                        ),
                      ],
                    ),
                  ).paddingBottom(20).toSliver(),

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
