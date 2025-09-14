import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/main_app_bar.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/default_container.dart';
import '../../core/ui/custom/fields/search_field.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../home/ui/items/recipe_item.dart';
import '../bloc/recipe_bloc/recipe_bloc.dart';
import '../data/models/recipe_model.dart';
import 'loading_skeleton/recipes_page_skeleton.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
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
              top: 20,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.primary(text: 'Your'),
                        AppText.heading(text: 'Recipe Book'),
                      ],
                    ),
                    const Row(
                      spacing: 10,
                      children: [
                        Expanded(child: SearchField()),
                        MyIconButton(icon: MyIcons.heart_02, padding: 14),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 33.64,
                        minHeight: 32.8,
                      ),
                      child: MySliverList.horizontal(
                        gap: 10,
                        itemBuilder: (context, index) => DefaultContainer(
                          color: index == 0 ? context.green : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: AppText.secondary(
                            text: 'Test',
                            color: index == 0 ? context.white : null,
                            weight: index == 0 ? Weights.bold : Weights.reg,
                          ),
                        ),
                        itemCount: 5,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: MySliverList(
                    itemBuilder: (context, index) =>
                        RecipeItem(recipe: recipes[index])
                            .onTap(() {
                              context.pushNamed(Routes.recipeDetail, extra: 11);
                            })
                            .listAnimate(index),
                    itemCount: length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
