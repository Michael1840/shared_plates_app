import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';

class RecipeItem extends StatelessWidget {
  const RecipeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 24,
      child: IntrinsicHeight(
        child: Row(
          spacing: 10,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                'assets/images/image_1.png',
                height: 70,
                width: 70,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText.heading(text: 'Recipe Title', size: 14),
                  const AppText.secondary(text: 'by @michael_k', size: 10),
                  // SizedBox(height: 20),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      const AppText.heading(text: 'R250', size: 14),
                      CircleAvatar(
                        backgroundColor: context.green,
                        maxRadius: 2,
                      ),
                      AppText.primary(
                        text: '2 Servings',
                        size: 12,
                        color: context.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(MyIcons.heart_02, color: context.textSecondary, size: 20),
                Icon(
                  MyIcons.chevron_right,
                  color: context.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
