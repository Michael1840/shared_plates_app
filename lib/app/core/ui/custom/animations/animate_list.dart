import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../utils/extensions.dart';
import 'my_sliver_list.dart';

class MySliverList extends StatelessWidget {
  final int itemCount;
  final ScrollController? scrollController;
  final Widget? Function(BuildContext context, int index)? itemBuilder;
  final double gap;
  final Axis scrollDirection;
  final Widget? separator;
  final Widget? customPinnedWidget;
  final bool shrinkWrap;
  final List<Widget> slivers;
  final ScrollPhysics? physics;
  final RefreshCallback? onRefresh;
  final String? emptyText;
  final bool scrollable;
  final bool bottomSpacer;

  const MySliverList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollController,
    this.gap = 20,
    this.physics,
    this.customPinnedWidget,
    this.shrinkWrap = false,
    this.emptyText,
    this.slivers = const [],
    this.onRefresh,
    this.scrollable = true,
    this.bottomSpacer = false,
  }) : scrollDirection = Axis.vertical,
       separator = null;

  const MySliverList.horizontal({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollController,
    this.gap = 20,
    this.physics,
    this.customPinnedWidget,
    this.shrinkWrap = false,
    this.emptyText,
    this.slivers = const [],
    this.onRefresh,
    this.scrollable = true,
    this.bottomSpacer = false,
  }) : scrollDirection = Axis.horizontal,
       separator = null;

  const MySliverList.customSeparator({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.separator,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.customPinnedWidget,
    this.shrinkWrap = false,
    this.emptyText,
    this.physics,
    this.slivers = const [],
    this.onRefresh,
    this.scrollable = true,
    this.bottomSpacer = false,
  }) : gap = 0;

  @override
  Widget build(BuildContext context) {
    Widget body =
        CustomScrollView(
          controller: scrollController,
          physics: physics,
          clipBehavior: Clip.hardEdge,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap,

          slivers: [
            ...slivers,
            if (itemBuilder != null)
              CustomSliverList(
                emptyText: emptyText ?? 'No items found',
                itemBuilder: itemBuilder!,
                itemCount: itemCount,
              ),
            if (bottomSpacer) const SizedBox(height: 20).toSliver(),
          ],
        ).animate().slideX(
          begin: 1,
          end: 0,
          delay: 0.ms,
          // alignment: Alignment.centerLeft,
        );

    if (!scrollable && itemBuilder != null) {
      body = CustomSliverList(
        emptyText: emptyText ?? 'No items found',
        itemBuilder: itemBuilder!,
        itemCount: itemCount,
      );
    }

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
