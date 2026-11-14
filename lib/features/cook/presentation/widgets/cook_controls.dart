import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/step_timer.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/cook/presentation/bloc/cook_mode_cubit.dart';

class CookTopBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CookModeCubit>().state;
    final title = state.detail.value?.card.title ?? '';
    final servings = state.currentServings;
    final serves = '$servings ${servings == 1 ? 'serving' : 'servings'}';
    return Row(
      spacing: Spacing.s,
      children: [
        CircleIconButton(
          icon: SpIcons.close,
          semanticLabel: 'Leave cook mode',
          fill: context.raised,
          onTap: () => context.pop(),
        ),
        Column(
          spacing: 2,
          children: [
            AppText(
              text: 'Step ${state.step + 1} of ${state.stepCount}',
              config: FontConfigs.body2,
              weight: FontWeight.w700,
            ),
            AppText.secondary(
              text: '$title · $serves',
              config: FontConfigs.sublabel2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              align: TextAlign.center,
            ),
          ],
        ).expand(),
        CircleIconButton(
          icon: SpIcons.list,
          semanticLabel: 'Show all ingredients',
          fill: context.raised,
          onTap: () =>
              context.bottomSheet<void>(_IngredientsSheet(state: state)),
        ),
      ],
    );
  }
}

class StepSegments extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final (step, count) = context.select<CookModeCubit, (int, int)>(
      (c) => (c.state.step, c.state.stepCount),
    );
    return ExcludeSemantics(
      child: Row(
        spacing: 5,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: context.motion(Motion.medium),
              curve: Motion.arrive,
              height: 5,
              decoration: BoxDecoration(
                color: i <= step
                    ? context.sp.chipSelectedRing
                    : context.sp.handle,
                borderRadius: BorderRadius.circular(3),
              ),
            ).expand(),
        ],
      ),
    );
  }
}

class AwakeNote extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Spacing.xs,
      children: [
        SpIcon(SpIcons.sun, size: 14, color: context.textSecondary),
        const AppText.secondary(
          text: 'Screen stays on while you cook',
          config: FontConfigs.sublabel2,
        ),
      ],
    );
  }
}

class OtherTimers extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CookModeCubit>().state;
    final others = state.runningElsewhere.toList();
    if (others.isEmpty) return const SizedBox.shrink();
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (final index in others)
          _OtherTimerChip(
            index: index,
            remaining: state.timers[index]?.remaining ?? 0,
          ),
      ],
    ).paddingOnly(bottom: Spacing.s);
  }
}

class _OtherTimerChip extends StatelessWidget {
  const new({required this.index, required this.remaining});

  final int index;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final clock = StepTimer.clock(remaining);
    return Pressable(
      semanticLabel: 'Step ${index + 1} timer, $clock left. Go to step.',
      onTap: () => context.read<CookModeCubit>().goTo(index),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: context.sp.honeySoft,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            SpIcon(SpIcons.timer, size: 16, color: context.sp.honeyInk),
            AppText(
              text: 'Step ${index + 1} · $clock',
              config: FontConfigs.sublabel1,
              weight: FontWeight.w700,
              color: context.sp.honeyInk,
            ),
          ],
        ),
      ),
    );
  }
}

class StepNavButtons extends StatelessWidget {
  const new({required this.onFinish, super.key});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final (isFirst, isLast) = context.select<CookModeCubit, (bool, bool)>(
      (c) => (c.state.isFirst, c.state.isLast),
    );
    final cubit = context.read<CookModeCubit>();
    return Row(
      spacing: Spacing.s,
      children: [
        _NavButton(
          label: 'Back',
          semanticLabel: 'Previous step',
          leading: SpIcons.chevronLeft,
          fill: context.raised,
          ink: isFirst ? context.sp.chevron : context.textPrimary,
          onTap: isFirst ? null : cubit.back,
        ).expand(),
        if (isLast)
          _NavButton(
            label: "I'm done!",
            leading: SpIcons.check,
            fill: context.herb,
            ink: context.onPrimary,
            onTap: onFinish,
          ).expand(flex: 2)
        else
          _NavButton(
            label: 'Next step',
            trailing: SpIcons.chevronRight,
            fill: context.primary,
            ink: context.onPrimary,
            onTap: cubit.next,
          ).expand(flex: 2),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const new({
    required this.label,
    required this.fill,
    required this.ink,
    required this.onTap,
    this.semanticLabel,
    this.leading,
    this.trailing,
  });

  static const height = 64.0;

  final String label;
  final String? semanticLabel;
  final SpIcons? leading;
  final SpIcons? trailing;
  final Color fill;
  final Color ink;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lead = leading;
    final trail = trailing;
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        height: height,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            if (lead != null) SpIcon(lead, color: ink),
            AppText(text: label, config: FontConfigs.h4, color: ink),
            if (trail != null) SpIcon(trail, color: ink),
          ],
        ),
      ),
    );
  }
}

class _IngredientsSheet extends StatelessWidget {
  const new({required this.state});

  final CookModeState state;

  @override
  Widget build(BuildContext context) {
    final ingredients = state.detail.value?.ingredients ?? const [];
    final needed = {for (final i in state.needsFor(state.step)) i.id};
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Ingredients',
            note: 'for ${state.currentServings}',
          ),
          const SizedBox(height: Spacing.xs),
          ListView(
            shrinkWrap: true,
            children: [
              for (final i in ingredients)
                _SheetRow(
                  amount: state.amountFor(i),
                  name: state.amountFor(i) == null
                      ? i.rawText
                      : Measure.nameFrom(i.rawText),
                  now: needed.contains(i.id),
                ),
            ],
          ).flexible(),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const new({required this.amount, required this.name, required this.now});

  final String? amount;
  final String name;
  final bool now;

  @override
  Widget build(BuildContext context) {
    final amt = amount;
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.line)),
      ),
      child: Row(
        spacing: Spacing.s,
        children: [
          AppRichText(
            config: FontConfigs.body1,
            spans: [
              if (amt != null)
                TextSpan(
                  text: '$amt ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              TextSpan(text: name),
            ],
          ).expand(),
          if (now)
            AppText(
              text: 'this step',
              config: FontConfigs.note,
              color: context.sp.accentText,
            ),
        ],
      ),
    );
  }
}
