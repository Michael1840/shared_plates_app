import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/step_model.dart';

class StepItem extends StatelessWidget {
  final StepModel step;
  const StepItem({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        AppText.primary(
          text: '${step.stepIndex}.',
          color: context.textPrimary,
          size: 14,
        ),
        Expanded(
          child: AppText.primary(
            text: step.stepDescription,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }
}
