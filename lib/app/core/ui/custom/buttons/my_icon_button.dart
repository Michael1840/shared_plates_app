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

  const MyIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
  }) : _isColored = false;

  const MyIconButton.colored({
    super.key,
    required this.icon,
    this.onTap,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
  }) : _isColored = true;

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      return Container(
        padding: EdgeInsets.all(padding ?? 8),
        decoration: BoxDecoration(
          color: !_isColored
              ? context.onContainer.withValues(alpha: 0.4)
              : context.primary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: !_isColored
              ? Border.all(
                  color: context.borderSecondary.withValues(alpha: 0.4),
                )
              : null,
        ),
        child: Icon(
          icon,
          color: context.textPrimary.withValues(alpha: 0.4),
          size: 16,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(padding ?? 8),
      decoration: BoxDecoration(
        color: !_isColored ? context.container : context.primary,
        borderRadius: BorderRadius.circular(100),
        border: !_isColored ? Border.all(color: BorderColors.secondary) : null,
      ),
      child: !isLoading
          ? Icon(icon, color: context.textSecondary, size: 18)
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
