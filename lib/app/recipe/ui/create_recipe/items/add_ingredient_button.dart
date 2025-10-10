import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/extensions.dart';

class AddIngredientButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const AddIngredientButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(100),
        color: context.green,
        dashPattern: [8, 8],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      child: Center(
        child: AppText.primary(text: title, color: context.green),
      ),
    ).onTap(onTap);
  }
}
