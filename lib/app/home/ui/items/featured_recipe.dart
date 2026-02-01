import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/containers/network_image.dart';
import '../../../core/utils/extensions.dart';
import '../../../recipe/data/models/recipe_model.dart';

class FeaturedRecipe extends StatelessWidget {
  final RecipeModel recipe;
  const FeaturedRecipe({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
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
                  const SizedBox(height: 2),
                  AppText.secondary(
                    text: 'by ${recipe.createdBy}',
                    size: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  AppText.primary(
                    text: '324 people viewed today',
                    size: 10,
                    color: context.textSecondary,
                    overflow: TextOverflow.ellipsis,
                    weight: Weights.medium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
