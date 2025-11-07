import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class SmallTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isReversed;
  final bool isDisabled;
  final bool isOutlined;
  final EdgeInsets? padding;

  const SmallTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.isReversed = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (isReversed) {
      return Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: isDisabled
              ? context.onContainer.withValues(alpha: 0.2)
              : context.onContainer,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: context.borderSecondary),
        ),
        child: Center(
          child: AppText.heading(
            text: text,
            color: isDisabled
                ? context.textPrimary.withValues(alpha: 0.2)
                : context.textPrimary,
            size: 12,
          ),
        ),
      ).onTap(isDisabled ? null : onTap);
    }

    if (isOutlined) {
      return Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isDisabled
                ? context.green.withValues(alpha: 0.2)
                : context.green,
          ),
        ),
        child: Center(
          child: AppText.heading(
            text: text,
            color: isDisabled
                ? context.green.withValues(alpha: 0.2)
                : context.green,
            size: 12,
          ),
        ),
      ).onTap(isDisabled ? null : onTap);
    }

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: isDisabled
            ? context.green.withValues(alpha: 0.2)
            : context.green,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: AppText.heading(
          text: text,
          color: isDisabled
              ? context.textPrimary.withValues(alpha: 0.2)
              : context.textPrimary,
          size: 12,
        ),
      ),
    ).onTap(isDisabled ? null : onTap);
  }
}
