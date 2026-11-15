import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_shared_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/recipe_share.dart';

class RecipeSharedPage extends StatelessWidget {
  const RecipeSharedPage({required this.recipeId, super.key});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    return BlocProvider(
      create: (_) {
        final cubit = RecipeSharedCubit(
          repository: sl<CreateRepository>(),
          recipeId: recipeId,
          userId: uid,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const RecipeSharedView(),
    );
  }
}

class RecipeSharedView extends StatelessWidget {
  const RecipeSharedView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeSharedCubit>().state;
    final card = state.card;
    return Scaffold(
      body: DotGridBackground(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SharedHeader(visibility: card?.visibility),
                  if (card != null) ...[
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: _SharedPrint(card: card),
                    ),
                    _BoxProgress(state: state)
                        .paddingSymmetric(horizontal: Spacing.gutter),
                  ],
                  const Spacer(),
                  if (card != null)
                    _SharedActions(card: card).paddingOnly(
                      left: Spacing.gutter,
                      right: Spacing.gutter,
                      top: Spacing.l,
                      bottom: MediaQuery.paddingOf(context).bottom + Spacing.m,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedHeader extends StatelessWidget {
  const _SharedHeader({required this.visibility});

  final RecipeVisibility? visibility;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    final (title, body) = switch (visibility) {
      RecipeVisibility.public => (
        "It's on the table!",
        "Everyone can see it now. I'll tell you when someone saves it.",
      ),
      RecipeVisibility.private => (
        'Saved to your recipes',
        'Only you can see it. Share it with friends whenever you like.',
      ),
      _ => (
        "It's on the table!",
        "Your friends can see it now. I'll tell you when someone saves it.",
      ),
    };
    return HeaderBlock(
      bottomPadding: 64,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: HeaderIconButton(
              icon: SpIcons.close,
              semanticLabel: 'Close',
              onTap: () => context.go(Routes.home),
            ),
          ),
          const Paprika(mood: PaprikaMood.cheer, size: 120),
          Entrance(
            delay: const Duration(milliseconds: 60),
            child: Semantics(
              header: true,
              child: AppText(
                text: title,
                config: FontConfigs.title,
                color: ink,
                align: TextAlign.center,
              ),
            ),
          ),
          AppText(
            text: body,
            config: FontConfigs.body2,
            color: ink,
            align: TextAlign.center,
          ).paddingOnly(top: Spacing.xs),
        ],
      ),
    );
  }
}

class _SharedPrint extends StatelessWidget {
  const _SharedPrint({required this.card});

  final RecipeCard card;

  @override
  Widget build(BuildContext context) {
    final minutes = card.totalMinutes;
    final plate = card.costPerPlate;
    final kcal = card.kcalPerServing;
    final facts = [
      'Serves ${card.baseServings}',
      if (minutes != null) Formatters.minutes(minutes),
      if (plate != null) Formatters.perPlate(plate)!,
      if (kcal != null) '${kcal.round()} kcal',
    ].join(' · ');
    final stamp = card.visibility == RecipeVisibility.private
        ? 'Saved'
        : 'Shared';
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PhotoPrint(
            width: 280,
            tilt: -2,
            tapeTilt: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Spacing.xxs,
              children: [
                RecipeCover(
                  style: card.coverStyle,
                  localPath: card.localCoverPath,
                  height: 140,
                ),
                AppText(
                  text: card.title,
                  config: FontConfigs.h4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).paddingOnly(left: 4, right: 4, top: 4),
                AppText.secondary(
                  text: facts,
                  config: FontConfigs.sublabel2,
                ).paddingSymmetric(horizontal: 4),
              ],
            ),
          ),
          Positioned(
            right: -14,
            top: 100,
            child: Entrance(
              style: EntranceStyle.stamp,
              delay: const Duration(milliseconds: 640),
              child: ExcludeSemantics(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: context.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Palette.card, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    text: stamp,
                    config: FontConfigs.stampUnitLarge,
                    weight: FontWeight.w800,
                    color: Palette.card,
                  ),
                ).rotated(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxProgress extends StatelessWidget {
  const _BoxProgress({required this.state});

  final RecipeSharedState state;

  @override
  Widget build(BuildContext context) {
    final toFill = state.toFill;
    return Row(
      spacing: Spacing.s,
      children: [
        HandwrittenNote('recipe #${state.count}!', tilt: -3),
        Semantics(
          label: '${state.inBox} of ${RecipeSharedState.boxSize} in your box',
          excludeSemantics: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 6,
              color: context.sp.progressTrack,
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: context.motion(Motion.large),
                widthFactor: state.inBox / RecipeSharedState.boxSize,
                child: Container(color: context.honey),
              ),
            ),
          ),
        ).expand(),
        AppText.secondary(
          text: toFill == 0 ? 'Box full!' : '$toFill more to fill your box',
          config: FontConfigs.sublabel2,
          color: context.textMuted,
        ),
      ],
    );
  }
}

class _SharedActions extends StatelessWidget {
  const _SharedActions({required this.card});

  final RecipeCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        if (card.visibility != RecipeVisibility.private)
          SecondaryButton(
            label: 'Share recipe',
            icon: SpIcons.share,
            dark: true,
            height: Sizes.button,
            onTap: () => unawaited(
              SharePlus.instance.share(
                ShareParams(
                  subject: card.title,
                  text: RecipeShare.message(card),
                ),
              ),
            ),
          ),
        Row(
          spacing: Spacing.s,
          children: [
            SecondaryButton(
              label: 'View recipe',
              height: Sizes.button,
              outlined: true,
              onTap: () => context.pushReplacement(Routes.recipeFor(card.id)),
            ).expand(),
            SecondaryButton(
              label: 'Write another',
              height: Sizes.button,
              outlined: true,
              onTap: () => context.go(Routes.create),
            ).expand(),
          ],
        ),
      ],
    );
  }
}
