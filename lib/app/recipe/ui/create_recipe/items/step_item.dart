import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/containers/default_container.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/step_model.dart';

class CreateStepItem extends StatelessWidget {
  final StepModel step;
  final void Function(StepModel s) onDelete;
  const CreateStepItem({super.key, required this.step, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 24,
      // color: context.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          AppText.primary(
            text: '${step.index}.',
            color: context.textPrimary,
            size: 14,
          ),
          Expanded(
            child: AppText.primary(text: step.name, color: context.textPrimary),
          ),
          Icon(
            MyIcons.add_minus_square,
            color: context.textSecondary,
            size: 18,
          ).onTap(() => onDelete(step)),
        ],
      ),
    );
  }
}
