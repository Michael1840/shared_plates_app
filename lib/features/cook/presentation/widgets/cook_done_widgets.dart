import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pop_on_change.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_action_helpers.dart';

class CookedPrint extends StatelessWidget {
  const new({required this.card, super.key, this.coverUrl});

  static const width = 270.0;

  final RecipeCard card;
  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PhotoPrint(
            width: width,
            tilt: 2,
            tapeTilt: -3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Spacing.xxs,
              children: [
                RecipeCover(
                  style: card.coverStyle,
                  imageUrl: coverUrl ?? card.coverUrl,
                  localPath: card.localCoverPath,
                  height: 120,
                ),
                AppText(
                  text: card.title,
                  config: FontConfigs.h4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).paddingOnly(left: 4, right: 4, top: 4),
              ],
            ),
          ),
          const Positioned(left: -18, top: 6, child: _CookedStamp()),
        ],
      ),
    );
  }
}

class _CookedStamp extends StatelessWidget {
  const new();

  static const size = 70.0;

  @override
  Widget build(BuildContext context) {
    return Entrance(
      style: EntranceStyle.stamp,
      delay: const Duration(milliseconds: 640),
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: context.herb,
            shape: BoxShape.circle,
            border: Border.all(color: Palette.card, width: 3),
            boxShadow: [
              BoxShadow(
                color: context.herb.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const AppText(
            text: 'Cooked',
            config: FontConfigs.stampUnitLarge,
            weight: FontWeight.w800,
            color: Palette.card,
          ),
        ).rotated(-12),
      ),
    );
  }
}

class TellCreatorCard extends StatelessWidget {
  const new({
    required this.card,
    required this.value,
    required this.locked,
    required this.onChanged,
    super.key,
  });

  final RecipeCard card;
  final bool value;
  final bool locked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final author = card.authorName;
    final first = (author ?? '').trim().split(RegExp(r'\s+')).first;
    final who = first.isEmpty ? 'the cook' : first;
    final (bg, fg) = Palette.avatars.first;
    final label = 'Let $who know you made it';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: 14),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        spacing: Spacing.s,
        children: [
          Container(
            width: Sizes.minTap,
            height: Sizes.minTap,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: ExcludeSemantics(
              child: AppText(
                text: Formatters.initials(author),
                config: FontConfigs.body3,
                weight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              AppText(
                text: label,
                config: FontConfigs.body2,
                weight: FontWeight.w600,
              ),
              AppText.secondary(
                text: locked
                    ? (value ? 'Sent with your cook' : 'Kept to yourself')
                    : "They'll see that you cooked it",
                config: FontConfigs.sublabel1,
                color: context.textMuted,
              ),
            ],
          ).expand(),
          Semantics(
            label: label,
            child: Switch(
              value: value,
              onChanged: locked ? null : onChanged,
              activeTrackColor: context.herb,
              activeThumbColor: Palette.card,
              inactiveTrackColor: context.sp.disabledFill,
              inactiveThumbColor: Palette.card,
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoneActions extends StatefulWidget {
  const new({required this.card, super.key});

  final RecipeCard card;

  @override
  State<DoneActions> createState() => _DoneActionsState();
}

class _DoneActionsState extends State<DoneActions> {
  late final bool _likedAtOpen = context
      .read<RecipeActionsCubit>()
      .state
      .isLiked(widget.card.id);

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final (liked, saved) = context.select<RecipeActionsCubit, (bool, bool)>(
      (c) => (c.state.isLiked(card.id), c.state.isSaved(card.id)),
    );
    final count = card.likeCount + (liked ? 1 : 0) - (_likedAtOpen ? 1 : 0);
    final likeText = liked ? 'Liked' : 'Like';
    return Row(
      spacing: Spacing.s,
      children: [
        _PillAction(
          label: count > 0
              ? '$likeText · ${Formatters.compact(count)}'
              : likeText,
          semanticLabel: liked ? 'Unlike, $count likes' : 'Like, $count likes',
          icon: PopOnChange(
            value: liked,
            child: SpIcon(SpIcons.heart, color: context.primary, filled: liked),
          ),
          onTap: () => unawaited(context.toggleLike(card)),
        ).expand(),
        _PillAction(
          label: saved ? 'Saved' : 'Save',
          semanticLabel: saved ? 'Remove from saved' : 'Save recipe',
          icon: PopOnChange(
            value: saved,
            child: SpIcon(
              saved ? SpIcons.check : SpIcons.bookmark,
              color: saved ? context.herb : context.textPrimary,
            ),
          ),
          onTap: () => unawaited(context.toggleSave(card)),
        ).expand(),
      ],
    );
  }
}

class _PillAction extends StatelessWidget {
  const new({
    required this.label,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String semanticLabel;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Container(
        height: Sizes.button,
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            icon,
            AppText(text: label, config: FontConfigs.button1),
          ],
        ),
      ),
    );
  }
}
