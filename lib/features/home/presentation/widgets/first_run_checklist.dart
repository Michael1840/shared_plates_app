import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';

class FirstRunChecklist extends StatelessWidget {
  const FirstRunChecklist({
    required this.progress,
    required this.onDismiss,
    super.key,
  });

  final ChecklistProgress progress;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tasks = [
      _Task(
        title: 'Set up your kitchen',
        hint: progress.setUp
            ? 'Name, tastes and units. Done!'
            : 'Takes a minute',
        done: progress.setUp,
      ),
      _Task(
        title: 'Save a recipe you’d cook this week',
        hint: 'Tap the bookmark on any recipe',
        done: progress.saved,
        route: Routes.discover,
      ),
      _Task(
        title: 'Share your first recipe',
        hint: 'Even a 3-ingredient one counts',
        done: progress.shared,
        route: Routes.create,
        push: true,
      ),
      _Task(
        title: 'Add a friend',
        hint: 'See what they’re cooking',
        done: progress.friendAdded,
        route: Routes.friends,
      ),
    ];
    return PhotoPrint(
      tilt: -0.6,
      tapeTilt: -2,
      padding: const EdgeInsets.fromLTRB(Spacing.m, 18, Spacing.m, Spacing.s),
      color: context.sp.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  const HandwrittenNote('Your first few bites', large: true),
                  AppText.secondary(
                    text:
                        '${progress.done} of ${ChecklistProgress.total} '
                        'done. No rush, do them whenever.',
                    config: FontConfigs.sublabel1,
                  ),
                ],
              ).expand(),
              Pressable(
                onTap: onDismiss,
                semanticLabel: 'Hide this card',
                child: SpIcon(
                  SpIcons.close,
                  size: 18,
                  color: context.textMuted,
                ),
              ),
            ],
          ),
          _ProgressBar(value: progress.done / ChecklistProgress.total),
          Column(children: [for (final t in tasks) _TaskRow(task: t)]),
        ],
      ),
    );
  }
}

class _Task {
  const _Task({
    required this.title,
    required this.hint,
    required this.done,
    this.route,
    this.push = false,
  });

  final String title;
  final String hint;
  final bool done;
  final String? route;
  final bool push;
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${(value * 100).round()} percent done',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          height: 6,
          child: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: context.sp.progressTrack),
              ),
              AnimatedFractionallySizedBox(
                duration: context.motion(Motion.large),
                curve: Motion.arrive,
                widthFactor: value,
                child: ColoredBox(color: context.sp.success),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});

  final _Task task;

  @override
  Widget build(BuildContext context) {
    final route = task.route;
    final sp = context.sp;
    return Pressable(
      onTap: task.done || route == null
          ? null
          : () => task.push ? context.push(route) : context.go(route),
      isButton: !task.done && route != null,
      semanticLabel: task.done ? '${task.title}, done' : task.title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          spacing: Spacing.s,
          children: [
            if (task.done)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: sp.success,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SpIcon(
                  SpIcons.check,
                  size: 16,
                  strokeWidth: 2.6,
                  color: sp.onPrimary,
                ),
              )
            else
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: sp.handle, width: 2),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 1,
              children: [
                AppText(
                  text: task.title,
                  config: FontConfigs.body2,
                  weight: FontWeight.w600,
                  color: task.done ? context.textMuted : context.textPrimary,
                ),
                AppText.secondary(
                  text: task.hint,
                  config: FontConfigs.sublabel2,
                  color: context.textMuted,
                ),
              ],
            ).expand(),
            if (!task.done && route != null)
              SpIcon(SpIcons.chevronRight, size: 18, color: sp.chevron),
          ],
        ),
      ),
    );
  }
}
