import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/containers/default_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../recipe/data/models/tag_model.dart';

class RecipeTag extends StatelessWidget {
  final TagModel tag;
  final bool isActive;
  final Color? activeColor;
  final void Function()? onTap;
  const RecipeTag({
    super.key,
    required this.tag,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      color: isActive ? activeColor ?? context.primary : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: AppText.secondary(
        text: tag.name,
        color: isActive ? context.white : null,
        weight: Weights.reg,
        size: 10,
      ),
    ).onTap(onTap);
  }
}
