import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/containers/view_all_row.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../home/ui/items/trending_recipe_item.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();

    context.read<RecipeBloc>().add(RecipeFetchUserRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MainAppBar(),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.isUserLoading) {
            return const RecipesPageSkeleton();
          }

          if (state.userRecipesResult.value == null) {
            return const RecipesPageSkeleton();
          }

          int length = 5;
          final List<RecipeModel> recipes = state.userRecipesResult.value!;

          if (recipes.length < length) {
            length = recipes.length;
          }

          return PageContainer(
            padding: const EdgeInsets.only(
              // top: 20,
              top: 0,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: MySliverList(
              onRefresh: () async {
                context.read<RecipeBloc>().add(RecipeFetchUserRecipes());
              },
              slivers: [
                const CustomSliverAppBar(),

                const CustomSliverTitle(
                  title: 'Perfect Flavour',
                  subtitle: 'Your',
                ),

                const CustomPinnedSliverSearch(
                  searchHint: 'What are you craving?',
                ),
                ViewAllRow(title: 'Hot This Week', onTap: () {}).toSliver(),
                SizedBox(
                      height: 213,
                      child: MySliverList.horizontal(
                        itemBuilder: (context, index) =>
                            TrendingRecipeItem(recipe: recipes[index])
                                .onTap(() {
                                  context.pushNamed(
                                    Routes.dashRecipeDetail,
                                    pathParameters: {
                                      'id': recipes[index].id.toString(),
                                    },
                                  );
                                })
                                .listAnimateHorizontal(index),
                        itemCount: length,
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
                ViewAllRow(title: 'Under R100', onTap: () {}).toSliver(),
                SizedBox(
                      height: 213,
                      child: MySliverList.horizontal(
                        itemBuilder: (context, index) =>
                            TrendingRecipeItem(recipe: recipes[index])
                                .onTap(() {
                                  context.pushNamed(
                                    Routes.dashRecipeDetail,
                                    pathParameters: {
                                      'id': recipes[index].id.toString(),
                                    },
                                  );
                                })
                                .listAnimateHorizontal(index),
                        itemCount: length,
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
              ],
              itemBuilder: null,
              itemCount: 0,
            ),
          );
        },
      ),
    );
  }
}
