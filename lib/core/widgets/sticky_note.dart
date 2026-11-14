import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';

class StickyNote extends StatelessWidget {
  const new({
    required this.body,
    super.key,
    this.title,
    this.mood = PaprikaMood.wink,
    this.showPaprika = true,
    this.actions = const [],
    this.tilt = -0.8,
    this.animate = true,
  });

  final String body;
  final String? title;
  final PaprikaMood mood;
  final bool showPaprika;
  final List<Widget> actions;
  final double tilt;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    final ink = context.sp.honeyInk;
    final note = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            showPaprika ? 84 : Spacing.m,
            14,
            Spacing.m,
            14,
          ),
          constraints: BoxConstraints(minHeight: showPaprika ? 100 : 0),
          decoration: BoxDecoration(
            color: context.sp.honeySoft,
            borderRadius: BorderRadius.circular(Rounding.print),
            boxShadow: [
              BoxShadow(
                color: context.sp.printShadow.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    if (heading != null)
                      TextSpan(
                        text: '$heading ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    TextSpan(text: body),
                  ],
                ),
                style: context.textStyle(FontConfigs.body3, color: ink),
              ),
              if (actions.isNotEmpty) Wrap(spacing: 8, children: actions),
            ],
          ),
        ),
        const Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Center(child: Tape(width: 64, height: 20)),
        ),
        if (showPaprika)
          Positioned(
            left: 4,
            top: 12,
            child: Paprika(
              mood: mood,
              size: 76,
              animate: animate,
              decorative: true,
            ),
          ),
      ],
    ).rotated(tilt);
    if (!animate) return note;
    return Entrance(style: EntranceStyle.print, child: note);
  }
}
