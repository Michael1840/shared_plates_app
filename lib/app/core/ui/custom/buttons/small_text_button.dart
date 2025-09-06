import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class SmallTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isReversed;
  final EdgeInsets? padding;

  const SmallTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.isReversed = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (isReversed) {
      return Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: context.onContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.borderSecondary,
          ),
        ),
        child: Center(
          child: AppText.heading(
            text: text,
            color: context.textPrimary,
            size: 12,
          ),
        ),
      ).onTap(onTap);
    }

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: AppText.heading(
          text: text,
          color: context.textPrimary,
          size: 12,
        ),
      ),
    ).onTap(onTap);
  }
}
