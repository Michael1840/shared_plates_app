import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/sizing.dart';

class DefaultContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double radius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool expanded;
  final bool hasBorder;
  const DefaultContainer({
    super.key,
    this.height,
    this.width,
    this.color,
    this.borderColor,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.expanded = false,
    this.hasBorder = false,
    this.radius = Rounding.reg,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: expanded ? double.infinity : width,
      clipBehavior: Clip.hardEdge,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? context.container,
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder
            ? Border.all(color: borderColor ?? context.borderPrimary)
            : null,
      ),
      child: child,
    );
  }
}

class OutlineContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? height;
  final double? width;
  final double radius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool expanded;
  const OutlineContainer({
    super.key,
    this.height,
    this.width,
    this.color,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.expanded = false,
    this.radius = Rounding.reg,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: expanded ? double.infinity : width,
      clipBehavior: Clip.hardEdge,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color ?? context.container, width: 2),
      ),
      child: child,
    );
  }
}
