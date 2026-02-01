import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';

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
        AppText.heading(text: title, size: 16),
        // AppText.primary(
        //   text: 'Discover More',
        //   weight: Weights.medium,
        //   color: context.green,
        //   size: 12,
        // ).onTap(onTap),
      ],
    ).animate().slideX(
      begin: -1,
      end: 0,
      delay: 500.ms,
      // alignment: Alignment.centerLeft,
    );
  }
}
