import 'package:flutter/material.dart';

class MySliverList extends StatelessWidget {
  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final double gap;
  final Axis scrollDirection;
  final Widget? separator;
  final Widget? customPinnedWidget;
  final bool shrinkWrap;

  const MySliverList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.gap = 20,
    this.customPinnedWidget,
    this.shrinkWrap = false,
  }) : scrollDirection = Axis.vertical,
       separator = null;

  const MySliverList.horizontal({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.gap = 20,
    this.customPinnedWidget,
    this.shrinkWrap = false,
  }) : scrollDirection = Axis.horizontal,
       separator = null;

  const MySliverList.customSeparator({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.separator,
    this.scrollDirection = Axis.vertical,
    this.customPinnedWidget,
    this.shrinkWrap = false,
  }) : gap = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      clipBehavior: Clip.hardEdge,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,

      slivers: [
        ?customPinnedWidget,
        SliverList.separated(
          itemBuilder: itemBuilder,
          separatorBuilder: (context, index) =>
              separator ??
              SizedBox(
                height: scrollDirection == Axis.vertical ? gap : 0,
                width: scrollDirection == Axis.vertical ? 0 : gap,
              ),
          itemCount: itemCount,
        ),
      ],
    );
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
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent ||
        child != oldDelegate.child;
  }
}
