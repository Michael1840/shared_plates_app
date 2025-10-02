import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/containers/default_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/step_model.dart';

class CreateStepItem extends StatelessWidget {
  final StepModel step;
  const CreateStepItem({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 24,
      // color: context.background,
      child: Row(
        spacing: 20,
        children: [
          AppText.heading(
            text: '${step.index}.',
            color: context.textPrimary,
            size: 10,
          ),
          Expanded(
            child: AppText.primary(text: step.name, color: context.textPrimary),
          ),
        ],
      ),
    );
  }
}
