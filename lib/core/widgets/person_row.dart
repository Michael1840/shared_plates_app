import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';

class PersonRow extends StatelessWidget {
  const PersonRow({
    required this.cook,
    required this.index,
    required this.requested,
    required this.onAdd,
    super.key,
  });

  final PopularCook cook;
  final int index;
  final bool requested;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = Palette.avatars[index % Palette.avatars.length];
    final noun = cook.recipes == 1 ? 'recipe' : 'recipes';
    return Container(
      padding: const EdgeInsets.all(Spacing.s),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        spacing: Spacing.s,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: ExcludeSemantics(
              child: AppText(
                text: cook.initials,
                config: FontConfigs.body2,
                weight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              AppText(
                text: cook.displayName,
                config: FontConfigs.body2,
                weight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppText.secondary(
                text: cook.recipes > 0
                    ? '@${cook.username} · ${cook.recipes} $noun'
                    : '@${cook.username}',
                config: FontConfigs.sublabel1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).expand(),
          _AddButton(
            requested: requested,
            onTap: onAdd,
            name: cook.displayName,
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.requested,
    required this.onTap,
    required this.name,
  });

  final bool requested;
  final VoidCallback onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return Pressable(
      onTap: requested ? null : onTap,
      semanticLabel: requested ? 'Request sent to $name' : 'Add $name',
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        curve: Motion.arrive,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: requested ? 14 : 18),
        decoration: BoxDecoration(
          color: requested ? sp.card : sp.blush,
          borderRadius: BorderRadius.circular(Rounding.chip),
          border: requested
              ? Border.all(color: sp.fieldBorder, width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            if (requested)
              SpIcon(SpIcons.check, size: 16, color: sp.textSecondary),
            AppText(
              text: requested ? 'Requested' : 'Add',
              config: FontConfigs.body3,
              weight: requested ? FontWeight.w600 : FontWeight.w700,
              color: requested ? sp.textSecondary : sp.primaryDeep,
            ),
          ],
        ),
      ),
    );
  }
}
