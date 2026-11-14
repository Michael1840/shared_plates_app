import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';

enum HeaderTone { paprika, herb }

class PaprikaHeader extends StatelessWidget {
  const new({
    required this.title,
    super.key,
    this.greeting,
    this.actions = const [],
    this.mood = PaprikaMood.happy,
    this.note,
    this.search,
    this.tone = HeaderTone.paprika,
  });

  final String title;
  final String? greeting;
  final List<Widget> actions;
  final PaprikaMood mood;
  final String? note;
  final Widget? search;
  final HeaderTone tone;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final fill = tone == HeaderTone.herb ? sp.headerFriends : sp.header;
    final ink = tone == HeaderTone.herb ? sp.onHeaderFriends : sp.onHeader;
    final top = MediaQuery.paddingOf(context).top;
    final searchBar = search;
    final hello = greeting;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(Rounding.header),
      ),
      child: ColoredBox(
        color: fill,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _HeaderRingsPainter(ink)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.gutter,
                top + Spacing.s,
                Spacing.gutter,
                Spacing.l,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (hello != null || actions.isNotEmpty)
                    _HeaderTopRow(greeting: hello, actions: actions, ink: ink),
                  _HeaderTitleRow(
                    title: title,
                    note: note,
                    mood: mood,
                    ink: ink,
                  ),
                  if (searchBar != null)
                    Entrance(
                      delay: const Duration(milliseconds: 140),
                      child: searchBar,
                    ).paddingOnly(top: Spacing.m),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderTopRow extends StatelessWidget {
  const new({required this.greeting, required this.actions, required this.ink});

  final String? greeting;
  final List<Widget> actions;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.xs,
      children: [
        AppText(
          text: greeting ?? '',
          config: FontConfigs.body3,
          weight: FontWeight.w600,
          color: ink,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).expand(),
        ...actions,
      ],
    );
  }
}

class _HeaderTitleRow extends StatelessWidget {
  const new({
    required this.title,
    required this.note,
    required this.mood,
    required this.ink,
  });

  final String title;
  final String? note;
  final PaprikaMood mood;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final aside = note;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 128),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Entrance(
            delay: const Duration(milliseconds: 60),
            child: Semantics(
              header: true,
              child: AppText(
                text: title,
                config: FontConfigs.title,
                color: ink,
              ),
            ),
          ).expand(),
          SizedBox(
            width: 132,
            child: Transform.translate(
              offset: const Offset(8, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (aside != null)
                    HandwrittenNote(
                      aside,
                      surface: NoteSurface.header,
                      tilt: -6,
                      align: TextAlign.center,
                    ).paddingOnly(bottom: 2),
                  Paprika(mood: mood, tilt: -6),
                ],
              ),
            ),
          ),
        ],
      ),
    ).paddingOnly(top: Spacing.s);
  }
}

class _HeaderRingsPainter extends CustomPainter {
  new(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withValues(alpha: 0.12);
    final corner = Offset(size.width - 30, 30);
    canvas
      ..drawCircle(corner, 96, paint)
      ..drawCircle(corner, 64, paint)
      ..drawCircle(Offset(-10, size.height - 40), 70, paint);
  }

  @override
  bool shouldRepaint(_HeaderRingsPainter oldDelegate) =>
      oldDelegate.color != color;
}
