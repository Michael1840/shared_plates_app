import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';

class NutritionContainer extends StatelessWidget {
  final double value;
  final String label;
  final String amount;
  final Color color;
  const NutritionContainer({
    super.key,
    required this.value,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        RotatedBox(
          quarterTurns: -1,
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            valueColor: AlwaysStoppedAnimation(color),
            backgroundColor: context.container,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            AppText.heading(text: amount, size: 18),
            AppText.secondary(text: label, size: 10),
          ],
        ),
      ],
    );
  }
}
