import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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
    final disabled = onTap == null;
    final fill = disabled ? context.sp.disabledFill : context.primary;
    final ink = disabled ? context.textMuted : context.onPrimary;
    return Pressable(
      onTap: isBusy ? null : onTap,
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        curve: Motion.arrive,
        height: Sizes.button,
        width: double.infinity,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(Rounding.pill),
          boxShadow: disabled
              ? null
              : [
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
                  color: ink,
                  backgroundColor: ink.withValues(alpha: 0.35),
                ),
              ),
            AppText(
              text: isBusy ? busyLabel ?? label : label,
              config: FontConfigs.button1,
              color: ink,
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onTap,
    super.key,
    this.icon,
    this.height = 52,
    this.dark = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onTap;
  final SpIcons? icon;
  final double height;
  final bool dark;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final glyph = icon;
    final fill = dark ? context.textPrimary : context.container;
    final ink = dark ? context.background : context.textPrimary;
    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(Rounding.pill),
          border: outlined
              ? Border.all(color: context.sp.fieldBorder, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            if (glyph != null) SpIcon(glyph, size: 20, color: ink),
            AppText(
              text: label,
              config: FontConfigs.body2,
              weight: FontWeight.w600,
              color: ink,
            ),
          ],
        ),
      ),
    );
  }
}

class TextLinkButton extends StatelessWidget {
  const TextLinkButton({
    required this.label,
    required this.onTap,
    super.key,
    this.color,
  });

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
  const CircleIconButton({
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

class CompactButton extends StatelessWidget {
  const CompactButton({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: Sizes.minTap,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: context.primary,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        child: Center(
          widthFactor: 1,
          child: AppText(
            text: label,
            config: FontConfigs.button2,
            color: context.onPrimary,
          ),
        ),
      ),
    );
  }
}
