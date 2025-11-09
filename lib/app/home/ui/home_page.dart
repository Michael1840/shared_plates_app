import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/animations/my_sliver_column.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/create_recipe_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/containers/view_all_row.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';
import 'items/recipe_item.dart';
import 'items/trending_recipe_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: const MainAppBar(),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.isFriendsLoading || state.isTrendingLoading) {
            return const RecipesPageSkeleton();
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
              onRefresh: () async {
                context.read<RecipeBloc>().add(RecipeFetchDashboardRecipes());
              },
              slivers: [
                const CustomSliverAppBar(),

                const CustomSliverTitle(
                  title: 'Michael Kiggen',
                  subtitle: 'Welcome,',
                ),

                CustomSliverImageButton(
                  type: ButtonType.recipe1,
                  onTap: () {
                    context.goNamed(Routes.createRecipe);
                  },
                ),

                const CustomPinnedSliverSearch(
                  searchHint: 'What\'s cooking today?',
                ),

                ViewAllRow(title: 'Trending Recipes', onTap: () {}).toSliver(),
                SizedBox(
                      height: 230,
                      child: MySliverList.horizontal(
                        emptyText: 'No recipes found',
                        itemBuilder: (context, index) =>
                            TrendingRecipeItem(recipe: trendingRecipes[index])
                                .onTap(() {
                                  context.pushNamed(
                                    Routes.dashRecipeDetail,
                                    pathParameters: {
                                      'id': trendingRecipes[index].id
                                          .toString(),
                                    },
                                  );
                                })
                                .listAnimateHorizontal(index),
                        itemCount: trendingRecipes.length,
                      ),
                    )
                    .paddingSymmetric(vertical: 20)
                    .animate()
                    .slideX(
                      begin: 1,
                      end: 0,
                      delay: 250.ms,
                      // alignment: Alignment.centerLeft,
                    )
                    .toSliver(),
                ViewAllRow(
                  title: 'Friends Recipes',
                  onTap: () {},
                ).paddingBottom(20).toSliver(),
                MySliverList(
                  emptyText: 'No recipes found',
                  itemBuilder: (context, index) =>
                      RecipeItem(recipe: friendsRecipes[index])
                          .onTap(() {
                            context.pushNamed(
                              Routes.dashRecipeDetail,
                              pathParameters: {
                                'id': friendsRecipes[index].id.toString(),
                              },
                            );
                          })
                          .paddingBottom(
                            (index + 1) == friendsRecipes.length ? 20 : 0,
                          )
                          .listAnimate(index),
                  itemCount: friendsRecipes.length,
                ).paddingBottom(20).toSliver(),
              ],
            ),
          );
        },
      ),
    );
  }
}
