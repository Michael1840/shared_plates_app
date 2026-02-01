import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/containers/default_container.dart';
import '../../../../core/ui/custom/containers/network_image.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../recipe/data/models/recipe_model.dart';

class MenuItem extends StatelessWidget {
  final RecipeModel recipe;
  const MenuItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return OutlineContainer(
      radius: 20,
      padding: const EdgeInsets.all(12),
      child: IntrinsicHeight(
        child: Row(
          spacing: 10,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: MyNetworkImage(
                height: 50,
                width: 50,
                url: '${recipe.image}',
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.primary(
                    text: recipe.title,
                    size: 14,
                    overflow: TextOverflow.ellipsis,
                    weight: Weights.medium,
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Flexible(
                        child: AppText.primary(
                          text: 'R${recipe.cost}',
                          size: 14,
                          overflow: TextOverflow.ellipsis,
                          weight: Weights.medium,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: context.green,
                        maxRadius: 2,
                      ),
                      Row(
                        spacing: 2,
                        // crossAxisAlignment: CrossAxisAlignment.baseline,
                        // textBaseline: TextBaseline.alphabetic,
                        children: [
                          Icon(MyIcons.users, color: context.green, size: 16),
                          Align(
                            alignment: Alignment.center,
                            child: AppText.primary(
                              text: '${recipe.serves}',
                              size: 12,
                              color: context.green,
                            ),
                          ),
                        ],
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
                const SizedBox(),
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
