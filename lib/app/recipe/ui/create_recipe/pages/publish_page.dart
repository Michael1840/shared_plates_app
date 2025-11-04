import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/containers/tag_container.dart';
import '../../../../core/ui/layouts/page_container.dart';
import '../../../../core/utils/constants.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';

class PublishPage extends StatelessWidget {
  final CreateRecipeCubit cubit;
  final CreateRecipeState state;
  final bool canCreate;
  final void Function() changePage;

  const PublishPage({
    super.key,
    required this.cubit,
    required this.state,
    required this.changePage,
    required this.canCreate,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer.scrollable(
      child: Column(
        spacing: 24,
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
                  isActive: state.category == category,
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
                  isActive: state.diet == diet,
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
                  isActive: state.cuisine == cuisine,
                  onTap: () {
                    cubit.updateCuisine(cuisine);
                  },
                ),
            ],
          ),

          WideTextButton(
            text: 'Chef it up!',
            onTap: changePage,
            disabled: !canCreate || !state.canCreate,
          ),
        ],
      ),
    );
  }
}
