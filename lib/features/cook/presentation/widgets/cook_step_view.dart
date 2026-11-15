import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/step_timer.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/cook/domain/step_text.dart';
import 'package:shared_plates_app/features/cook/presentation/bloc/cook_mode_cubit.dart';

class CookStepArea extends StatelessWidget {
  const CookStepArea({super.key});

  static const _swipeVelocity = 300.0;

  @override
  Widget build(BuildContext context) {
    final (step, direction) = context.select<CookModeCubit, (int, int)>(
      (c) => (c.state.step, c.state.direction),
    );
    final cubit = context.read<CookModeCubit>();
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapUp: (details) =>
            details.localPosition.dx < constraints.maxWidth / 2
            ? cubit.back()
            : cubit.next(),
        onHorizontalDragEnd: (details) {
          final v = details.primaryVelocity ?? 0;
          if (v < -_swipeVelocity) cubit.next();
          if (v > _swipeVelocity) cubit.back();
        },
        child: AnimatedSwitcher(
          duration: context.motion(Motion.medium),
          switchInCurve: Motion.arrive,
          switchOutCurve: Motion.leave,
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.center,
            children: [...previous, ?current],
          ),
          transitionBuilder: (child, animation) => _StepTransition(
            animation: animation,
            incoming: child.key == ValueKey(step),
            direction: direction,
            child: child,
          ),
          child: _StepContent(
            key: ValueKey(step),
            index: step,
            maxHeight: constraints.maxHeight,
          ),
        ),
      ),
    );
  }
}

class _StepTransition extends StatelessWidget {
  const _StepTransition({
    required this.animation,
    required this.incoming,
    required this.direction,
    required this.child,
  });

  static const _travel = 32.0;

  final Animation<double> animation;
  final bool incoming;
  final int direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        final dx = incoming
            ? direction * _travel * (1 - t)
            : -direction * _travel * (1 - t);
        return Opacity(
          opacity: t.clamp(0, 1),
          child: Transform.translate(offset: Offset(dx, 0), child: child),
        );
      },
    );
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({required this.index, required this.maxHeight, super.key});

  final int index;
  final double maxHeight;

  String _noteFor(CookModeState state) {
    if (index == 0) return "let's go";
    if (index == state.stepCount - 1) return 'last one!';
    return "you've got this";
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CookModeCubit>().state;
    final step = state.steps[index];
    final needs = state.needsFor(index);
    final timer = state.timerFor(index);
    final parts = StepText.highlight(step.body, [
      for (final i in needs) i.rawText,
    ]);
    final accent = context.sp.accentText;
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: maxHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Spacing.l,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: Spacing.s,
              children: [
                AppText(
                  text: '${index + 1}',
                  config: FontConfigs.cookStep,
                  color: context.sp.chipSelectedRing,
                  semanticsLabel: 'Step ${index + 1}',
                ),
                HandwrittenNote(
                  _noteFor(state),
                  tilt: -3,
                ).paddingOnly(bottom: 6).expand(),
                const Paprika(
                  mood: PaprikaMood.focused,
                  size: 76,
                  tilt: 6,
                  decorative: true,
                ),
              ],
            ),
            Semantics(
              liveRegion: true,
              child: AppRichText(
                config: FontConfigs.cook,
                spans: [
                  for (final (text, hit) in parts)
                    TextSpan(
                      text: text,
                      style: hit
                          ? TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w700,
                            )
                          : null,
                    ),
                ],
              ),
            ),
            if (needs.isNotEmpty)
              _Needs(labels: [for (final i in needs) state.labelFor(i)]),
            if (timer != null) _TimerButton(timer: timer),
          ],
        ).paddingSymmetric(vertical: Spacing.m),
      ),
    );
  }
}

class _Needs extends StatelessWidget {
  const _Needs({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xs,
      children: [
        const AppText.secondary(
          text: "You'll need",
          config: FontConfigs.sublabel1,
          weight: FontWeight.w600,
        ),
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: [
            for (final label in labels)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.raised,
                  borderRadius: BorderRadius.circular(Rounding.pill),
                ),
                child: AppText(
                  text: label,
                  config: FontConfigs.body2,
                  weight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimerButton extends StatelessWidget {
  const _TimerButton({required this.timer});

  static const height = 64.0;

  final CookTimer timer;

  String get _label {
    if (timer.finished) return "Time's up";
    if (timer.started) return '${StepTimer.clock(timer.remaining)} left';
    final total = timer.total;
    final length = total < 60
        ? '$total sec'
        : Formatters.minutes((total / 60).round());
    return 'Start $length timer';
  }

  String get _action {
    if (timer.finished) return 'Reset';
    if (timer.running) return 'Pause';
    return timer.started ? 'Resume' : 'Go';
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final fill = switch (timer) {
      CookTimer(finished: true) => sp.herb,
      CookTimer(running: true) => sp.honeySoft,
      _ => sp.honey,
    };
    final ink = timer.finished ? sp.onPrimary : sp.honeyInk;
    return Pressable(
      semanticLabel: '$_label. $_action timer.',
      onTap: () => context.read<CookModeCubit>().toggleTimer(),
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        child: Row(
          spacing: Spacing.s,
          children: [
            SpIcon(SpIcons.timer, size: 26, color: ink),
            AppText(text: _label, config: FontConfigs.h4, color: ink).expand(),
            AppText(text: _action, config: FontConfigs.button2, color: ink),
          ],
        ),
      ),
    );
  }
}
