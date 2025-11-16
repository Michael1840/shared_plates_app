import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../containers/default_container.dart';
import '../icons/my_icons.dart';

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
              SliverList.separated(
                itemBuilder: itemBuilder!,
                separatorBuilder: (context, index) =>
                    separator ??
                    SizedBox(
                      height: scrollDirection == Axis.vertical ? gap : 0,
                      width: scrollDirection == Axis.vertical ? 0 : gap,
                    ),
                itemCount: itemCount,
              ),
          ],
        ).animate().slideX(
          begin: 1,
          end: 0,
          delay: 0.ms,
          // alignment: Alignment.centerLeft,
        );

    if (!scrollable && itemBuilder != null) {
      body = SliverList.separated(
        itemBuilder: itemBuilder!,
        separatorBuilder: (context, index) =>
            separator ??
            SizedBox(
              height: scrollDirection == Axis.vertical ? gap : 0,
              width: scrollDirection == Axis.vertical ? 0 : gap,
            ),
        itemCount: itemCount,
      );
    }

    if (emptyText != null && itemCount < 1) {
      body = OutlineContainer(
        radius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MyIcons.magnifying_glass_minus,
              color: context.textSecondary,
              size: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [AppText.secondary(text: emptyText!)],
            ),
          ],
        ),
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
