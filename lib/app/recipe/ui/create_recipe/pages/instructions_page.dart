import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/animations/animate_list.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/ui/layouts/page_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/methods.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../../data/models/step_model.dart';
import '../items/create_step_sheet.dart';
import '../items/step_item.dart';

class InstructionsPage extends StatelessWidget {
  final CreateRecipeCubit cubit;
  final CreateRecipeState state;
  final void Function() changePage;

  const InstructionsPage({
    super.key,
    required this.cubit,
    required this.state,
    required this.changePage,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer.scrollable(
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: AppText.primary(text: 'Instructions', size: 16),
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
                  CreateStepSheet(
                    cubit: cubit,
                    onConfirm: (StepModel s) {
                      cubit.updateSteps(s);
                    },
                    currentIndex: state.steps.length,
                  ),
                );
              }),
            ],
          ),
          MySliverList(
            gap: 12,
            shrinkWrap: true,
            emptyText: 'No instructions, add one!',
            itemBuilder: (context, index) => CreateStepItem(
              step: state.steps[index],
              onDelete: (s) {
                cubit.deleteStep(s);
              },
            ).listAnimate(index),
            itemCount: state.steps.length,
          ),
          WideTextButton(
            text: 'Next',
            onTap: changePage,
            disabled: state.steps.isEmpty,
          ),
        ],
      ),
    );
  }
}
