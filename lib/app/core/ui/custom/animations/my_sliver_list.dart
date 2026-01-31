import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../containers/outline_empty_container.dart';

class CustomSliverList extends StatelessWidget {
  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final double gap;
  final Axis scrollDirection;
  final Widget? separator;
  final bool shrinkWrap;
  final String? emptyText;

  const CustomSliverList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.emptyText,
    this.gap = 20,
    this.shrinkWrap = false,
  }) : scrollDirection = Axis.vertical,
       separator = null;

  const CustomSliverList.horizontal({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.emptyText,
    this.gap = 20,
    this.shrinkWrap = false,
  }) : scrollDirection = Axis.horizontal,
       separator = null;

  const CustomSliverList.customSeparator({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.separator,
    this.emptyText,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
  }) : gap = 0;

  @override
  Widget build(BuildContext context) {
    if (itemCount < 1 && emptyText != null) {
      return OutlineEmptyContainer(emptyText: emptyText!).toSliver();
    }

    return SliverList.separated(
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) =>
          separator ??
          SizedBox(
            height: scrollDirection == Axis.vertical ? gap : 0,
            width: scrollDirection == Axis.vertical ? 0 : gap,
          ),
      itemCount: itemCount,
    );
  }
}
