import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/animations/animate_list.dart';
import '../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../core/ui/custom/containers/network_image.dart';
import '../../../core/ui/custom/containers/tag_container.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../bloc/recipe_detail_cubit/recipe_detail_cubit.dart';
import '../../data/models/recipe_model.dart';
import 'items/ingredient_item.dart';
import 'items/nutrition_container.dart';
import 'items/servings_container.dart';
import 'items/step_item.dart';
import 'loading_skeleton.dart/recipe_detail_page_skeleton.dart';

class RecipeDetailView extends StatefulWidget {
  final int? id;
  const RecipeDetailView({super.key, required this.id});

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  late final RecipeDetailCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<RecipeDetailCubit>();
    _cubit.fetchRecipe(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // RecipeModel recipe = kRecipes[0];

    return BlocListener<RecipeDetailCubit, RecipeDetailState>(
      listener: (context, state) {
        if (state.isError) {
          context.showSnackBarError(state.loadingResult.error!);
        }
      },
      child: BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
        builder: (context, state) {
          if (state.isLoading || state.loadingResult.value == null) {
            return const RecipeDetailPageSkeleton();
          }

          final RecipeDetailModel recipe = state.loadingResult.value!;

          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.3 + 25,
                    color: context.containerInverse,
                    child: recipe.image != null
                        ? MyNetworkImage(
                            url:
                                'https://sharedplatesapi-production.up.railway.app${recipe.image}',
                            radius: 0,
                          )
                        : MyNetworkImage(
                            url:
                                'https://thehappypear.ie/wp-content/uploads/2021/09/IMG_4780-scaled.jpg',
                            radius: 0,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
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
                        spacing: 24,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AppText.heading(
                                      text: recipe.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const MyIconButton(icon: MyIcons.heart_02),
                                ],
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  AppText.heading(
                                    text: 'R${recipe.cost.floor()}',
                                    size: 18,
                                  ),
                                  CircleAvatar(
                                    radius: 3,
                                    backgroundColor: context.textSecondary,
                                  ),
                                  Flexible(
                                    child: AppText.secondary(
                                      text: 'by ${recipe.createdBy}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          ServingsContainer(
                            serves: recipe.serves,
                            increment: () {},
                            decrement: () {},
                          ),

                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 33.64,
                              minHeight: 32.8,
                            ),
                            child: MySliverList.horizontal(
                              gap: 8,
                              itemBuilder: (context, index) => TagContainer(
                                title: recipe.tags[index],
                              ).listAnimate(index),
                              itemCount: recipe.tags.length,
                            ),
                          ),

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

                          if (recipe.ingredients.isNotEmpty)
                            Column(
                              spacing: 24,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText.heading(
                                  text: 'Ingredients',
                                  size: 16,
                                ),
                                MySliverList(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      IngredientItem(
                                        ingredient: recipe.ingredients[index],
                                      ).listAnimate(index),
                                  itemCount: recipe.ingredients.length,
                                ).animate().slideX(begin: -1, end: 0),
                              ],
                            ),

                          if (recipe.steps.isNotEmpty)
                            Column(
                              spacing: 24,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText.heading(
                                  text: 'Instructions',
                                  size: 16,
                                ),
                                MySliverList(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => StepItem(
                                    step: recipe.steps[index],
                                    totalCount: recipe.steps.length,
                                  ).listAnimate(index),
                                  itemCount: recipe.steps.length,
                                ).animate().slideX(begin: -1, end: 0),
                              ],
                            ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        MyIconButton(
                          icon: MyIcons.chevron_left,
                          onTap: () {
                            context.pop();
                          },
                        ),
                        const MyIconButton(icon: MyIcons.more_vertical),
                      ],
                    ),
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
