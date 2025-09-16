import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../appbar/main_app_bar.dart';
import '../buttons/my_icon_button.dart';
import '../fields/search_field.dart';
import '../icons/my_icons.dart';

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
        const SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          collapsedHeight: 0,
          expandedHeight: 75,
          flexibleSpace: MainAppBar(),
        ),
        const PinnedHeaderSliver(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.primary(text: 'Your'),
                  AppText.heading(text: 'Recipe Book'),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: SearchField()),
                  MyIconButton(icon: MyIcons.heart_02, padding: 14),
                ],
              ),
            ],
          ),
        ),
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
