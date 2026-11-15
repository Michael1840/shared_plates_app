import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_editor_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_fields.dart';

class StepsList extends StatelessWidget {
  const StepsList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeEditorCubit>().state;
    final steps = state.draft.steps;
    final missing = state.showProblems && state.draft.filledSteps.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        for (final (i, step) in steps.indexed)
          StepCard(
            key: ValueKey(step.id),
            number: i + 1,
            step: step,
            focus: state.focusStepId == step.id,
            focusTick: state.focusTick,
          ),
        Pressable(
          onTap: () => context.read<RecipeEditorCubit>().addStep(),
          child: DashedBox(
            color: missing ? context.primary : context.sp.handle,
            radius: 18,
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: Spacing.xs,
                children: [
                  SpIcon(SpIcons.plus, size: 20, color: context.textSecondary),
                  AppText.secondary(
                    text: steps.isEmpty ? 'Add the first step' : 'Add step',
                    config: FontConfigs.body2,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepCard extends StatefulWidget {
  const StepCard({
    required this.number,
    required this.step,
    required this.focus,
    required this.focusTick,
    super.key,
  });

  final int number;
  final DraftStep step;
  final bool focus;
  final int focusTick;

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.step.body,
  );
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    if (widget.focus) _focus.requestFocus();
  }

  @override
  void didUpdateWidget(StepCard old) {
    super.didUpdateWidget(old);
    if (widget.focus && widget.focusTick != old.focusTick) {
      _focus.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeEditorCubit>();
    final seconds = widget.step.timerSeconds;
    final focused = _focus.hasFocus;
    return Dismissible(
      key: ValueKey('dismiss-${widget.step.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cubit.removeStep(widget.step.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.l),
        decoration: BoxDecoration(
          color: context.sp.blush,
          borderRadius: BorderRadius.circular(Rounding.row),
        ),
        child: SpIcon(SpIcons.trash, color: context.primaryDeep),
      ),
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        padding: const EdgeInsets.all(Spacing.m),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(Rounding.row),
          border: Border.all(
            color: focused ? context.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.s,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: context.textPrimary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                text: '${widget.number}',
                config: FontConfigs.sublabel1,
                weight: FontWeight.w700,
                color: context.background,
                semanticsLabel: 'Step ${widget.number}',
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Spacing.xs,
              children: [
                EditorTextField(
                  controller: _controller,
                  focusNode: _focus,
                  config: FontConfigs.body2,
                  hint: 'What happens next?',
                  semanticLabel: 'Step ${widget.number}',
                  minLines: 1,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [LengthLimitingTextInputFormatter(2000)],
                  onChanged: (v) => cubit.updateStep(widget.step.id, v),
                  onSubmitted: (_) => cubit.addStep(after: widget.step.id),
                ),
                if (seconds != null) _TimerFound(seconds: seconds),
              ],
            ).paddingOnly(top: 3).expand(),
          ],
        ),
      ),
    );
  }
}

class _TimerFound extends StatelessWidget {
  const _TimerFound({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final length = seconds < 60
        ? '$seconds sec'
        : Formatters.minutes((seconds / 60).round());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.sp.honeySoft,
        borderRadius: BorderRadius.circular(Rounding.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Spacing.xs,
        children: [
          SpIcon(SpIcons.timer, size: 14, color: context.sp.honeyInk),
          AppText(
            text: '$length timer found',
            config: FontConfigs.sublabel2,
            weight: FontWeight.w700,
            color: context.sp.honeyInk,
          ),
        ],
      ),
    );
  }
}
