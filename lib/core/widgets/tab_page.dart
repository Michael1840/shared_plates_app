import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class TabPage extends StatelessWidget {
  const TabPage({
    required this.header,
    required this.children,
    super.key,
    this.onRefresh,
  });

  final Widget header;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final refresh = onRefresh;
    final scroll = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
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
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: refresh == null
          ? scroll
          : RefreshIndicator(
              color: context.primary,
              backgroundColor: context.container,
              onRefresh: refresh,
              child: scroll,
            ),
    );
  }
}
