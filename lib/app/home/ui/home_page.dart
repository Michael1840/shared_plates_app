import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/main_app_bar.dart';
import '../../core/ui/custom/containers/view_all_row.dart';
import '../../core/ui/custom/fields/search_field.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import 'items/recipe_item.dart';
import 'items/trending_recipe_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MainAppBar(),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.isFriendsLoading || state.isTrendingLoading) {
            return SizedBox();
          }

          if (state.friendsRecipesResult.value == null ||
              state.trendingRecipesResult.value == null) {
            return SizedBox();
          }

          int friendsLength = 5;
          int trendingLength = 5;

          final List<RecipeModel> friendsRecipes =
              state.friendsRecipesResult.value!;
          final List<RecipeModel> trendingRecipes =
              state.trendingRecipesResult.value!;

          if (friendsRecipes.length < friendsLength) {
            friendsLength = friendsRecipes.length;
          }

          if (trendingRecipes.length < trendingLength) {
            trendingLength = trendingRecipes.length;
          }

          return PageContainer(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.primary(text: 'Welcome,'),
                        AppText.heading(text: 'Michael Kiggen'),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: SearchField(hint: 'What\'s cooking today?'),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViewAllRow(title: 'Trending Recipes', onTap: () {}),
                    SizedBox(
                      height: 213,
                      child: MySliverList.horizontal(
                        itemBuilder: (context, index) =>
                            TrendingRecipeItem(recipe: trendingRecipes[index])
                                .onTap(() {
                                  context.pushNamed(Routes.recipeDetail);
                                })
                                .listAnimate(index),
                        itemCount: trendingLength,
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewAllRow(title: 'Friends Recents', onTap: () {}),
                      Expanded(
                        child: MySliverList(
                          itemBuilder: (context, index) =>
                              RecipeItem(recipe: friendsRecipes[index])
                                  .onTap(() {
                                    context.pushNamed(Routes.recipeDetail);
                                  })
                                  .listAnimate(index),
                          itemCount: friendsLength,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ).containerAnimate(0, 250.ms),
    );
  }
}
