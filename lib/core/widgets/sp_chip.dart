import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';

class SpChip extends StatelessWidget {
  const new({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final duration = context.motion(Motion.small);
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: Motion.arrive,
          height: Sizes.chip,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? sp.chipSelectedFill : sp.chipFill,
            borderRadius: BorderRadius.circular(Rounding.chip),
            border: Border.all(
              color: selected ? sp.chipSelectedRing : sp.line,
              width: selected ? 1.5 : 1,
            ),
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
          child: AnimatedDefaultTextStyle(
            duration: duration,
            style: context.textStyle(
              FontConfigs.body3,
              color: selected ? sp.chipSelectedText : sp.textPrimary,
              weight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
