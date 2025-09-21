import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import 'shimmer_container.dart';

class PrimaryLoadingContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  const PrimaryLoadingContainer({
    super.key,
    this.width,
    this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return MyShimmerContainer(
      radius: radius,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 4),
          color: context.primaryLoadingContainer,
        ),
      ),
    );
  }
}

class SecondaryLoadingContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Widget? child;
  final double? radius;
  const SecondaryLoadingContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.radius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 16),
        color: context.secondaryLoadingContainer,
      ),
      child: child,
    );
  }
}
