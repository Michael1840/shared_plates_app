import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_editor_cubit.dart';

class EditorTextField extends StatelessWidget {
  const EditorTextField({
    required this.config,
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.semanticLabel,
    this.minLines,
    this.maxLines = 1,
    this.weight,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.capitalization = TextCapitalization.sentences,
  });

  final FontConfig config;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? semanticLabel;
  final int? minLines;
  final int? maxLines;
  final FontWeight? weight;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final TextAlign textAlign;
  final TextCapitalization capitalization;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      textField: true,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        minLines: minLines,
        maxLines: maxLines,
        textAlign: textAlign,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        textCapitalization: capitalization,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: context.primary,
        style: context.textStyle(
          config,
          color: context.textPrimary,
          weight: weight,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: context.textStyle(
            config,
            color: context.textMuted,
            weight: weight,
          ),
        ),
      ),
    );
  }
}

class TitleField extends StatefulWidget {
  const TitleField({super.key});

  @override
  State<TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  late final TextEditingController _controller = TextEditingController(
    text: context.read<RecipeEditorCubit>().state.draft.title,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final missing = context.select<RecipeEditorCubit, bool>(
      (c) => c.state.showProblems && c.state.draft.title.trim().isEmpty,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        const AppText.secondary(
          text: 'Recipe name',
          config: FontConfigs.sublabel1,
          weight: FontWeight.w600,
        ),
        AnimatedContainer(
          duration: context.motion(Motion.small),
          padding: const EdgeInsets.only(bottom: Spacing.xs),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: missing ? context.primary : context.sp.fieldBorder,
                width: 2,
              ),
            ),
          ),
          child: EditorTextField(
            controller: _controller,
            config: FontConfigs.h1,
            weight: FontWeight.w700,
            hint: "Gran's chakalaka",
            semanticLabel: 'Recipe name',
            maxLines: 2,
            minLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(120)],
            textInputAction: TextInputAction.done,
            capitalization: TextCapitalization.words,
            onChanged: context.read<RecipeEditorCubit>().setTitle,
          ),
        ),
      ],
    );
  }
}

class ServesAndTime extends StatefulWidget {
  const ServesAndTime({super.key});

  @override
  State<ServesAndTime> createState() => _ServesAndTimeState();
}

class _ServesAndTimeState extends State<ServesAndTime> {
  late final TextEditingController _minutes = TextEditingController(
    text: '${context.read<RecipeEditorCubit>().state.draft.totalMinutes ?? ''}',
  );

  @override
  void dispose() {
    _minutes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servings = context.select<RecipeEditorCubit, int>(
      (c) => c.state.draft.servings,
    );
    final cubit = context.read<RecipeEditorCubit>();
    return Row(
      spacing: Spacing.s,
      children: [
        _SmallCard(
          label: 'Serves',
          child: Row(
            children: [
              _StepperButton(
                label: '–',
                semanticLabel: 'Fewer servings',
                onTap: () => cubit.changeServings(-1),
              ),
              AppText(
                text: '$servings',
                config: FontConfigs.h2,
                align: TextAlign.center,
                semanticsLabel: 'Serves $servings',
              ).expand(),
              _StepperButton(
                label: '+',
                semanticLabel: 'More servings',
                onTap: () => cubit.changeServings(1),
              ),
            ],
          ),
        ).expand(),
        _SmallCard(
          label: 'Total time',
          optional: true,
          child: SizedBox(
            height: 40,
            child: Row(
              spacing: Spacing.xs,
              children: [
                SpIcon(SpIcons.clock, size: 18, color: context.textMuted),
                EditorTextField(
                  controller: _minutes,
                  config: FontConfigs.h2,
                  hint: '–',
                  semanticLabel: 'Total time in minutes',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onChanged: cubit.setMinutes,
                ).expand(),
                AppText.secondary(
                  text: 'min',
                  config: FontConfigs.body3,
                  color: context.textMuted,
                ),
              ],
            ),
          ),
        ).expand(),
      ],
    );
  }
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({
    required this.label,
    required this.child,
    this.optional = false,
  });

  final String label;
  final Widget child;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.xs,
        children: [
          AppRichText(
            config: FontConfigs.sublabel2,
            color: context.textSecondary,
            spans: [
              TextSpan(
                text: label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (optional) const TextSpan(text: ' · optional'),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.background,
          borderRadius: BorderRadius.circular(Rounding.chip),
        ),
        alignment: Alignment.center,
        child: AppText(text: label, config: FontConfigs.h3),
      ),
    );
  }
}

class TagsSection extends StatelessWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeEditorCubit>().state;
    final cubit = context.read<RecipeEditorCubit>();
    final chosen = [for (final id in state.draft.tagIds) ?state.tagById(id)];
    final guesses = [for (final id in state.guesses) ?state.tagById(id)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xs,
      children: [
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: [
            for (final tag in chosen)
              _ChosenTag(tag: tag, onRemove: () => cubit.toggleTag(tag.id)),
            for (final tag in guesses)
              _GuessTag(tag: tag, onAdd: () => cubit.toggleTag(tag.id)),
            _AddTagButton(
              onTap: () => context.bottomSheet<void>(
                BlocProvider.value(value: cubit, child: const _TagPicker()),
              ),
            ),
          ],
        ),
        if (guesses.isNotEmpty)
          AppText.secondary(
            text: "Dashed ones are Paprika's guesses from your ingredients.",
            config: FontConfigs.sublabel2,
            color: context.textMuted,
          ),
      ],
    );
  }
}

class _ChosenTag extends StatelessWidget {
  const _ChosenTag({required this.tag, required this.onRemove});

  final Tag tag;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return Pressable(
      onTap: onRemove,
      semanticLabel: 'Remove tag ${tag.label}',
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: sp.chipSelectedFill,
          borderRadius: BorderRadius.circular(Rounding.chip),
          border: Border.all(color: sp.chipSelectedRing, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            AppText(
              text: tag.label,
              config: FontConfigs.sublabel1,
              weight: FontWeight.w700,
              color: sp.chipSelectedText,
            ),
            SpIcon(SpIcons.close, size: 14, color: sp.chipSelectedText),
          ],
        ),
      ),
    );
  }
}

class _GuessTag extends StatelessWidget {
  const _GuessTag({required this.tag, required this.onAdd});

  final Tag tag;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onAdd,
      semanticLabel: 'Add suggested tag ${tag.label}',
      child: DashedBox(
        color: Palette.dashed,
        radius: Rounding.chip,
        strokeWidth: 1.5,
        fill: context.container,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            widthFactor: 1,
            child: AppText(
              text: '+ ${tag.label}',
              config: FontConfigs.sublabel1,
              weight: FontWeight.w600,
              color: context.primaryDeep,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddTagButton extends StatelessWidget {
  const _AddTagButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(Rounding.chip),
          border: Border.all(color: context.line),
        ),
        child: const Center(
          widthFactor: 1,
          child: AppText(
            text: 'Add tag',
            config: FontConfigs.sublabel1,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TagPicker extends StatelessWidget {
  const _TagPicker();

  static const Map<TagKind, String> _kinds = {
    TagKind.meal: 'Meal',
    TagKind.cuisine: 'Cuisine',
    TagKind.occasion: 'Occasion',
    TagKind.diet: 'Diet',
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeEditorCubit>().state;
    final cubit = context.read<RecipeEditorCubit>();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.s,
          children: [
            const AppText(text: 'Tags', config: FontConfigs.h2),
            for (final MapEntry(key: kind, value: label) in _kinds.entries) ...[
              AppText.secondary(
                text: label,
                config: FontConfigs.sublabel1,
                weight: FontWeight.w600,
              ),
              Wrap(
                spacing: Spacing.xs,
                runSpacing: Spacing.xs,
                children: [
                  for (final tag in state.tags)
                    if (tag.kind == kind)
                      SpChip(
                        label: tag.label,
                        height: 36,
                        selected: state.draft.tagIds.contains(tag.id),
                        onTap: () => cubit.toggleTag(tag.id),
                      ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DashedBox extends StatelessWidget {
  const DashedBox({
    required this.child,
    required this.color,
    super.key,
    this.radius = Rounding.card,
    this.strokeWidth = 2,
    this.fill,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double strokeWidth;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRect(
        color: color,
        radius: radius,
        strokeWidth: strokeWidth,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}

class _DashedRect extends CustomPainter {
  const _DashedRect({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ).deflate(strokeWidth / 2),
      );
    final dash = strokeWidth * 3;
    final gap = strokeWidth * 2;
    for (final metric in path.computeMetrics()) {
      final count = (metric.length / (dash + gap)).floor();
      for (var i = 0; i < count; i++) {
        final start = i * (dash + gap);
        canvas.drawPath(metric.extractPath(start, start + dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRect old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth;
}

class VisibilityPicker extends StatelessWidget {
  const VisibilityPicker({super.key});

  static const Map<RecipeVisibility, String> _options = {
    RecipeVisibility.public: 'Everyone',
    RecipeVisibility.friends: 'Friends',
    RecipeVisibility.private: 'Just me',
  };

  @override
  Widget build(BuildContext context) {
    final current = context.select<RecipeEditorCubit, RecipeVisibility>(
      (c) => c.state.draft.visibility,
    );
    final cubit = context.read<RecipeEditorCubit>();
    return Semantics(
      label: 'Who can see it',
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.sp.avoidFill,
          borderRadius: BorderRadius.circular(Spacing.m),
        ),
        child: Row(
          spacing: 4,
          children: [
            for (final MapEntry(key: value, value: label) in _options.entries)
              Semantics(
                inMutuallyExclusiveGroup: true,
                checked: value == current,
                child: Pressable(
                  onTap: () => cubit.setVisibility(value),
                  child: AnimatedContainer(
                    duration: context.motion(Motion.small),
                    height: 42,
                    decoration: BoxDecoration(
                      color: value == current
                          ? context.container
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Rounding.chip),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      text: label,
                      config: FontConfigs.body3,
                      weight: value == current
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: value == current
                          ? context.textPrimary
                          : context.textSecondary,
                    ),
                  ),
                ),
              ).expand(),
          ],
        ),
      ),
    );
  }
}

class EditorSectionTitle extends StatelessWidget {
  const EditorSectionTitle({
    required this.title,
    super.key,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final label = action;
    final tap = onAction;
    return Row(
      children: [
        Semantics(
          header: true,
          child: AppText(text: title, config: FontConfigs.h2),
        ).expand(),
        if (label != null && tap != null)
          Pressable(
            onTap: () => unawaited(Future<void>.sync(tap)),
            child: AppText(
              text: label,
              config: FontConfigs.body3,
              weight: FontWeight.w600,
              color: context.primaryDeep,
            ).paddingSymmetric(vertical: 12),
          ),
      ],
    );
  }
}
