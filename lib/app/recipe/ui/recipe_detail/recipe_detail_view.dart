import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/animations/animate_list.dart';
import '../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/containers/network_image.dart';
import '../../../core/ui/custom/containers/tag_container.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../bloc/recipe_detail_cubit/recipe_detail_cubit.dart';
import '../../data/models/recipe_model.dart';
import 'items/ingredient_item.dart';
import 'items/nutrition_container.dart';
import 'items/servings_container.dart';
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
                    child: MyNetworkImage(
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
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          const SizedBox(),
                          ServingsContainer(
                            recipe: recipe,
                            increment: () {},
                            decrement: () {},
                          ),
                          const SizedBox(),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 33.64,
                              minHeight: 32.8,
                            ),
                            child: MySliverList.horizontal(
                              gap: 10,
                              itemBuilder: (context, index) => TagContainer(
                                title: recipe.tags[index],
                              ).listAnimate(index),
                              itemCount: 5,
                            ),
                          ),
                          const SizedBox(),
                          const AppText.heading(
                            text: 'Nutrition Facts',
                            size: 18,
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
                                          child: AppText.primary(
                                            text: 'Steps (8)',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: _calcContainerHeight(
                                    recipe.ingredients.length,
                                  ),
                                  child: PageView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      MySliverList(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            IngredientItem(
                                              ingredient:
                                                  recipe.ingredients[index],
                                            ).listAnimate(index),
                                        itemCount: recipe.ingredients.length,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

  double _calcContainerHeight(int length) {
    int containerHeight = 48;

    double paddingHeight = (length - 1) * 20;

    return (containerHeight * length) + paddingHeight;
  }
}
