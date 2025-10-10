import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../../core/utils/methods.dart';
import '../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../data/models/ingredient_model.dart';
import '../../data/models/step_model.dart';
import 'items/add_ingredient_button.dart';
import 'items/create_ingredient_item.dart';
import 'items/create_ingredient_sheet.dart';
import 'items/create_step_sheet.dart';
import 'items/step_item.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => CreateRecipePageState();
}

class CreateRecipePageState extends State<CreateRecipePage> {
  late final CreateRecipeCubit _cubit;

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<CreateRecipeCubit>();
  }

  void _changePage(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRecipeCubit, CreateRecipeState>(
      listener: (context, state) {
        if (state.isError) {
          context.showSnackBarError(state.loadingResult.error!);
        }
      },
      child: BlocBuilder<CreateRecipeCubit, CreateRecipeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              leadingWidth: 60,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MyIconButton(
                    icon: MyIcons.chevron_left,
                    onTap: () {
                      context.pop();
                    },
                  ).paddingLeft(20),
                ],
              ),
              title: const AppText.heading(text: 'Create Recipe', size: 18),
            ),
            body: PageContainer.scrollable(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.imageFile == null)
                    DefaultContainer(
                      width: double.infinity,
                      height: 200,
                      child: Icon(
                        MyIcons.add_plus,
                        size: 30,
                        color: context.textSecondary,
                      ),
                    ).onTap(() {
                      _cubit.selectImage();
                    })
                  else
                    DefaultContainer(
                      padding: EdgeInsets.zero,
                      width: double.infinity,
                      height: 200,
                      child: Image.file(
                        state.imageFile!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ).onTap(() {
                      _cubit.selectImage();
                    }),
                  const SizedBox(),
                  MyFormField(
                    hint: 'Your recipe title',
                    title: 'Recipe Title',
                    // icon: MyIcons.label,
                    radius: 24,
                  ),
                  MyFormField(
                    hint: 'Your recipe description',
                    title: 'Description',
                    minLines: 5,
                    maxLines: 8,
                    radius: 24,
                  ),
                  const SizedBox(),
                  Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                DefaultContainer(
                                  radius: 100,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  color: _index == 1
                                      ? context.background
                                      : null,
                                  child: Center(
                                    child: AppText.primary(
                                      text:
                                          'Ingredients (${state.ingredients.length})',
                                    ),
                                  ),
                                ).onTap(() {
                                  _changePage(0);
                                }),
                          ),
                          Expanded(
                            child:
                                DefaultContainer(
                                  radius: 100,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  color: _index == 0
                                      ? context.background
                                      : null,
                                  child: Center(
                                    child: AppText.primary(
                                      text: 'Steps (${state.steps.length})',
                                    ),
                                  ),
                                ).onTap(() {
                                  _changePage(1);
                                }),
                          ),
                        ],
                      ),

                      if (_index == 0)
                        MySliverList(
                          key: ValueKey('Ingredients'),
                          gap: 10,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => CreateIngredientItem(
                            ingredient: state.ingredients[index],
                            onDelete: (i) {
                              _cubit.deleteIngredient(i);
                            },
                          ).listAnimate(index),
                          itemCount: state.ingredients.length,
                        ).animate().slideX(begin: -1, end: 0)
                      else
                        MySliverList(
                          key: ValueKey('Steps'),
                          gap: 10,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => CreateStepItem(
                            step: state.steps[index],
                            onDelete: (s) {
                              _cubit.deleteStep(s);
                            },
                          ).listAnimate(index),
                          itemCount: state.steps.length,
                        ).animate().slideX(begin: 1, end: 0),

                      const SizedBox(),
                      AddIngredientButton(
                        title: _index == 0 ? 'Add Ingredient' : 'Add Step',
                        onTap: () {
                          Methods.showBottomSheet(
                            context,
                            _index == 0
                                ? CreateIngredientSheet(
                                    cubit: _cubit,
                                    onConfirm: (IngredientModel i) {
                                      _cubit.updateIngredients(i);
                                    },
                                    currentIndex: state.ingredients.length,
                                  )
                                : CreateStepSheet(
                                    onConfirm: (StepModel s) {
                                      _cubit.updateSteps(s);
                                    },
                                    cubit: _cubit,
                                    currentIndex: state.steps.length,
                                  ),
                          );
                        },
                      ),
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

  double _calcContainerHeight(int length) {
    if (length <= 0) {
      return 0;
    }

    int containerHeight = 48 + 8 + 10;

    double paddingHeight = (length - 1) * 10;

    return (containerHeight * length) + paddingHeight;
  }
}
