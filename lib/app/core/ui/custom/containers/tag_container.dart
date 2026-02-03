import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import 'default_container.dart';

class TagContainer extends StatelessWidget {
  final String title;
  final bool isActive;
  final Color? activeColor;
  final void Function()? onTap;
  const TagContainer({
    super.key,
    required this.title,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      color: isActive ? activeColor ?? context.primary : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppText.secondary(
        text: title,
        color: isActive ? context.white : null,
        size: 12,
        weight: Weights.reg,
      ),
    ).onTap(onTap);
  }
}
