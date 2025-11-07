import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/containers/tag_container.dart';
import '../../../../core/ui/layouts/page_container.dart';
import '../../../../core/utils/constants.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../../bloc/recipe_bloc/recipe_bloc.dart';

class PublishPage extends StatelessWidget {
  final CreateRecipeCubit cubit;
  final CreateRecipeState state;
  final RecipeState recipeState;
  final bool canCreate;
  final void Function() create;

  const PublishPage({
    super.key,
    required this.cubit,
    required this.state,
    required this.recipeState,
    required this.create,
    required this.canCreate,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer.scrollable(
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.primary(text: 'Category', size: 16),
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 12,
            spacing: 12,
            alignment: WrapAlignment.start,
            children: [
              for (final category in kCategories)
                TagContainer(
                  title: category,
                  isActive: state.category.contains(category),
                  onTap: () {
                    cubit.updateCategory(category);
                  },
                ),
            ],
          ),
          const AppText.primary(text: 'Diet', size: 16),
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 12,
            spacing: 12,
            alignment: WrapAlignment.start,
            children: [
              for (final diet in kDiets)
                TagContainer(
                  title: diet,
                  isActive: state.diet.contains(diet),
                  onTap: () {
                    cubit.updateDiet(diet);
                  },
                ),
            ],
          ),
          const AppText.primary(text: 'Cuisine', size: 16),
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 12,
            spacing: 12,
            alignment: WrapAlignment.start,
            children: [
              for (final cuisine in kCuisines)
                TagContainer(
                  title: cuisine,
                  isActive: state.cuisine.contains(cuisine),
                  onTap: () {
                    cubit.updateCuisine(cuisine);
                  },
                ),
            ],
          ),

          WideTextButton(
            text: 'Chef it up!',
            onTap: create,
            disabled: !canCreate || !state.canCreate,
            isLoading: recipeState.isUserLoading,
          ),
        ],
      ),
    );
  }
}
