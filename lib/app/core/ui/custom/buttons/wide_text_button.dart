import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../../../utils/sizing.dart';
import '../animations/ball_animation.dart';
import '../containers/default_container.dart';

class WideTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isReversed;
  final EdgeInsets padding;
  final bool disabled;
  final bool isLoading;
  final double? radius;
  final Color? color;
  final Color? textColor;

  const WideTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.isReversed = false,
    this.padding = const EdgeInsets.all(16),
    this.disabled = false,
    this.isLoading = false,
    this.radius,
    this.color,
    this.textColor,
  });

  const WideTextButton.action({
    super.key,
    required this.text,
    this.onTap,
    this.isReversed = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.disabled = false,
    this.isLoading = false,
    this.radius,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultContainer(
        expanded: true,
        padding: padding
            .subtract(const EdgeInsets.all(6))
            .resolve(TextDirection.ltr),
        hasBorder: false,
        radius: radius ?? Rounding.reg,
        color: isReversed ? context.onContainer : color ?? context.green,
        child: const Center(child: BallAnimation(ballSize: 15)),
      );
    }

    if (isReversed) {
      return Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        padding: padding.subtract(const EdgeInsetsGeometry.all(1)),
        decoration: BoxDecoration(
          color: context.onContainer,
          borderRadius: BorderRadius.circular(radius ?? Rounding.reg),
          border: Border.all(
            color: disabled
                ? context.borderSecondary.withValues(alpha: 0.4)
                : context.borderSecondary,
            width: 1,
          ),
        ),
        child: Center(
          child: AppText.heading(
            text: text,
            color: disabled
                ? textColor?.withValues(alpha: 0.4) ??
                      context.white.withValues(alpha: 0.4)
                : textColor ?? context.white,
            size: 14,
          ),
        ),
      ).onTap(disabled ? null : onTap);
    }

    if (disabled) {
      return DefaultContainer(
        expanded: true,
        padding: padding,
        hasBorder: isReversed,
        color:
            color?.withValues(alpha: 0.4) ??
            context.primary.withValues(alpha: 0.4),
        child: Center(
          child: AppText.heading(
            text: text,
            color:
                textColor?.withValues(alpha: 0.4) ??
                context.white.withValues(alpha: 0.4),
            size: 14,
          ),
        ),
      );
    }

    return DefaultContainer(
      expanded: true,
      padding: padding,
      hasBorder: false,
      radius: radius ?? Rounding.reg,
      color: color ?? context.green,
      child: Center(
        child: AppText.heading(
          text: text,
          color: textColor ?? context.white,
          size: 14,
        ),
      ),
    ).onTap(onTap);
  }
}
