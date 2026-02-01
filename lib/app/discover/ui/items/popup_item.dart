import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class MyPopupItem extends PopupMenuItem<void> {
  MyPopupItem({
    super.key,
    required String title,
    required bool isBold,
    required VoidCallback onTap,
  }) : super(
         onTap: onTap,
         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
         child: isBold
             ? AppText.primary(text: title, size: 12, weight: Weights.bold)
             : AppText.secondary(text: title, size: 12, weight: Weights.reg),
       );
}
