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
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
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
              AppText.heading(text: amount, size: 14),
              AppText.secondary(text: label, size: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class NutritionContainer2 extends StatelessWidget {
  final double value;
  final String label;
  final String amount;
  final Color color;
  const NutritionContainer2({
    super.key,
    required this.value,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      spacing: 2,
      children: [
        AppText.heading(text: amount, size: 12),
        AppText.secondary(text: label.toUpperCase(), size: 8),
      ],
    );
  }
}
