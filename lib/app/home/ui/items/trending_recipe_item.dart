import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/containers/network_image.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../../recipe/data/models/recipe_model.dart';

class TrendingRecipeItem extends StatelessWidget {
  final RecipeModel recipe;
  const TrendingRecipeItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.sizeOf(context).width * 0.5,
      width: MediaQuery.sizeOf(context).width * 0.6,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.container,
      ),
      child: Column(
        children: [
          MyNetworkImage(url: '', height: 125, radius: 0),
          DefaultContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            radius: 0,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.heading(
                          text: recipe.title,
                          size: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppText.secondary(
                          text: 'by ${recipe.createdBy}',
                          size: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Flexible(
                              child: AppText.heading(
                                text: 'R${recipe.cost}',
                                size: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: context.green,
                              maxRadius: 2,
                            ),
                            AppText.primary(
                              text: '${recipe.serves} Servings',
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
          ),
        ],
      ),
    );
  }
}
