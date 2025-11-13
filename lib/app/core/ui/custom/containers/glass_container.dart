import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../utils/sizing.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool expanded;
  final double? radius;
  final BoxDecoration? decoration;
  const GlassContainer({
    super.key,
    this.height,
    this.width,
    this.color,
    this.margin,
    this.padding = const EdgeInsets.all(8),
    this.expanded = false,
    this.radius,
    this.decoration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? Rounding.reg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: height,
          width: expanded ? double.infinity : width,
          padding: padding,
          margin: margin,
          decoration:
              decoration ??
              BoxDecoration(
                color: color ?? Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(radius ?? Rounding.reg),
              ),
          child: child,
        ),
      ),
    );
  }
}
