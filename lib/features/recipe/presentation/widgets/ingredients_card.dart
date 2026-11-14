import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/motion/flash_on_change.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/tick_box.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_detail_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/recipe_share.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_sections.dart';

class IngredientsCard extends StatelessWidget {
  const new({required this.state, required this.detail, super.key});

  final RecipeDetailState state;
  final RecipeDetail detail;

  @override
  Widget build(BuildContext context) {
    final ticks = state.ticks;
    final done = detail.ingredients.where((i) => ticks.contains(i.id)).length;
    final total = detail.ingredients.length;
    return WhiteCard(
      padding: const EdgeInsets.fromLTRB(Spacing.m, Spacing.m, Spacing.m, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: Spacing.xs,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  const SectionHeader(title: 'Ingredients'),
                  AppText.secondary(
                    text: done == 0
                        ? 'Tap to tick as you shop'
                        : '$done of $total ticked off',
                    config: FontConfigs.sublabel1,
                    color: context.textMuted,
                  ),
                ],
              ).expand(),
              _SendListButton(state: state, detail: detail),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          for (final (i, ingredient) in detail.ingredients.indexed) ...[
            if (ingredient.section case final String section
                when section.isNotEmpty &&
                    (i == 0 || detail.ingredients[i - 1].section != section))
              AppText(
                text: section,
                config: FontConfigs.sublabel1,
                weight: FontWeight.w700,
                color: context.primaryDeep,
              ).paddingOnly(top: Spacing.s, bottom: 4),
            _IngredientRow(
              ingredient: ingredient,
              amount: state.amountFor(ingredient),
              cost: state.costFor(ingredient),
              ticked: ticks.contains(ingredient.id),
              flash: state.changeTick,
            ),
          ],
        ],
      ),
    );
  }
}

class _SendListButton extends StatelessWidget {
  const new({required this.state, required this.detail});

  final RecipeDetailState state;
  final RecipeDetail detail;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      semanticLabel: 'Share shopping list',
      onTap: () => unawaited(
        SharePlus.instance.share(
          ShareParams(
            subject: 'Shopping list',
            text: RecipeShare.shoppingList(
              card: detail.card,
              ingredients: detail.ingredients,
              ticked: state.ticks,
              amountFor: state.amountFor,
              servings: state.currentServings,
            ),
          ),
        ),
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Rounding.chip),
          border: Border.all(color: context.sp.fieldBorder, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            SpIcon(SpIcons.share, size: 18, color: context.textPrimary),
            const AppText(
              text: 'Send list',
              config: FontConfigs.sublabel1,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const new({
    required this.ingredient,
    required this.amount,
    required this.cost,
    required this.ticked,
    required this.flash,
  });

  final RecipeIngredient ingredient;
  final String? amount;
  final int? cost;
  final bool ticked;
  final int flash;

  @override
  Widget build(BuildContext context) {
    final name = amount == null
        ? ingredient.rawText
        : Measure.nameFrom(ingredient.rawText);
    final ink = ticked ? context.sp.chevron : context.textPrimary;
    final style = context.textStyle(
      FontConfigs.body2,
      color: ink,
      decoration: ticked ? TextDecoration.lineThrough : null,
    );
    final amt = amount;
    final price = cost;
    return Semantics(
      checked: ticked,
      label: [?amt, name].join(' '),
      excludeSemantics: true,
      child: Pressable(
        isButton: false,
        onTap: () => unawaited(
          context.read<RecipeDetailCubit>().toggleTick(ingredient.id),
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.sp.progressTrack)),
          ),
          child: Row(
            spacing: Spacing.s,
            children: [
              TickBox(checked: ticked),
              AnimatedDefaultTextStyle(
                duration: context.motion(Motion.small),
                style: style,
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (amt != null) ...[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: FlashOnChange(
                            trigger: flash,
                            child: Text(
                              amt,
                              style: style.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' '),
                      ],
                      TextSpan(text: name),
                      if (ingredient.optional)
                        TextSpan(
                          text: ' (optional)',
                          style: TextStyle(color: context.textMuted),
                        ),
                    ],
                  ),
                ),
              ).expand(),
              if (price != null && price > 0)
                AppText.secondary(
                  text: Formatters.rands(price),
                  config: FontConfigs.sublabel1,
                  color: context.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MethodSection extends StatelessWidget {
  const new({required this.state, required this.detail, super.key});

  final RecipeDetailState state;
  final RecipeDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        const SectionHeader(title: 'Method', note: "you've got this"),
        for (final (i, step) in detail.steps.indexed)
          _StepCard(
            number: i + 1,
            step: step,
            linked: [
              for (final ing in detail.ingredientsForStep(step.id))
                [
                  ?state.amountFor(ing),
                  Measure.nameFrom(ing.rawText),
                ].join(' '),
            ],
            flash: state.changeTick,
          ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const new({
    required this.number,
    required this.step,
    required this.linked,
    required this.flash,
  });

  final int number;
  final RecipeStep step;
  final List<String> linked;
  final int flash;

  @override
  Widget build(BuildContext context) {
    final seconds = step.timerSeconds;
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(Rounding.row),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: context.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AppText(
              text: '$number',
              config: FontConfigs.stamp,
              color: context.onPrimary,
              semanticsLabel: 'Step $number',
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.s,
            children: [
              AppText(text: step.body, config: FontConfigs.body2),
              if (linked.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final text in linked)
                      FlashOnChange(
                        trigger: flash,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.sp.blush,
                            borderRadius: BorderRadius.circular(Rounding.pill),
                          ),
                          child: AppText(
                            text: text,
                            config: FontConfigs.sublabel2,
                            weight: FontWeight.w700,
                            color: context.primaryDeep,
                          ),
                        ),
                      ),
                  ],
                ),
              if (seconds != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: context.sp.honeySoft,
                    borderRadius: BorderRadius.circular(Rounding.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Spacing.xs,
                    children: [
                      SpIcon(
                        SpIcons.clock,
                        size: 16,
                        color: context.sp.honeyInk,
                      ),
                      AppText(
                        text:
                            '${Formatters.minutes((seconds / 60).ceil())} '
                            'timer in cook mode',
                        config: FontConfigs.sublabel1,
                        weight: FontWeight.w700,
                        color: context.sp.honeyInk,
                      ),
                    ],
                  ),
                ),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
