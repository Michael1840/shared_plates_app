import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/step_model.dart';

class StepItem extends StatelessWidget {
  final StepModel step;
  final int totalCount;
  final bool hasLine;
  const StepItem({
    super.key,
    required this.step,
    required this.totalCount,
    this.hasLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Column(
            // mainAxisSize: .min,
            spacing: 8,
            crossAxisAlignment: .center,
            children: [
              CircleAvatar(radius: 6, backgroundColor: context.primary),
              Expanded(child: Container(width: 1, color: context.onContainer)),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  children: [
                    AppText.heading(
                      text: 'STEP ${step.stepIndex}',
                      color: context.textSecondary,
                      size: 10,
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
                  size: 12,
                ),
              ],
            ).paddingBottom(hasLine ? 20 : 0),
          ),
        ],
      ),
    );
  }
}
