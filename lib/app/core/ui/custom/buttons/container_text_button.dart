import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class ContainerTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color? color;
  final bool hasNoDecoration;
  final bool hasBorder;

  const ContainerTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.hasNoDecoration = false,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color ?? context.onContainer,
        borderRadius: hasNoDecoration ? null : BorderRadius.circular(8),
        border: hasNoDecoration
            ? null
            : hasBorder
                ? Border.all(color: BorderColors.secondary)
                : null,
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
