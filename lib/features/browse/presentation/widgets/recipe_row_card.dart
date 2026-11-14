import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/browse/presentation/card_text.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/save_button.dart';

class RecipeRowCard extends StatelessWidget {
  const new({
    required this.card,
    required this.onTap,
    super.key,
    this.subtitle,
    this.compact = false,
  });

  final RecipeCard card;
  final VoidCallback onTap;
  final String? subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final thumb = compact ? 54.0 : 72.0;
    final details = [?card.plateLabel, ?card.minutesLabel];
    return Pressable(
      onTap: onTap,
      semanticLabel: card.title,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, compact ? 14 : 12, 10),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(compact ? Rounding.row : 22),
          boxShadow: [
            BoxShadow(
              color: context.sp.printShadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          spacing: 14,
          children: [
            PhotoPrint(
              tilt: card.tilt * 1.5,
              padding: EdgeInsets.all(compact ? 3 : 4),
              radius: 4,
              animate: false,
              child: RecipeCover(
                style: card.coverStyle,
                imageUrl: card.coverUrl,
                localPath: card.localCoverPath,
                width: thumb,
                height: thumb,
                radius: 2,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: compact ? 2 : 4,
              children: [
                AppText(
                  text: card.title,
                  config: compact ? FontConfigs.body2 : FontConfigs.h5,
                  weight: compact ? FontWeight.w600 : null,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText.secondary(
                  text: subtitle ?? card.byline,
                  config: FontConfigs.sublabel1,
                  color: context.textMuted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!compact)
                  _RowStats(details: details, likes: card.likesLabel),
              ],
            ).expand(),
            if (compact)
              SpIcon(SpIcons.chevronRight, size: 18, color: context.sp.chevron)
            else
              SaveButton(card: card),
          ],
        ),
      ),
    );
  }
}

class _RowStats extends StatelessWidget {
  const new({required this.details, required this.likes});

  final List<String> details;
  final String likes;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.xs,
      children: [
        for (final (i, d) in details.indexed)
          AppText(
            text: d,
            config: FontConfigs.sublabel2,
            weight: i == 0 ? FontWeight.w700 : null,
            color: i == 0 ? context.textPrimary : context.textSecondary,
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            SpIcon(
              SpIcons.heart,
              size: 13,
              color: context.primary,
              filled: true,
            ),
            AppText.secondary(text: likes, config: FontConfigs.sublabel2),
          ],
        ),
      ],
    );
  }
}

class RecipeRowSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        spacing: 14,
        children: [
          Skeleton(width: 80, height: 80, radius: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Skeleton(height: 14),
                Skeleton(width: 120),
                Skeleton(width: 90, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
