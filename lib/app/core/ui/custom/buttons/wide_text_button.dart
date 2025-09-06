import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../animations/ball_animation.dart';
import '../containers/default_container.dart';

class WideTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isReversed;
  final EdgeInsets padding;
  final bool disabled;
  final bool isLoading;
  const WideTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.isReversed = false,
    this.padding = const EdgeInsets.all(16),
    this.disabled = false,
    this.isLoading = false,
  });

  const WideTextButton.action({
    super.key,
    required this.text,
    this.onTap,
    this.isReversed = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.disabled = false,
    this.isLoading = false,
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
        color: isReversed ? context.onContainer : context.primary,
        child: const Center(
          child: BallAnimation(ballSize: 15),
        ),
      );
    }

    if (isReversed) {
      return Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        padding: padding.subtract(const EdgeInsetsGeometry.all(1)),
        decoration: BoxDecoration(
          color: context.onContainer,
          borderRadius: BorderRadius.circular(8),
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
                ? context.textPrimary.withValues(alpha: 0.4)
                : context.textPrimary,
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
        color: context.primary.withValues(alpha: 0.4),
        child: Center(
          child: AppText.heading(
            text: text,
            color: context.textPrimary.withValues(alpha: 0.4),
            size: 14,
          ),
        ),
      );
    }

    return DefaultContainer(
      expanded: true,
      padding: padding,
      hasBorder: false,
      color: context.primary,
      child: Center(
        child: AppText.heading(
          text: text,
          color: context.textPrimary,
          size: 14,
        ),
      ),
    ).onTap(onTap);
  }
}
