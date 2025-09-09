import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';

class IngredientItem extends StatelessWidget {
  final String name;
  final bool isChecked;
  final String amount;
  const IngredientItem({
    super.key,
    required this.name,
    required this.isChecked,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(100),
        color: context.textSecondary,
        dashPattern: [8, 8],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isChecked ? context.green : context.textPrimary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.primary(
              text: name,
              color: isChecked ? context.textSecondary : context.textPrimary,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          AppText.heading(
            text: amount,
            color: isChecked ? context.textSecondary : context.textPrimary,
            size: 14,
            decoration: isChecked ? TextDecoration.lineThrough : null,
          ),
        ],
      ),
    );
  }
}
