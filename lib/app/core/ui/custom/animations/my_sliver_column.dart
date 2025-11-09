import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../utils/extensions.dart';

class MySliverColumn extends StatelessWidget {
  final double gap;
  final Axis scrollDirection;
  final Widget? separator;
  final Widget? customPinnedWidget;
  final bool shrinkWrap;
  final List<Widget> slivers;
  final ScrollPhysics? physics;
  final RefreshCallback? onRefresh;
  final String? emptyText;

  const MySliverColumn({
    super.key,

    this.gap = 20,
    this.physics,
    this.customPinnedWidget,
    this.shrinkWrap = false,
    this.emptyText,
    this.slivers = const [],
    this.onRefresh,
  }) : scrollDirection = Axis.vertical,
       separator = null;

  const MySliverColumn.customSeparator({
    super.key,
    required this.separator,
    this.scrollDirection = Axis.vertical,
    this.customPinnedWidget,
    this.shrinkWrap = false,
    this.emptyText,
    this.physics,
    this.slivers = const [],
    this.onRefresh,
  }) : gap = 0;

  @override
  Widget build(BuildContext context) {
    Widget body =
        CustomScrollView(
          physics: physics,
          clipBehavior: Clip.hardEdge,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap,
          slivers: slivers,
        ).animate().slideX(
          begin: 1,
          end: 0,
          delay: 0.ms,
          // alignment: Alignment.centerLeft,
        );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        backgroundColor: context.container,
        color: context.textPrimary,

        child: body,
      );
    }

    return body;
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;

  MySliverPersistentHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant MySliverPersistentHeaderDelegate oldDelegate) =>
      true;

  // @override
  // bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
  //   return maxExtent != oldDelegate.maxExtent ||
  //       minExtent != oldDelegate.minExtent ||
  //       child != oldDelegate.child;
  // }
}
