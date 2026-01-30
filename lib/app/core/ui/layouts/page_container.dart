import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsets? padding;
  final Color? color;
  final bool isScrollable;
  final ScrollPhysics? physics;
  final LinearGradient? gradient;

  const PageContainer({
    super.key,
    this.height,
    this.padding,
    this.color,
    this.isScrollable = false,
    this.gradient,
    required this.child,
  }) : physics = null;

  const PageContainer.scrollable({
    super.key,
    this.height,
    this.padding,
    this.color,
    this.isScrollable = true,
    this.physics,
    this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget pageContainer =
        Container(
          height: height,
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color ?? context.background,
            gradient: gradient,
          ),
          child: child,
        ).onTap(() {
          FocusScope.of(context).unfocus();
        });

    if (isScrollable) {
      return SingleChildScrollView(physics: physics, child: pageContainer);
    }

    return pageContainer;
  }
}
