import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';

class TabPage extends StatelessWidget {
  const new({required this.header, required this.children, super.key});

  final Widget header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: header),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              Spacing.gutter,
              Spacing.xl,
              Spacing.gutter,
              bottom + Spacing.l,
            ),
            sliver: SliverList.list(children: children),
          ),
        ],
      ),
    );
  }
}
