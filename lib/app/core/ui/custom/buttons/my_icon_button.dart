import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final double? padding;
  final bool isLoading;
  final bool disabled;
  final bool _isColored;
  final Color? color;
  final Color? iconColor;
  final double? iconSize;
  final bool hasGlow;
  final String? text;

  const MyIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
    this.iconSize,
    this.hasGlow = false,
    this.text,
  }) : _isColored = false,
       color = null,
       iconColor = null;

  const MyIconButton.colored({
    super.key,
    required this.icon,
    this.onTap,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
    this.color,
    this.iconColor,
    this.iconSize,
    this.hasGlow = false,
    this.text,
  }) : _isColored = true;

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      return Container(
        padding: EdgeInsets.all(padding ?? 8),
        decoration: BoxDecoration(
          color: !_isColored
              ? context.onContainer.withValues(alpha: 0.4)
              : color?.withValues(alpha: 0.4) ??
                    context.primary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(100),
          border: !_isColored
              ? Border.all(
                  color: context.borderSecondary.withValues(alpha: 0.4),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(
              icon,
              color: context.textPrimary.withValues(alpha: 0.4),
              size: iconSize ?? 18,
            ),
            if (text != null)
              AppText.primary(
                text: text!,
                color: iconColor?.withValues(alpha: 0.4),
                weight: Weights.medium,
                size: iconSize != null ? (iconSize! - 4) : 13,
              ).paddingRight(8),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(padding ?? 8),
      decoration: BoxDecoration(
        color: !_isColored ? context.container : color ?? context.primary,
        borderRadius: BorderRadius.circular(100),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  blurRadius: 8,
                  color: !_isColored
                      ? context.onContainer.withValues(alpha: 0.3)
                      : color?.withValues(alpha: 0.3) ??
                            context.primary.withValues(alpha: 0.3),
                ),
              ]
            : [],
      ),
      child: !isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(
                  icon,
                  color:
                      iconColor ??
                      (_isColored ? context.white : context.textSecondary),
                  size: iconSize ?? 18,
                ),
                if (text != null)
                  AppText.primary(
                    text: text!,
                    color: iconColor,
                    weight: Weights.medium,
                    size: iconSize != null ? (iconSize! - 4) : 13,
                  ).paddingRight(8),
              ],
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 16, maxWidth: 16),
              child: CircularProgressIndicator(
                color: context.white,
                strokeCap: StrokeCap.round,
              ),
            ),
    ).onTap(onTap);
  }
}
