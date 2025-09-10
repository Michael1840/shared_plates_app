import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/animations/animate_list.dart';
import '../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import 'items/ingredient_item.dart';
import 'items/nutrition_container.dart';

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: context.textSecondary,
              height: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              height: MediaQuery.sizeOf(context).height * 0.6,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: context.background,
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.heading(text: 'Recipe Name '),
                        MyIconButton(icon: MyIcons.heart_02),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        const AppText.heading(text: 'R250', size: 18),
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: context.textSecondary,
                        ),
                        const AppText.secondary(text: 'by @michael_k'),
                      ],
                    ),
                    const SizedBox(),
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        radius: const Radius.circular(100),
                        color: context.green,
                        dashPattern: [8, 8],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText.primary(
                              text: 'Servings',
                              color: context.green,
                            ),
                          ),
                          Row(
                            spacing: 16,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: context.green,
                                child: Icon(
                                  MyIcons.remove_minus,
                                  color: context.white,
                                  size: 18,
                                ),
                              ),
                              AppText.primary(text: '2', color: context.green),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: context.green,
                                child: Icon(
                                  MyIcons.add_plus,
                                  color: context.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(),
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
                    const SizedBox(),
                    const AppText.heading(text: 'Nutrition Facts', size: 18),
                    IntrinsicHeight(
                      child: Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NutritionContainer(
                            value: 0.8,
                            label: 'Protein',
                            amount: '25g',
                            color: context.green,
                          ),
                          NutritionContainer(
                            value: 0.2,
                            label: 'Fat',
                            amount: '90g',
                            color: context.primary,
                          ),
                          const NutritionContainer(
                            value: 0.4,
                            label: 'Protein',
                            amount: '25g',
                            color: AccentColors.purple,
                          ),
                          const NutritionContainer(
                            value: 0.8,
                            label: 'Calories',
                            amount: '256kcal',
                            color: AccentColors.red,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(),
                    DefaultContainer(
                      radius: 30,
                      child: Column(
                        spacing: 20,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DefaultContainer(
                                  radius: 100,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  color: context.background,
                                  child: const Center(
                                    child: AppText.primary(
                                      text: 'Ingredients (5)',
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: DefaultContainer(
                                  radius: 100,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  child: Center(
                                    child: AppText.primary(text: 'Steps (8)'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const IngredientItem(
                            name: 'Brocolli',
                            amount: '50g',
                            isChecked: true,
                          ),
                          const IngredientItem(
                            name: 'Milk',
                            amount: '250ml',
                            isChecked: true,
                          ),
                          const IngredientItem(
                            name: 'Spinach',
                            amount: '200g',
                            isChecked: false,
                          ),
                          const IngredientItem(
                            name: 'Pepper',
                            amount: '10g',
                            isChecked: false,
                          ),
                          const IngredientItem(
                            name: 'Flour',
                            amount: '250g',
                            isChecked: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              toolbarHeight: 75,
              leadingWidth: 100,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              leading: Row(
                children: [
                  const SizedBox(width: 20),
                  MyIconButton(
                    icon: MyIcons.chevron_left,
                    onTap: () {
                      context.pop();
                    },
                  ),
                ],
              ),
              actions: [
                const MyIconButton(icon: MyIcons.more_vertical),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
