import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/motion/pop_on_change.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_detail_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_action_helpers.dart';

class WhiteCard extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(Spacing.m),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(22),
      ),
      child: child,
    );
  }
}

class TagPills extends StatelessWidget {
  const new({required this.tags, super.key});

  static const _looks = <(Color, Color)>[
    (Palette.blush, Palette.paprikaDeep),
    (Color(0xFFF5E1B5), Color(0xFF6B430B)),
    (Color(0xFFDCE2EE), Color(0xFF2F4064)),
    (Color(0xFFDCE7CD), Color(0xFF2F4A1A)),
  ];

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (final (i, tag) in tags.indexed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _looks[i % _looks.length].$1,
              borderRadius: BorderRadius.circular(Rounding.pill),
            ),
            child: AppText(
              text: tag.label,
              config: FontConfigs.sublabel2,
              weight: FontWeight.w700,
              color: _looks[i % _looks.length].$2,
            ),
          ),
      ],
    );
  }
}

class AuthorRow extends StatefulWidget {
  const new({required this.card, super.key});

  final RecipeCard card;

  @override
  State<AuthorRow> createState() => _AuthorRowState();
}

class _AuthorRowState extends State<AuthorRow> {
  late final bool _likedAtOpen = context
      .read<RecipeActionsCubit>()
      .state
      .isLiked(widget.card.id);

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final liked = context.select<RecipeActionsCubit, bool>(
      (c) => c.state.isLiked(card.id),
    );
    final count = card.likeCount + (liked ? 1 : 0) - (_likedAtOpen ? 1 : 0);
    final (bg, fg) = Palette.avatars.first;
    final name = card.isMine ? 'You' : card.authorName ?? 'A SharedPlates cook';
    final handle = card.authorUsername;
    return Row(
      spacing: Spacing.s,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: ExcludeSemantics(
            child: AppText(
              text: Formatters.initials(card.authorName),
              config: FontConfigs.body3,
              weight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 1,
          children: [
            AppText(
              text: name,
              config: FontConfigs.body2,
              weight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (handle != null)
              AppText.secondary(
                text: '@$handle',
                config: FontConfigs.sublabel1,
                color: context.textMuted,
              ),
          ],
        ).expand(),
        _LikePill(card: card, liked: liked, count: count),
      ],
    );
  }
}

class _LikePill extends StatelessWidget {
  const new({required this.card, required this.liked, required this.count});

  final RecipeCard card;
  final bool liked;
  final int count;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final ink = liked ? sp.onPrimary : sp.textPrimary;
    return Pressable(
      onTap: () => unawaited(context.toggleLike(card)),
      semanticLabel: liked ? 'Unlike, $count likes' : 'Like, $count likes',
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        height: Sizes.minTap,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: liked ? sp.primary : sp.card,
          borderRadius: BorderRadius.circular(Rounding.pill),
          border: Border.all(
            color: liked ? sp.primary : sp.fieldBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            PopOnChange(
              value: liked,
              child: SpIcon(SpIcons.heart, size: 20, color: ink, filled: liked),
            ),
            AppText(
              text: Formatters.compact(count),
              config: FontConfigs.body2,
              weight: FontWeight.w700,
              color: ink,
            ),
          ],
        ),
      ),
    );
  }
}

class CreatorNote extends StatelessWidget {
  const new({required this.note, super.key});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: context.honey, width: 3)),
      ),
      child: AppText(
        text: '“$note”',
        config: FontConfigs.noteLarge,
        color: context.sp.noteOnLight,
      ),
    );
  }
}

class FactsGrid extends StatelessWidget {
  const new({required this.state, super.key});

  final RecipeDetailState state;

  @override
  Widget build(BuildContext context) {
    final card = state.card!;
    final minutes = card.totalMinutes;
    final total = card.costCents == null
        ? null
        : (card.costCents! * state.scale).round();
    final each =
        card.costPerPlate ??
        (card.costCents == null
            ? null
            : (card.costCents! / card.baseServings).round());
    final kcal = card.kcalPerServing;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rounding.row),
      child: ColoredBox(
        color: context.sp.progressTrack,
        child: Row(
          spacing: 1,
          children: [
            _Fact(
              label: 'Time',
              value: minutes == null ? '–' : Formatters.minutes(minutes),
            ).expand(),
            _Fact(
              label: 'Cost',
              value: total == null ? '–' : Formatters.rands(total),
              sub: each == null ? null : '${Formatters.rands(each)} each',
            ).expand(),
            _Fact(
              label: 'Energy',
              value: kcal == null ? '–' : '${kcal.round()} kcal',
              sub: kcal == null ? null : 'per serving',
            ).expand(),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const new({required this.label, required this.value, this.sub});

  final String label;
  final String value;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final extra = sub;
    return Container(
      color: context.container,
      constraints: const BoxConstraints(minHeight: 84),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          AppText.secondary(
            text: label,
            config: FontConfigs.sublabel2,
            color: context.textMuted,
          ),
          AppText(text: value, config: FontConfigs.h5),
          if (extra != null)
            AppText.secondary(
              text: extra,
              config: FontConfigs.sublabel2,
              color: context.textMuted,
            ),
        ],
      ),
    );
  }
}

class ServingsCard extends StatelessWidget {
  const new({required this.state, super.key});

  final RecipeDetailState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeDetailCubit>();
    final servings = state.currentServings;
    return WhiteCard(
      child: Column(
        spacing: Spacing.s,
        children: [
          Row(
            spacing: Spacing.s,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 1,
                children: [
                  AppText(
                    text: 'Servings',
                    config: FontConfigs.body2,
                    weight: FontWeight.w700,
                  ),
                  AppText.secondary(
                    text: 'Amounts update everywhere, steps too',
                    config: FontConfigs.sublabel2,
                  ),
                ],
              ).expand(),
              _Segment(
                children: [
                  _StepperButton(
                    icon: SpIcons.close,
                    minus: true,
                    label: 'Fewer servings',
                    onTap: servings > RecipeDetailState.minServings
                        ? () => cubit.changeServings(-1)
                        : null,
                  ),
                  Semantics(
                    liveRegion: true,
                    label: '$servings servings',
                    excludeSemantics: true,
                    child: SizedBox(
                      width: 34,
                      child: PopOnChange(
                        value: servings,
                        child: AppText(
                          text: '$servings',
                          config: FontConfigs.h5,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  _StepperButton(
                    icon: SpIcons.plus,
                    label: 'More servings',
                    onTap: servings < RecipeDetailState.maxServings
                        ? () => cubit.changeServings(1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 1, color: context.sp.progressTrack),
          Row(
            children: [
              const AppText(
                text: 'Units',
                config: FontConfigs.body2,
                weight: FontWeight.w700,
              ).expand(),
              _Segment(
                children: [
                  for (final system in UnitSystem.values)
                    _UnitOption(
                      label: system == UnitSystem.metric
                          ? 'Metric'
                          : 'Imperial',
                      selected: state.units == system,
                      onTap: () => cubit.setUnits(system),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: children,
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    this.minus = false,
  });

  final SpIcons icon;
  final String label;
  final VoidCallback? onTap;
  final bool minus;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      minSize: 40,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.4 : 1,
        duration: context.motion(Motion.small),
        child: Container(
          width: 44,
          height: 40,
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: minus
              ? Container(width: 14, height: 2.2, color: context.textPrimary)
              : SpIcon(
                  icon,
                  size: 18,
                  strokeWidth: 2.2,
                  color: context.textPrimary,
                ),
        ),
      ),
    );
  }
}

class _UnitOption extends StatelessWidget {
  const new({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: Pressable(
        onTap: onTap,
        minSize: 36,
        child: AnimatedContainer(
          duration: context.motion(Motion.small),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? context.textPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: AppText(
            text: label,
            config: FontConfigs.body3,
            weight: FontWeight.w600,
            color: selected ? context.background : context.textSecondary,
          ),
        ),
      ),
    );
  }
}

class NutritionCard extends StatelessWidget {
  const new({required this.card, super.key});

  final RecipeCard card;

  @override
  Widget build(BuildContext context) {
    final protein = card.proteinG ?? 0;
    final carbs = card.carbsG ?? 0;
    final fat = card.fatG ?? 0;
    final energy = protein * 4 + carbs * 4 + fat * 9;
    int pct(double kcal) => energy == 0 ? 0 : (kcal / energy * 100).round();
    final parts = <(String, double, Color, int)>[
      ('Protein', protein, context.primary, pct(protein * 4)),
      ('Carbs', carbs, context.honey, pct(carbs * 4)),
      ('Fat', fat, context.textSecondary, pct(fat * 9)),
    ];
    final matched = card.matchedLines;
    final total = card.ingredientCount;
    final coverage = matched >= total
        ? 'Worked out from all $total ingredients'
        : 'Worked out from $matched of $total ingredients';
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: SectionHeader(title: 'Nutrition')),
              AppText.secondary(
                text: 'per serving',
                config: FontConfigs.sublabel1,
              ),
            ],
          ),
          Semantics(
            label:
                'Energy split: protein ${parts[0].$4} percent, '
                'carbs ${parts[1].$4} percent, fat ${parts[2].$4} percent',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 3,
                  children: [
                    for (final p in parts)
                      if (p.$4 > 0)
                        Expanded(
                          flex: p.$4,
                          child: Container(color: p.$3),
                        ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final p in parts)
                _Nutrient(label: p.$1, grams: p.$2, swatch: p.$3).expand(),
              _Nutrient(label: 'Fibre', grams: card.fibreG ?? 0).expand(),
            ],
          ),
          AppText.secondary(
            text:
                '$coverage using our food library. '
                'A guide, not medical advice.',
            config: FontConfigs.sublabel2,
            color: context.textMuted,
          ),
        ],
      ),
    );
  }
}

class _Nutrient extends StatelessWidget {
  const new({required this.label, required this.grams, this.swatch});

  final String label;
  final double grams;
  final Color? swatch;

  @override
  Widget build(BuildContext context) {
    final color = swatch;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Row(
          spacing: Spacing.xs,
          children: [
            if (color != null)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            AppText.secondary(text: label, config: FontConfigs.sublabel2),
          ],
        ),
        AppText(text: '${grams.round()} g', config: FontConfigs.h5),
      ],
    );
  }
}
