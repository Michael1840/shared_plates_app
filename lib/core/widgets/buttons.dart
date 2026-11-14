import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class PrimaryButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onTap,
    super.key,
    this.busyLabel,
    this.isBusy = false,
  });

  final String label;
  final String? busyLabel;
  final bool isBusy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !isBusy;
    return Pressable(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1,
        duration: context.motion(Motion.small),
        child: Container(
          height: Sizes.button,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(Rounding.pill),
            boxShadow: [
              BoxShadow(
                color: context.primary.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Spacing.xs,
            children: [
              if (isBusy)
                SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    value: context.reduceMotion ? 0.3 : null,
                    strokeWidth: 2.5,
                    color: context.onPrimary,
                    backgroundColor: context.onPrimary.withValues(alpha: 0.35),
                  ),
                ),
              AppText(
                text: isBusy ? busyLabel ?? label : label,
                config: FontConfigs.button1,
                color: context.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextLinkButton extends StatelessWidget {
  const new({required this.label, required this.onTap, super.key, this.color});

  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: AppText(
        text: label,
        config: FontConfigs.body3,
        weight: FontWeight.w600,
        color: color ?? context.primary,
      ).paddingSymmetric(horizontal: Spacing.xxs, vertical: Spacing.xs),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    super.key,
    this.fill,
    this.color,
    this.size = Sizes.minTap,
    this.badge = false,
    this.badgeBorder,
  });

  final SpIcons icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final Color? fill;
  final Color? color;
  final double size;
  final bool badge;
  final Color? badgeBorder;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: fill ?? context.container,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SpIcon(icon, color: color ?? context.textPrimary),
          ),
          if (badge)
            Positioned(
              top: 9,
              right: 10,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: context.sp.honeyDot,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badgeBorder ?? context.container,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
