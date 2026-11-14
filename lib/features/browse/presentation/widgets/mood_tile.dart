import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/collection.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';

class MoodTile extends StatelessWidget {
  const new({
    required this.collection,
    required this.index,
    required this.onTap,
    super.key,
  });

  static const _looks = <(Color, Color, CoverStyle)>[
    (Color(0xFFF5E1B5), Color(0xFF3D2A08), CoverStyle.any),
    (Color(0xFFDCE7CD), Color(0xFF1F3510), CoverStyle.veg),
    (Color(0xFF2B221C), Color(0xFFFFF6EE), CoverStyle.meat),
    (Color(0xFFF6D6DA), Color(0xFF4A1622), CoverStyle.sweet),
  ];

  final RecipeCollection collection;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, cover) = _looks[index % _looks.length];
    final subtitle = collection.subtitle;
    return Pressable(
      onTap: onTap,
      semanticLabel: collection.title,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Rounding.card),
        child: Container(
          height: 104,
          color: bg,
          padding: const EdgeInsets.fromLTRB(Spacing.m, 14, Spacing.m, 14),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -30,
                top: -32,
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: bg, width: 4),
                  ),
                  child: ClipOval(
                    child: RecipeCover(style: cover, width: 66, height: 66),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    if (subtitle != null)
                      AppText(
                        text: subtitle,
                        config: FontConfigs.sublabel2,
                        weight: FontWeight.w600,
                        color: fg.withValues(alpha: 0.85),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    AppText(
                      text: collection.title,
                      config: FontConfigs.h3,
                      color: fg,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
