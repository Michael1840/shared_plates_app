import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/animations/animate_list.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/ui/layouts/page_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/methods.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../../data/models/ingredient_model.dart';
import '../items/create_ingredient_item.dart';
import '../items/create_ingredient_sheet.dart';

class IngredientsPage extends StatelessWidget {
  final CreateRecipeCubit cubit;
  final CreateRecipeState state;
  final void Function() changePage;

  const IngredientsPage({
    super.key,
    required this.cubit,
    required this.state,
    required this.changePage,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer.scrollable(
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText.primary(text: 'Ingredients', size: 16),
              ),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: context.green,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Icon(MyIcons.add_plus, color: context.white, size: 16),
                ),
              ).onTap(() {
                Methods.showBottomSheet(
                  context,
                  CreateIngredientSheet(
                    cubit: cubit,
                    onConfirm: (IngredientModel i) {
                      cubit.updateIngredients(i);
                    },
                    currentIndex: state.ingredients.length,
                  ),
                );
              }),
            ],
          ),
          MySliverList(
            gap: 12,
            emptyText: 'No ingredients, add one!',
            shrinkWrap: true,
            itemBuilder: (context, index) => CreateIngredientItem(
              ingredient: state.ingredients[index],
              onDelete: (i) {
                cubit.deleteIngredient(i);
              },
            ).listAnimate(index),
            itemCount: state.ingredients.length,
          ),
          WideTextButton(
            text: 'Next',
            onTap: changePage,
            disabled: state.ingredients.isEmpty,
          ),
        ],
      ),
    );
  }
}
