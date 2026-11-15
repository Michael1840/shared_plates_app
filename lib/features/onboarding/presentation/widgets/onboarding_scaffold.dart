import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.header,
    required this.children,
    required this.action,
    super.key,
  });

  final Widget header;
  final List<Widget> children;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      body: DotGridBackground(
        child: Column(
          children: [
            header,
            ListView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.gutter,
                Spacing.l,
                Spacing.gutter,
                Spacing.l,
              ),
              children: children,
            ).expand(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.gutter,
                0,
                Spacing.gutter,
                bottom + Spacing.l,
              ),
              child: action,
            ),
          ],
        ),
      ),
    );
  }
}
