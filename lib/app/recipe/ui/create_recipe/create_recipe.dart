import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/animations/animate_list.dart';
import '../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/fields/my_form_field.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/ui/layouts/page_container.dart';
import '../../../core/utils/extensions.dart';
import '../../bloc/recipe_detail_cubit/recipe_detail_cubit.dart';
import '../../data/models/ingredient_model.dart';
import '../recipe_detail/items/ingredient_item.dart';
import 'items/add_ingredient_button.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => CreateRecipePageState();
}

class CreateRecipePageState extends State<CreateRecipePage> {
  late final RecipeDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // RecipeModel recipe = kRecipes[0];\
    List<IngredientModel> ingredients = [];
    List<String> steps = [];

    return BlocListener<RecipeDetailCubit, RecipeDetailState>(
      listener: (context, state) {
        if (state.isError) {
          context.showSnackBarError(state.loadingResult.error!);
        }
      },
      child: BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              leadingWidth: 60,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyIconButton(
                    icon: MyIcons.chevron_left,
                    onTap: () {
                      context.pop();
                    },
                  ).paddingLeft(20),
                ],
              ),
              title: AppText.heading(text: 'Create Recipe', size: 18),
            ),
            body: PageContainer.scrollable(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultContainer(
                    width: double.infinity,
                    height: 200,
                    child: Icon(
                      MyIcons.add_plus,
                      size: 30,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(),

                  MyFormField(
                    hint: 'Your recipe title',
                    title: 'Recipe Title',
                    icon: MyIcons.label,
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
                                child: Center(
                                  child: AppText.primary(
                                    text: 'Ingredients (${ingredients.length})',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: DefaultContainer(
                                radius: 100,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                child: Center(
                                  child: AppText.primary(
                                    text: 'Steps (${steps.length})',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _calcContainerHeight(ingredients.length),
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              MySliverList(
                                shrinkWrap: true,
                                itemBuilder: (context, index) => IngredientItem(
                                  ingredient: ingredients[index],
                                ).listAnimate(index),
                                itemCount: ingredients.length,
                              ),
                            ],
                          ),
                        ),

                        AddIngredientButton(onTap: () {}),
                      ],
                    ),
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

  double _calcContainerHeight(int length) {
    if (length <= 0) {
      return 0;
    }

    int containerHeight = 48;

    double paddingHeight = (length - 1) * 20;

    return (containerHeight * length) + paddingHeight;
  }
}
