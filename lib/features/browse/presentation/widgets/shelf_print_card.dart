import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/features/browse/presentation/card_text.dart';

class ShelfPrintCard extends StatelessWidget {
  const new({
    required this.card,
    required this.onTap,
    super.key,
    this.delay = const Duration(milliseconds: 160),
  });

  final RecipeCard card;
  final VoidCallback onTap;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: card.title,
      child: PhotoPrint(
        width: 156,
        tilt: card.tilt,
        radius: Rounding.printSmall,
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
        delay: delay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Stack(
              children: [
                RecipeCover(
                  style: card.coverStyle,
                  imageUrl: card.coverUrl,
                  height: 108,
                  radius: 2,
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: _Badge(text: card.shelfBadge),
                ),
              ],
            ),
            AppText(
              text: card.title,
              config: FontConfigs.h5,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ).paddingOnly(left: 2, right: 2, top: 2),
            AppText.secondary(
              text: card.shelfMeta,
              config: FontConfigs.sublabel2,
              color: context.textMuted,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).paddingSymmetric(horizontal: 2),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: BorderRadius.circular(Rounding.pill),
      ),
      child: AppText(
        text: text,
        config: FontConfigs.sublabel3,
        weight: FontWeight.w700,
        color: context.onPrimary,
      ),
    ).rotated(-3);
  }
}
