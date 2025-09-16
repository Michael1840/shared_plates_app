import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/recipe_model.dart';

class ServingsContainer extends StatelessWidget {
  final RecipeDetailModel recipe;
  final void Function() increment;
  final void Function() decrement;
  const ServingsContainer({
    super.key,
    required this.recipe,
    required this.increment,
    required this.decrement,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(100),
        color: context.green,
        dashPattern: [8, 8],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText.primary(text: 'Servings', color: context.green),
          ),
          Row(
            spacing: 16,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: context.green,
                child: Icon(
                  MyIcons.remove_minus,
                  color: context.white,
                  size: 18,
                ),
              ).onTap(decrement),
              AppText.primary(
                text: recipe.serves.toString(),
                color: context.green,
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: context.green,
                child: Icon(MyIcons.add_plus, color: context.white, size: 18),
              ).onTap(increment),
            ],
          ),
        ],
      ),
    );
  }
}
