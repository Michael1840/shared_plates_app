import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/containers/glass_container.dart';
import '../../../core/ui/custom/containers/network_image.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../../recipe/data/models/recipe_model.dart';

class FullWidthCard extends StatelessWidget {
  final RecipeModel recipe;
  final void Function() onLike;
  const FullWidthCard({super.key, required this.recipe, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return OutlineContainer(
      radius: 20,
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 5 / 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MyNetworkImage(url: '${recipe.image}', radius: 0),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      spacing: 4,
                      children: [
                        for (final tag in recipe.tagGroup.tags)
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: AppText.heading(text: tag.name, size: 10),
                          ),
                        if ((recipe.tagGroup.count - 3) > 0)
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            child: AppText.heading(
                              text: '+${recipe.tagGroup.count - 3}',
                              size: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: 40,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
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
                      ],
                    ),

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
                        Row(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Icon(MyIcons.users, color: context.green, size: 16),
                            Align(
                              alignment: Alignment.center,
                              child: AppText.primary(
                                text: '${recipe.serves}',
                                size: 14,
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
                spacing: 40,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    MyIcons.heart_02,
                    color: recipe.isLiked
                        ? StatusColors.redLight
                        : context.textSecondary,
                    size: 20,
                  ).onTap(onLike),
                  Icon(
                    MyIcons.chevron_right,
                    color: context.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
