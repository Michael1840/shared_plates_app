import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class CreateBottomBar extends StatelessWidget {
  const CreateBottomBar({required this.child, super.key, this.note});

  final Widget child;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final hint = note;
    return Container(
      padding: EdgeInsets.fromLTRB(
        Spacing.gutter,
        Spacing.s,
        Spacing.gutter,
        bottom + Spacing.s,
      ),
      decoration: BoxDecoration(
        color: context.container,
        border: Border(top: BorderSide(color: context.sp.skeleton)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.xs,
        children: [
          child,
          if (hint != null)
            AppText.secondary(
              text: hint,
              config: FontConfigs.sublabel2,
              color: context.textMuted,
              align: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
