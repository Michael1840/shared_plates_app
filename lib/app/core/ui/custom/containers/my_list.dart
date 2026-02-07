import 'package:flutter/material.dart';

class MyList extends StatelessWidget {
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final int count;
  final double? gap;
  final Widget? customSeparator;
  final bool isHorizontal;
  const MyList({
    super.key,
    required this.count,
    required this.itemBuilder,
    this.gap = 16,
    this.customSeparator,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
      itemCount: count,
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) =>
          customSeparator ??
          SizedBox(
            height: isHorizontal ? 0 : gap,
            width: isHorizontal ? gap : 0,
          ),
    );
  }
}
