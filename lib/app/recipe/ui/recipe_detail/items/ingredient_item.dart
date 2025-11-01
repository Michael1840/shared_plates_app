import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../data/models/ingredient_model.dart';

class IngredientItem extends StatefulWidget {
  final IngredientModel ingredient;
  const IngredientItem({super.key, required this.ingredient});

  @override
  State<IngredientItem> createState() => _IngredientItemState();
}

class _IngredientItemState extends State<IngredientItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _isChecked ? Icons.check_circle_rounded : Icons.circle_outlined,
          color: _isChecked ? context.green : context.textPrimary,
          size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading(
                text: widget.ingredient.name,
                color: _isChecked ? context.textSecondary : context.textPrimary,
                decoration: _isChecked ? TextDecoration.lineThrough : null,
                size: 12,
              ),
              AppText.primary(
                text:
                    '${widget.ingredient.quantity} ${widget.ingredient.quantitySymbol}',
                color: _isChecked ? context.textSecondary : context.textPrimary,
                decoration: _isChecked ? TextDecoration.lineThrough : null,
                size: 10,
              ),
            ],
          ),
        ),
        AppText.heading(
          text: 'R${widget.ingredient.cost}',
          color: _isChecked ? context.textSecondary : context.textPrimary,
          size: 12,
          decoration: _isChecked ? TextDecoration.lineThrough : null,
        ),
      ],
    ).onTap(() {
      setState(() {
        _isChecked = !_isChecked;
      });
    });
  }
}
