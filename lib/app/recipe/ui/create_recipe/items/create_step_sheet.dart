import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/fields/my_form_field.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../../data/models/step_model.dart';

class CreateStepSheet extends StatefulWidget {
  final void Function(StepModel i) onConfirm;
  final CreateRecipeCubit cubit;
  final int currentIndex;
  const CreateStepSheet({
    super.key,
    required this.onConfirm,
    required this.cubit,
    required this.currentIndex,
  });

  @override
  State<CreateStepSheet> createState() => _CreateStepSheetState();
}

class _CreateStepSheetState extends State<CreateStepSheet> {
  final TextEditingController _stepCont = TextEditingController();

  void _addStep() {
    final String name = _stepCont.trimmedText;

    if (name.isEmpty) {
      return;
    }

    final StepModel ingredient = StepModel(
      stepIndex: widget.currentIndex + 1,
      stepDescription: name,
    );

    widget.onConfirm(ingredient);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const AppText.heading(text: 'Add Step', size: 18),
        const SizedBox(),
        MyFormField(
          hint: 'Describe your step in detail',
          title: 'Step',
          controller: _stepCont,
          minLines: 5,
          maxLines: 8,
          radius: 24,
        ),
        const SizedBox(),
        WideTextButton(text: 'Add Step', onTap: _addStep),
      ],
    );
  }
}
