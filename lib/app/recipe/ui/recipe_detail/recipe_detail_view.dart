import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/containers/glass_container.dart';
import '../../../core/ui/custom/containers/my_list.dart';
import '../../../core/ui/custom/containers/network_image.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/ui/layouts/page_container.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/methods.dart';
import '../../bloc/recipe_detail_cubit/recipe_detail_cubit.dart';
import '../../data/models/recipe_model.dart';
import 'items/ingredient_item.dart';
import 'items/nutrition_container.dart';
import 'items/recipe_tag.dart';
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
        if (state.isError && state.loadingResult.error != null) {
          context.showSnackBarError(state.loadingResult.error!);
        }
      },
      child: BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
        builder: (context, state) {
          if (state.isLoading || state.loadingResult.value == null) {
            return const RecipeDetailPageSkeleton();
          }

          final RecipeDetailModel? recipe = state.loadingResult.value;

          if (recipe == null) {
            return const Scaffold();
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            body: PageContainer.scrollable(
              child: Column(
                spacing: 12,
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Row(
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

                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          decoration: BoxDecoration(
                            color: context.container,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MyNetworkImage(
                            url: '${recipe.image}',
                            radius: 0,
                          ),
                        ),
                        if (recipe.image != null)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: AlignmentGeometry.bottomCenter,
                                  end: AlignmentGeometry.topCenter,
                                  stops: [0.1, 0.6],
                                  colors: [
                                    Colors.black.withValues(alpha: 0.7),
                                    Colors.black.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 10,
                          left: 10,
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: .end,
                            spacing: 8,
                            children: [
                              GlassContainer(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 12,
                                  top: 8,
                                  bottom: 8,
                                ),
                                color: context.green.withValues(alpha: 0.15),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      MyIcons.users_group,
                                      color: context.green,
                                      size: 18,
                                    ),
                                    AppText.heading(
                                      text: recipe.serves.toString(),
                                      size: 14,
                                      weight: Weights.medium,
                                      color: context.green,
                                    ),
                                  ],
                                ),
                              ),
                              GlassContainer(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 12,
                                  top: 8,
                                  bottom: 8,
                                ),
                                color: recipe.isLiked
                                    ? StatusColors.redLight.withValues(
                                        alpha: 0.3,
                                      )
                                    : context.white.withValues(alpha: 0.15),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      MyIcons.heart_02,
                                      color: recipe.isLiked
                                          ? StatusColors.redLight
                                          : context.white,
                                      size: 18,
                                    ),
                                    AppText.heading(
                                      text: recipe.likeCount.toString(),
                                      size: 14,
                                      weight: Weights.medium,
                                      color: recipe.isLiked
                                          ? StatusColors.redLight
                                          : context.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (recipe.tags.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 29.64,
                        minHeight: 28.8,
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) => RecipeTag(
                          tag: recipe.tags[index],
                        ).listAnimate(index),
                        itemCount: recipe.tags.length,
                      ),
                    ),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: .start,
                          children: [
                            AppText.heading(
                              text: recipe.title,
                              overflow: TextOverflow.ellipsis,
                              size: 24,
                            ),
                            Row(
                              children: [
                                const AppText.secondary(
                                  text: 'By ',
                                  overflow: TextOverflow.ellipsis,
                                  size: 10,
                                ),
                                AppText.secondary(
                                  text: recipe.createdBy,
                                  overflow: TextOverflow.ellipsis,
                                  color: context.green,
                                  weight: Weights.medium,
                                  size: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        spacing: 2,
                        crossAxisAlignment: .end,
                        children: [
                          const AppText.secondary(text: 'PRICE', size: 8),
                          AppText.heading(
                            text: Formatter.currencyFormat(
                              recipe.cost.toString(),
                            ),
                            size: 22,
                            weight: Weights.semiBold,
                            color: context.green,
                          ),
                        ],
                      ),
                    ],
                  ),

                  DefaultContainer(
                    child: IntrinsicHeight(
                      child: Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: NutritionContainer2(
                              value: 0.8,
                              label: 'Protein',
                              amount: '25g',
                              color: context.green,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: context.onContainer.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: NutritionContainer2(
                              value: 0.2,
                              label: 'Fat',
                              amount: '90g',
                              color: context.primary,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: context.onContainer.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: const NutritionContainer2(
                              value: 0.4,
                              label: 'Carbs',
                              amount: '5g',
                              color: AccentColors.purple,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: context.onContainer.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: const NutritionContainer2(
                              value: 0.8,
                              label: 'Calories',
                              amount: '256kcal',
                              color: AccentColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(),

                  if (recipe.ingredients.isNotEmpty)
                    Column(
                      // spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            const AppText.heading(
                              text: 'Ingredients',
                              size: 16,
                            ),
                            AppText.secondary(
                              text: '${recipe.ingredients.length} ITEMS',
                              size: 10,
                            ),
                          ],
                        ),
                        MyList(
                          gap: 8,
                          itemBuilder: (context, index) => IngredientItem(
                            ingredient: recipe.ingredients[index],
                          ).listAnimate(index),
                          count: recipe.ingredients.length,
                        ).animate().slideX(begin: -1, end: 0),
                      ],
                    ),
                  const SizedBox(),

                  if (recipe.steps.isNotEmpty)
                    Column(
                      // spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            const AppText.heading(
                              text: 'Instructions',
                              size: 16,
                            ),
                            AppText.secondary(
                              text: '${recipe.steps.length} ITEMS',
                              size: 10,
                            ),
                          ],
                        ),
                        MyList(
                          gap: 8,
                          itemBuilder: (context, index) => StepItem(
                            step: recipe.steps[index],
                            totalCount: recipe.steps.length,
                            hasLine: (recipe.steps.length - 1) != index,
                          ).listAnimate(index),
                          count: recipe.steps.length,
                        ).animate().slideX(begin: -1, end: 0),
                      ],
                    ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
