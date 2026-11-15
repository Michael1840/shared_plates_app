import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';

enum NoteSurface { light, header }

class HandwrittenNote extends StatelessWidget {
  const HandwrittenNote(
    this.text, {
    super.key,
    this.surface = NoteSurface.light,
    this.large = false,
    this.tilt = 0,
    this.align = TextAlign.start,
    this.animate = true,
    this.delay = const Duration(milliseconds: 420),
  });

  final String text;
  final NoteSurface surface;
  final bool large;
  final double tilt;
  final TextAlign align;
  final bool animate;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = surface == NoteSurface.header
        ? context.sp.noteOnHeader
        : context.sp.noteOnLight;
    final note = AppText(
      text: text,
      config: large ? FontConfigs.noteLarge : FontConfigs.note,
      color: color,
      align: align,
    ).rotated(tilt);
    if (!animate) return note;
    return Entrance(style: EntranceStyle.write, delay: delay, child: note);
  }
}
