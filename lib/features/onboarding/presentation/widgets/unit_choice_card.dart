import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class UnitChoiceCard extends StatelessWidget {
  const UnitChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final SpIcons icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final ink = selected ? sp.chipSelectedText : sp.textPrimary;
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: context.motion(Motion.small),
          curve: Motion.arrive,
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.m),
          decoration: BoxDecoration(
            color: selected ? sp.chipSelectedFill : sp.chipFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? sp.chipSelectedRing : sp.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.xs,
            children: [
              Row(
                spacing: Spacing.xs,
                children: [
                  SpIcon(
                    icon,
                    size: 18,
                    color: selected ? sp.primary : sp.chevron,
                  ),
                  AppText(
                    text: title,
                    config: FontConfigs.body2,
                    weight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: ink,
                  ),
                ],
              ),
              AppText(
                text: subtitle,
                config: FontConfigs.sublabel1,
                color: selected ? ink : context.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
