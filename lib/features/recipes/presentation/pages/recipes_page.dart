import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/grid_print.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/recipes/data/library_repository.dart';
import 'package:shared_plates_app/features/recipes/presentation/bloc/recipes_cubit.dart';

class RecipesPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final uid = session.userId;
    if (session.status != SessionStatus.signedIn || uid == null) {
      return const _GuestRecipes();
    }
    return BlocProvider(
      key: ValueKey(uid),
      create: (_) => RecipesCubit(
        library: sl<LibraryRepository>(),
        profiles: sl<ProfileRepository>(),
        userId: uid,
      )..start(),
      child: const RecipesView(),
    );
  }
}

class RecipesView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipesCubit>().state;
    final total = state.countFor(LibraryTab.all);
    return Scaffold(
      body: TabPage(
        header: PaprikaHeader(
          title: 'Your recipes',
          note: total == 0 ? 'start your box' : '$total and counting',
          mood: PaprikaMood.thinking,
          search: SpSearchBar(
            hint: 'Search your recipes',
            onChanged: context.read<RecipesCubit>().setQuery,
          ),
          bottom: const _LibraryTabs(),
        ),
        children: [
          if (state.entries.isInProgress || state.entries.isIdle)
            const _LibrarySkeleton()
          else if (state.isEmptyLibrary)
            const _EmptyLibrary()
          else ...[
            const _QuickFilters(),
            const _CountRow(),
            const _LibraryGrid(),
          ],
        ],
      ),
    );
  }
}

class _LibraryTabs extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipesCubit>().state;
    final ink = context.sp.onHeader;
    const labels = {
      LibraryTab.all: 'All',
      LibraryTab.saved: 'Saved',
      LibraryTab.created: 'Created',
    };
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ink.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        spacing: 4,
        children: [
          for (final MapEntry(key: tab, value: label) in labels.entries)
            Semantics(
              selected: state.tab == tab,
              button: true,
              child: Pressable(
                onTap: () => context.read<RecipesCubit>().setTab(tab),
                child: AnimatedContainer(
                  duration: context.motion(Motion.small),
                  height: 40,
                  decoration: BoxDecoration(
                    color: state.tab == tab ? ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    text: '$label · ${state.countFor(tab)}',
                    config: FontConfigs.body3,
                    weight: state.tab == tab
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: state.tab == tab ? context.sp.primaryDeep : ink,
                  ),
                ),
              ),
            ).expand(),
        ],
      ),
    );
  }
}

class _QuickFilters extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final filters = context.select<RecipesCubit, Set<QuickFilter>>(
      (c) => c.state.filters,
    );
    final cubit = context.read<RecipesCubit>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        spacing: Spacing.xs,
        children: [
          for (final f in QuickFilter.values)
            SpChip(
              label: f.label,
              selected: filters.contains(f),
              onTap: () => cubit.toggleFilter(f),
            ),
        ],
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipesCubit>().state;
    final n = state.visible.length;
    return Row(
      children: [
        AppText.secondary(
          text: '$n ${n == 1 ? 'recipe' : 'recipes'}',
          config: FontConfigs.sublabel1,
          color: context.textMuted,
        ).expand(),
        Pressable(
          onTap: context.read<RecipesCubit>().toggleSort,
          semanticLabel: 'Sort, now ${_label(state.sort)}',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              AppText(
                text: _label(state.sort),
                config: FontConfigs.sublabel1,
                weight: FontWeight.w600,
              ),
              SpIcon(
                SpIcons.chevronRight,
                size: 14,
                color: context.textPrimary,
              ),
            ],
          ).paddingSymmetric(vertical: 12),
        ),
      ],
    ).paddingOnly(top: Spacing.xs);
  }

  static String _label(LibrarySort sort) =>
      sort == LibrarySort.recent ? 'Recently added' : 'A to Z';
}

class _LibraryGrid extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipesCubit>().state;
    final entries = state.visible;
    if (entries.isEmpty) {
      return EmptyState(
        mood: PaprikaMood.thinking,
        title: 'Nothing here yet',
        body: state.filters.isNotEmpty || state.query.isNotEmpty
            ? 'Nothing matches that. Try fewer filters.'
            : state.tab == LibraryTab.saved
            ? 'Save recipes you love and they live here, even offline.'
            : 'Write your first recipe and it lands here.',
        actions: [
          if (state.filters.isNotEmpty || state.query.isNotEmpty)
            CompactButton(
              label: 'Clear filters',
              onTap: context.read<RecipesCubit>().clearFilters,
            ),
        ],
      );
    }
    return PrintGrid(
      children: [
        for (final (i, e) in entries.indexed)
          if (e.isDraft)
            DraftPrint(
              title: e.card.title,
              toGo: e.stepsToGo,
              index: i,
              onTap: () => context.push(Routes.editRecipe(e.card.id)),
            )
          else
            GridPrint(
              title: e.card.title,
              coverStyle: e.card.coverStyle,
              localPath: e.card.localCoverPath,
              imageUrl: e.card.coverUrl,
              index: i,
              meta: _meta(e),
              badge: e.isMine
                  ? GridBadge('Yours', context.primary, context.onPrimary)
                  : GridBadge('Saved', context.container, context.textPrimary),
              onTap: () => unawaited(context.openRecipe(e.card)),
            ),
      ],
    ).paddingOnly(top: Spacing.xs);
  }

  static String _meta(LibraryEntry e) {
    final plate = Formatters.perPlate(e.card.costPerPlate);
    final second = e.isMine
        ? (e.card.saveCount > 0 ? 'saved ${e.card.saveCount}×' : null)
        : Formatters.shortName(e.card.authorName);
    return [
      ?plate,
      if (second != null && second.isNotEmpty) second,
    ].join(' · ');
  }
}

class _LibrarySkeleton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: Column(
        spacing: Spacing.m,
        children: [
          Row(
            spacing: Spacing.m,
            children: [
              Expanded(child: Skeleton(height: 180)),
              Expanded(child: Skeleton(height: 180)),
            ],
          ),
          Row(
            spacing: Spacing.m,
            children: [
              Expanded(child: Skeleton(height: 180)),
              Expanded(child: Skeleton(height: 180)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      mood: PaprikaMood.happy,
      title: 'Your recipe box is empty',
      note: 'fill me up!',
      body:
          'Write your own or save ones you love. They all live here, '
          'even offline.',
      actions: [
        CompactButton(
          label: 'Write a recipe',
          onTap: () => context.push(Routes.create),
        ),
        CompactButton(
          label: 'Find recipes',
          onTap: () => context.go(Routes.discover),
        ),
      ],
    );
  }
}

class _GuestRecipes extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabPage(
        header: const PaprikaHeader(
          title: 'Your recipes',
          mood: PaprikaMood.thinking,
        ),
        children: [
          EmptyState(
            mood: PaprikaMood.wink,
            title: 'Keep recipes with an account',
            body: 'Saved and shared recipes live here, even offline.',
            actions: [
              CompactButton(
                label: 'Sign in',
                onTap: () =>
                    unawaited(context.read<SessionCubit>().leaveGuest()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
