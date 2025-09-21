import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/create_recipe_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../home/ui/items/recipe_item.dart';
import '../bloc/recipe_bloc/recipe_bloc.dart';
import '../data/models/recipe_model.dart';
import 'loading_skeleton/recipes_page_skeleton.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
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

                const CustomSliverTitle(title: 'Recipe Book', subtitle: 'Your'),

                CustomSliverImageButton(type: ButtonType.recipe2, onTap: () {}),

                const CustomPinnedSliverSearch(hasIconButton: true),
              ],
              itemBuilder: (context, index) =>
                  RecipeItem(recipe: recipes[index])
                      .onTap(() {
                        context.goNamed(
                          Routes.recipeDetail,
                          pathParameters: {'id': recipes[index].id.toString()},
                        );
                      })
                      .paddingBottom((index + 1) == recipes.length ? 20 : 0)
                      .listAnimate(index),
              itemCount: recipes.length,
            ),
          );
        },
      ),
    );
  }
}
