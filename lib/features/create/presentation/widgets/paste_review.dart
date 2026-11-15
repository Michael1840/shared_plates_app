import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/speech_bubble.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/paste_cubit.dart';

class PasteReview extends StatelessWidget {
  const PasteReview({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasteCubit>().state;
    final cubit = context.read<PasteCubit>();
    final hidden = state.hiddenCount;
    final hiddenIngredients = state.hiddenIngredients;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PastedPreview(text: state.text, lines: state.lineCount),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: Spacing.xs,
          children: [
            Paprika(mood: PaprikaMood.proud, size: 76, decorative: true),
            Expanded(
              child: SpeechBubble(
                raised: false,
                text: "Here's how I split it. Tap a label if I got one wrong.",
              ),
            ),
          ],
        ).paddingOnly(top: Spacing.m),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final line in state.visible)
                _LineRow(
                  line: line,
                  onRelabel: () => cubit.relabel(line.index),
                ),
              if (hidden > 0)
                TextLinkButton(
                  label: hiddenIngredients == hidden
                      ? 'Show $hidden more ingredients'
                      : 'Show $hidden more lines',
                  color: context.primaryDeep,
                  onTap: cubit.showAll,
                ).paddingSymmetric(vertical: 6),
            ],
          ),
        ).paddingOnly(top: Spacing.s),
        for (final line in state.unsure)
          _UnsureCard(
            line: line,
            onInclude: () => cubit.decide(line.index, include: true),
            onSkip: () => cubit.decide(line.index, include: false),
          ).paddingOnly(top: Spacing.s),
      ],
    ).paddingOnly(
      left: Spacing.gutter,
      right: Spacing.gutter,
      top: Spacing.l,
      bottom: Spacing.l,
    );
  }
}

class _PastedPreview extends StatelessWidget {
  const _PastedPreview({required this.text, required this.lines});

  final String text;
  final int lines;

  static String _plural(int n) => n == 1 ? 'line' : 'lines';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.xs,
        children: [
          Row(
            children: [
              AppText.secondary(
                text: 'What you pasted · $lines ${_plural(lines)}',
                config: FontConfigs.sublabel1,
                weight: FontWeight.w600,
              ).expand(),
              TextLinkButton(
                label: 'Edit text',
                color: context.primaryDeep,
                onTap: context.read<PasteCubit>().editText,
              ),
            ],
          ),
          AppText.secondary(
            text: text.replaceAll(RegExp(r'\s*\n\s*'), '. '),
            config: FontConfigs.body3,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class LineLabel {
  const LineLabel(this.label, this.fill, this.ink);

  factory LineLabel.of(BuildContext context, LineKind kind) => switch (kind) {
    LineKind.title => LineLabel(
      'Title',
      context.textPrimary,
      context.background,
    ),
    LineKind.serves => const LineLabel(
      'Serves',
      Palette.slate,
      Palette.slateInk,
    ),
    LineKind.time => const LineLabel('Time', Palette.slate, Palette.slateInk),
    LineKind.section => LineLabel(
      'Section',
      context.sp.blush,
      context.primaryDeep,
    ),
    LineKind.ingredient => const LineLabel(
      'Ingredient',
      Palette.sage,
      Palette.sageInk,
    ),
    LineKind.step => const LineLabel(
      'Step',
      Palette.honeySoft,
      Palette.honeyDeepInk,
    ),
    LineKind.skip || LineKind.heading => LineLabel(
      'Leave out',
      context.sp.progressTrack,
      context.textMuted,
    ),
  };

  final String label;
  final Color fill;
  final Color ink;
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line, required this.onRelabel});

  final ParsedLine line;
  final VoidCallback onRelabel;

  @override
  Widget build(BuildContext context) {
    final look = LineLabel.of(context, line.kind);
    final skipped = line.kind == LineKind.skip;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.sp.progressTrack)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s,
        children: [
          Pressable(
            onTap: onRelabel,
            semanticLabel: 'Change label, now ${look.label}',
            child: Container(
              width: 98,
              height: 32,
              padding: const EdgeInsets.only(left: 10, right: 6),
              decoration: BoxDecoration(
                color: look.fill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  AppText(
                    text: look.label,
                    config: FontConfigs.sublabel2,
                    weight: FontWeight.w700,
                    color: look.ink,
                  ).expand(),
                  SpIcon(SpIcons.chevronRight, size: 14, color: look.ink),
                ],
              ),
            ),
          ),
          AppText(
            text: line.text,
            config: FontConfigs.body3,
            weight: line.kind == LineKind.title
                ? FontWeight.w700
                : FontWeight.w400,
            color: skipped ? context.textMuted : null,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).paddingOnly(top: 6).expand(),
        ],
      ),
    );
  }
}

class _UnsureCard extends StatelessWidget {
  const _UnsureCard({
    required this.line,
    required this.onInclude,
    required this.onSkip,
  });

  final ParsedLine line;
  final VoidCallback onInclude;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final asStep = line.kind == LineKind.step;
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: context.sp.honeySoft,
        borderRadius: BorderRadius.circular(Rounding.row),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s,
        children: [
          const AppText(
            text: "A line I'm not sure about",
            config: FontConfigs.stampUnitLarge,
            color: Palette.honeyDeepInk,
          ),
          AppText(
            text: '"${line.text}"',
            config: FontConfigs.body3,
            color: context.sp.honeyInk,
          ),
          Wrap(
            spacing: Spacing.xs,
            runSpacing: Spacing.xs,
            children: [
              _SmallButton(
                label: asStep ? 'Add as last step' : 'Add as ingredient',
                onTap: onInclude,
              ),
              _SmallButton(label: 'Leave it out', onTap: onSkip),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(Rounding.chip),
        ),
        child: Center(
          widthFactor: 1,
          child: AppText(
            text: label,
            config: FontConfigs.sublabel1,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
