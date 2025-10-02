import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/containers/default_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/ingredient_model.dart';

class CreateIngredientItem extends StatelessWidget {
  final IngredientModel ingredient;
  const CreateIngredientItem({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 24,
      // color: context.background,
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            child: AppText.primary(
              text: ingredient.name,
              color: context.textPrimary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              AppText.heading(
                text: '${ingredient.quantity} ${ingredient.quantitySymbol}',
                color: context.textPrimary,
                size: 10,
              ),
              AppText.heading(
                text: 'R${ingredient.cost}',
                color: context.primary,
                size: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
