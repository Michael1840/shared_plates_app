import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class ViewAllRow extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const ViewAllRow({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10,
      children: [
        AppText.primary(text: title, weight: Weights.medium),
        AppText.primary(
          text: 'View All',
          weight: Weights.reg,
          color: context.textSecondary,
          size: 12,
        ).onTap(onTap),
      ],
    );
  }
}
