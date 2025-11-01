import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/step_model.dart';

class StepItem extends StatelessWidget {
  final StepModel step;
  final int totalCount;
  const StepItem({super.key, required this.step, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            AppText.heading(
              text: 'Step ${step.stepIndex}',
              color: context.textPrimary,
              size: 12,
            ),
            AppText.heading(
              text: ' / $totalCount',
              color: context.textSecondary,
              size: 10,
            ),
          ],
        ),
        AppText.primary(
          text: step.stepDescription,
          color: context.textPrimary,
          size: 14,
        ),
      ],
    );
  }
}
