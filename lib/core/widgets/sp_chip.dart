import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

enum ChipTone { accent, neutral }

class SpChip extends StatelessWidget {
  const SpChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.icon,
    this.tone = ChipTone.accent,
    this.height = Sizes.chip,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final SpIcons? icon;
  final ChipTone tone;
  final double height;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final duration = context.motion(Motion.small);
    final accent = tone == ChipTone.accent;
    final fill = !selected
        ? sp.chipFill
        : accent
        ? sp.chipSelectedFill
        : sp.avoidFill;
    final ring = !selected
        ? sp.line
        : accent
        ? sp.chipSelectedRing
        : sp.avoidRing;
    final ink = !selected
        ? sp.textPrimary
        : accent
        ? sp.chipSelectedText
        : sp.textPrimary;
    final iconInk = !selected
        ? sp.chevron
        : accent
        ? sp.primary
        : sp.textPrimary;
    final glyph = icon;
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: Motion.arrive,
          height: height,
          padding: EdgeInsets.only(left: glyph == null ? 14 : 11, right: 14),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(Rounding.chip),
            border: Border.all(color: ring, width: selected ? 1.5 : 1),
            boxShadow: selected
                ? null
                : [
                    BoxShadow(
                      color: sp.printShadow.withValues(alpha: 0.06),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 7,
            children: [
              if (glyph != null) SpIcon(glyph, size: 18, color: iconInk),
              AnimatedDefaultTextStyle(
                duration: duration,
                style: context.textStyle(
                  FontConfigs.body3,
                  color: ink,
                  weight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
