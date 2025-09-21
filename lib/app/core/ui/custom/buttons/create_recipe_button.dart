import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions.dart';
import '../icons/my_icons.dart';

enum ButtonType { recipe1, recipe2 }

class CreateRecipeButton extends StatelessWidget {
  final ButtonType type;
  final void Function()? onTap;
  const CreateRecipeButton({super.key, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            type == ButtonType.recipe1 ? createRecipe1 : createRecipe2,
          ),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.55),
              Colors.black.withValues(alpha: 0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: AppText.heading(
                text: 'Create Recipe',
                color: context.white,
                size: 14,
              ),
            ),
            Icon(MyIcons.chevron_right, color: context.white, size: 20),
          ],
        ),
      ),
    ).onTap(onTap);
  }
}
