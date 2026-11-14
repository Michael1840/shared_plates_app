import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/status_note.dart';
import 'package:shared_plates_app/core/widgets/time_stamp.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/cook/domain/cook_args.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:shared_plates_app/features/recipe/domain/recipe_detail.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_detail_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/ingredients_card.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_hero.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_sections.dart';

class RecipePage extends StatelessWidget {
  const new({
    required this.recipeId,
    super.key,
    this.card,
    this.preview = false,
  });

  final String recipeId;
  final RecipeCard? card;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final profile = context.read<CurrentProfileCubit>().state;
    return BlocProvider(
      create: (_) {
        final cubit = RecipeDetailCubit(
          repository: sl<RecipeDetailRepository>(),
          recipeId: recipeId,
          viewerId: session.status == SessionStatus.signedIn
              ? session.userId
              : null,
          units: profile?.units ?? UnitSystem.metric,
          preview: card,
          live: !preview,
        );
        unawaited(cubit.start());
        return cubit;
      },
      child: const _RecipeView(),
    );
  }
}

class _RecipeView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeDetailCubit>().state;
    final card = state.card;
    final error = state.detail.error;
    if (card == null) {
      return Scaffold(
        body: DotGridBackground(
          child: SafeArea(
            child: error != null
                ? _Missing(message: error)
                : const _LoadingBody(withHero: true),
          ),
        ),
      );
    }
    final signedIn = context.select<SessionCubit, bool>(
      (c) => c.state.status == SessionStatus.signedIn,
    );
    return Scaffold(
      bottomNavigationBar: _CookBar(
        canFork: signedIn && !card.isMine,
        busy: state.fork.isInProgress,
      ),
      body: DotGridBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RecipeHero(card: card, coverUrl: state.coverUrl),
                  Transform.translate(
                    offset: const Offset(0, -32),
                    child: _Body(state: state, card: card),
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

class _Body extends StatelessWidget {
  const new({required this.state, required this.card});

  final RecipeDetailState state;
  final RecipeCard card;

  @override
  Widget build(BuildContext context) {
    final detail = state.detail.value;
    final note = card.note;
    final minutes = card.totalMinutes;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: DotGridBackground(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.gutter,
                Spacing.l,
                Spacing.gutter,
                Spacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (detail != null && detail.tags.isNotEmpty)
                    TagPills(tags: detail.tags)
                        .paddingOnly(right: 80, bottom: Spacing.s),
                  Entrance(
                    delay: const Duration(milliseconds: 60),
                    child: Semantics(
                      header: true,
                      child: AppText(
                        text: card.title,
                        config: FontConfigs.hero,
                      ),
                    ),
                  ).paddingOnly(right: minutes == null ? 0 : 64),
                  if (state.isOffline)
                    StatusNote.offline().paddingOnly(top: Spacing.m),
                  const SizedBox(height: Spacing.m),
                  AuthorRow(card: card),
                  if (note != null && note.isNotEmpty)
                    CreatorNote(note: note).paddingOnly(top: 14),
                  const SizedBox(height: Spacing.m),
                  FactsGrid(state: state),
                  const SizedBox(height: Spacing.s),
                  ServingsCard(state: state),
                  if (card.kcalPerServing != null && card.matchedLines > 0)
                    NutritionCard(card: card).paddingOnly(top: Spacing.s),
                  const SizedBox(height: Spacing.s),
                  if (detail == null)
                    const _LoadingBody(withHero: false)
                  else
                    _Content(state: state, detail: detail),
                ],
              ),
            ),
          ),
        ),
        if (minutes != null)
          Positioned(
            right: 22,
            top: -36,
            child: TimeStamp(
              minutes: minutes,
              large: true,
              borderColor: context.background,
            ),
          ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const new({required this.state, required this.detail});

  final RecipeDetailState state;
  final RecipeDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (detail.ingredients.isNotEmpty)
          IngredientsCard(state: state, detail: detail),
        if (detail.steps.isNotEmpty)
          MethodSection(
            state: state,
            detail: detail,
          ).paddingOnly(top: Spacing.xl),
      ],
    );
  }
}

class _CookBar extends StatelessWidget {
  const new({required this.canFork, required this.busy});

  final bool canFork;
  final bool busy;

  Future<void> _fork(BuildContext context) async {
    final id = await context.read<RecipeDetailCubit>().saveMyVersion();
    if (!context.mounted) return;
    if (id == null) {
      final error = context.read<RecipeDetailCubit>().state.fork.error;
      if (error != null) context.showSnackBarError(error);
      return;
    }
    context.showSnackBarMessage('Saved as your version. Make it yours.');
    unawaited(context.push(Routes.recipeFor(id)));
  }

  void _cook(BuildContext context) {
    final state = context.read<RecipeDetailCubit>().state;
    final detail = state.detail.value;
    if (detail == null || detail.steps.isEmpty) {
      context.showSnackBarMessage(
        detail == null
            ? 'Still loading. One sec.'
            : 'No steps to cook through yet.',
      );
      return;
    }
    unawaited(
      context.push(
        Routes.cookFor(detail.card.id),
        extra: CookArgs(
          servings: state.currentServings,
          units: state.units,
          coverUrl: state.coverUrl ?? detail.card.coverUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        Spacing.gutter,
        Spacing.s,
        Spacing.gutter,
        bottom + Spacing.s,
      ),
      decoration: BoxDecoration(
        color: context.container,
        border: Border(top: BorderSide(color: context.sp.line)),
      ),
      child: Row(
        spacing: Spacing.s,
        children: [
          if (canFork)
            SizedBox(
              width: 132,
              child: SecondaryButton(
                label: busy ? 'Saving…' : 'My version',
                icon: SpIcons.recipes,
                height: Sizes.button,
                outlined: true,
                onTap: busy ? null : () => unawaited(_fork(context)),
              ),
            ),
          PrimaryButton(
            label: 'Start cooking',
            onTap: () => _cook(context),
          ).expand(),
        ],
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const new({required this.withHero});

  final bool withHero;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading recipe',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Spacing.s,
          children: [
            if (withHero) ...[
              const Skeleton(height: 280, radius: 0),
              const Skeleton(
                width: 240,
                height: 30,
              ).paddingOnly(left: Spacing.gutter, top: Spacing.m),
            ],
            const Skeleton(height: 84, radius: Rounding.row),
            const Skeleton(height: 120, radius: 22),
            const Skeleton(height: 220, radius: 22),
          ],
        ).paddingSymmetric(horizontal: withHero ? 0 : 0),
      ),
    );
  }
}

class _Missing extends StatelessWidget {
  const new({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.gutter),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleIconButton(
              icon: SpIcons.chevronLeft,
              semanticLabel: 'Back',
              onTap: () => context.pop(),
            ),
          ),
          const Spacer(),
          EmptyState(
            mood: PaprikaMood.oops,
            title: "Can't open this one",
            body: message,
            actions: [
              CompactButton(
                label: 'Try again',
                onTap: () => context.read<RecipeDetailCubit>().refresh(),
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
