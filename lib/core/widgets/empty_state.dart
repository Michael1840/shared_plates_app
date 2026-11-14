import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';

class EmptyState extends StatelessWidget {
  const new({
    required this.title,
    required this.body,
    super.key,
    this.mood = PaprikaMood.sleepy,
    this.note,
    this.actions = const [],
  });

  final String title;
  final String body;
  final PaprikaMood mood;
  final String? note;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final aside = note;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Paprika(mood: mood, size: 132, decorative: true),
          if (aside != null)
            HandwrittenNote(
              aside,
              large: true,
              tilt: -3,
            ).paddingOnly(top: Spacing.xxs),
          Entrance(
            delay: const Duration(milliseconds: 160),
            child: Semantics(
              header: true,
              child: AppText(
                text: title,
                config: FontConfigs.h2,
                align: TextAlign.center,
              ),
            ),
          ).paddingOnly(top: Spacing.xs),
          AppText.secondary(
            text: body,
            config: FontConfigs.body2,
            align: TextAlign.center,
          ).paddingOnly(top: Spacing.xs),
          if (actions.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: actions,
            ).paddingOnly(top: Spacing.m),
        ],
      ),
    );
  }
}
