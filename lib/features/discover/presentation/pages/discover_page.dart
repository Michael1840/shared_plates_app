import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/collection.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/status_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/browse_skeletons.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/shelf_print_card.dart';
import 'package:shared_plates_app/features/discover/presentation/bloc/discover_cubit.dart';
import 'package:shared_plates_app/features/search/presentation/widgets/filter_sheet.dart';

class DiscoverPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = DiscoverCubit(sl<BrowseRepository>());
        unawaited(cubit.load());
        return cubit;
      },
      child: const _DiscoverView(),
    );
  }
}

class _QuickFilter {
  const new(this.label, this.filters);

  final String label;
  final SearchFilters filters;
}

class _DiscoverView extends StatelessWidget {
  const new();

  static const _quick = [
    _QuickFilter(
      'Under R100',
      SearchFilters(cost: CostLimit.r100, title: 'Under R100'),
    ),
    _QuickFilter(
      '20 min or less',
      SearchFilters(time: TimeLimit.m20, sort: SearchSort.quickest),
    ),
    _QuickFilter('Braai', SearchFilters(tagSlugs: {'braai'}, title: 'Braai')),
    _QuickFilter(
      'Veggie',
      SearchFilters(tagSlugs: {'veggie'}, title: 'Veggie'),
    ),
    _QuickFilter(
      'One pot',
      SearchFilters(tagSlugs: {'one-pot'}, title: 'One pot'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DiscoverCubit>().state;
    final featured = state.featuredOn(DateTime.now());
    return TabPage(
      onRefresh: () => context.read<DiscoverCubit>().load(),
      header: PaprikaHeader(
        title: 'Discover',
        note: 'new picks\nevery Friday',
        mood: PaprikaMood.wink,
        search: SpSearchBar(
          hint: 'Search recipes',
          onTap: () => unawaited(context.openSearch()),
          onFilterTap: () async {
            final filters = await context.showFilters(const SearchFilters());
            if (filters != null && context.mounted) {
              await context.openSearch(filters);
            }
          },
        ),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            spacing: Spacing.xs,
            children: [
              for (final q in _quick)
                SpChip(
                  label: q.label,
                  selected: false,
                  onTap: () => unawaited(context.openSearch(q.filters)),
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.l),
        if (state.isStale) StatusNote.offline().paddingOnly(bottom: Spacing.l),
        if (state.isLoading)
          const _DiscoverSkeleton()
        else if (state.failedEverything)
          EmptyState(
            mood: PaprikaMood.oops,
            title: BrowseMessages.titleFor(state.error),
            body: state.error ?? '',
            actions: [
              CompactButton(
                label: 'Try again',
                onTap: () => context.read<DiscoverCubit>().load(),
              ),
            ],
          )
        else ...[
          if (featured != null) _FeaturedCard(collection: featured),
          _Shelf(
            title:
                state.collectionBySlug(DiscoverState.quickSlug)?.title ??
                'Ready in 20',
            note: 'weeknight savers',
            slice: state.quick,
            onSeeAll: () {
              final c = state.collectionBySlug(DiscoverState.quickSlug);
              unawaited(
                context.openSearch(
                  c == null
                      ? const SearchFilters(time: TimeLimit.m20)
                      : SearchFilters.fromCollection(c.filter, title: c.title),
                ),
              );
            },
          ),
          _Shelf(
            title: 'Most saved',
            note: 'everyone loves these',
            slice: state.mostSaved,
            onSeeAll: () => unawaited(context.openSearch()),
          ),
          _Shelf(
            title: 'Fresh in',
            note: 'just shared',
            slice: state.newest,
            onSeeAll: () => unawaited(
              context.openSearch(const SearchFilters(sort: SearchSort.newest)),
            ),
          ),
        ],
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const new({required this.collection});

  static const _ink = Color(0xFF3D2A08);
  static const _fill = Color(0xFFF5E1B5);

  final RecipeCollection collection;

  @override
  Widget build(BuildContext context) {
    final subtitle = collection.subtitle;
    final weekly = collection.kind == CollectionKind.weekly;
    return Entrance(
      delay: const Duration(milliseconds: 120),
      child: Pressable(
        semanticLabel: collection.title,
        onTap: () => unawaited(
          context.openSearch(
            SearchFilters.fromCollection(
              collection.filter,
              title: collection.title,
            ),
          ),
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 172),
          padding: const EdgeInsets.all(Spacing.gutter),
          decoration: BoxDecoration(
            color: _fill,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  AppText(
                    text: weekly ? "This week's collection" : 'Collection',
                    config: FontConfigs.stampUnitLarge,
                    color: _ink,
                  ),
                  AppText(
                    text: collection.title,
                    config: FontConfigs.h1,
                    color: _ink,
                  ),
                  if (subtitle != null) HandwrittenNote(subtitle.toLowerCase()),
                  const SizedBox(height: Spacing.s),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      AppText(
                        text: 'See recipes',
                        config: FontConfigs.body3,
                        weight: FontWeight.w700,
                        color: _ink,
                      ),
                      SpIcon(SpIcons.chevronRight, size: 16, color: _ink),
                    ],
                  ),
                ],
              ).expand(),
              const SizedBox(
                width: 132,
                height: 132,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -4,
                      top: -6,
                      child: _MiniPrint(style: CoverStyle.stew, tilt: 7),
                    ),
                    Positioned(
                      left: 0,
                      bottom: -4,
                      child: _MiniPrint(
                        style: CoverStyle.veg,
                        tilt: -6,
                        tape: -12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).paddingOnly(bottom: Spacing.xl);
  }
}

class _MiniPrint extends StatelessWidget {
  const new({required this.style, required this.tilt, this.tape});

  final CoverStyle style;
  final double tilt;
  final double? tape;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: PhotoPrint(
        tilt: tilt,
        tapeTilt: tape,
        radius: 4,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 16),
        child: RecipeCover(style: style, width: 92, height: 70, radius: 2),
      ),
    );
  }
}

class _Shelf extends StatelessWidget {
  const new({
    required this.title,
    required this.note,
    required this.slice,
    required this.onSeeAll,
  });

  final String title;
  final String note;
  final FeedSlice<List<RecipeCard>> slice;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cards = slice.value?.value ?? const <RecipeCard>[];
    if (slice.isSuccessful && cards.isEmpty) return const SizedBox.shrink();
    if (slice.isError) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Entrance(
          delay: const Duration(milliseconds: 160),
          child: SectionHeader(
            title: title,
            note: note,
            actionLabel: 'See all',
            onAction: onSeeAll,
          ),
        ),
        if (slice.isInProgress || slice.isIdle)
          const ShelfSkeleton().paddingOnly(top: Spacing.s)
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.fromLTRB(4, 10, Spacing.gutter, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Spacing.m,
              children: [
                for (final (i, card) in cards.indexed)
                  ShelfPrintCard(
                    card: card,
                    delay: Duration(milliseconds: 160 + 70 * i.clamp(0, 5)),
                    onTap: () => unawaited(context.openRecipe(card)),
                  ),
              ],
            ),
          ),
        const SizedBox(height: Spacing.l),
      ],
    );
  }
}

class _DiscoverSkeleton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.m,
      children: [
        Skeleton(height: 172, radius: 28),
        SizedBox(height: Spacing.s),
        Skeleton(width: 150, height: 22),
        ShelfSkeleton(),
      ],
    );
  }
}
