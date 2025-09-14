import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/extensions.dart';
import '../../../utils/sizing.dart';

class MyShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  const MyShimmerContainer({super.key, this.height, this.width, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Rounding.reg),
        // border: Border.all(color: context.borderPrimary),
        color: context.container,
      ),
      child: Shimmer.fromColors(
        baseColor: context.onContainer,
        highlightColor: context.textSecondary.withValues(alpha: 0.4),
        child:
            child ??
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
      ),
    );
  }
}
