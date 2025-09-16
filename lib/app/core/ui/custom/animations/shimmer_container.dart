import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/extensions.dart';

class MyShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final Widget? child;
  const MyShimmerContainer({
    super.key,
    this.height,
    this.width,
    this.child,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0),
        // border: Border.all(color: context.borderPrimary),
        color: context.container,
      ),
      child: Shimmer.fromColors(
        baseColor: context.primaryLoadingContainer,
        highlightColor: context.shimmer,
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
