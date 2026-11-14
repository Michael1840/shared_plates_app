import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/person_row.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/status_note.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/recipe_row_card.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/search/presentation/bloc/search_cubit.dart';
import 'package:shared_plates_app/features/search/presentation/widgets/filter_sheet.dart';

class SearchPage extends StatelessWidget {
  const new({super.key, this.initial = const SearchFilters()});

  final SearchFilters initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = SearchCubit(
          sl<BrowseRepository>(),
          sl<ProfileRepository>(),
          initial: initial,
        );
        unawaited(cubit.start());
        return cubit;
      },
      child: const Scaffold(body: DotGridBackground(child: _SearchView())),
    );
  }
}

class _SearchView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final tab = context.select<SearchCubit, SearchTab>((c) => c.state.tab);
    return Column(
      children: [
        const _SearchHeader(),
        NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.extentAfter < 400) {
              unawaited(context.read<SearchCubit>().loadMore());
            }
            return false;
          },
          child: RefreshIndicator(
            color: context.primary,
            onRefresh: context.read<SearchCubit>().retry,
            child: tab == SearchTab.recipes
                ? const _RecipeResults()
                : const _PeopleResults(),
          ),
        ).expand(),
      ],
    );
  }
}

class _SearchHeader extends StatefulWidget {
  const new();

  @override
  State<_SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<_SearchHeader> {
  late final SearchCubit _cubit = context.read<SearchCubit>();
  late final TextEditingController _controller = TextEditingController(
    text: _cubit.state.filters.query,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    _cubit.queryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    final title = state.filters.title;
    return HeaderBlock(
      radius: 36,
      bottomPadding: Spacing.gutter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: Spacing.xs,
            children: [
              HeaderIconButton(
                icon: SpIcons.chevronLeft,
                semanticLabel: 'Back',
                onTap: () => context.pop(),
              ),
              Entrance(
                delay: const Duration(milliseconds: 140),
                child: _QueryField(
                  controller: _controller,
                  hint: title ?? 'Search recipes or people',
                  autofocus: state.filters.isEmpty && title == null,
                  onChanged: _cubit.queryChanged,
                  onSubmitted: (_) => _cubit.submit(),
                  onClear: _clear,
                ),
              ).expand(),
            ],
          ),
          const SizedBox(height: 14),
          _Tabs(state: state),
        ],
      ),
    );
  }
}

class _QueryField extends StatelessWidget {
  const new({
    required this.controller,
    required this.hint,
    required this.autofocus,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hint;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return Container(
      height: Sizes.searchBar,
      padding: const EdgeInsets.only(left: Spacing.s, right: 4),
      decoration: BoxDecoration(
        color: sp.searchFill,
        borderRadius: BorderRadius.circular(Rounding.pill),
        boxShadow: [
          BoxShadow(
            color: sp.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        spacing: Spacing.xs,
        children: [
          SpIcon(SpIcons.search, color: context.textMuted),
          TextField(
            controller: controller,
            autofocus: autofocus,
            textInputAction: TextInputAction.search,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            cursorColor: sp.primary,
            style: context.textStyle(
              FontConfigs.body2,
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: context.textStyle(
                FontConfigs.body2,
                color: context.textMuted,
              ),
            ),
          ).expand(),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, _) => Pressable(
              onTap: value.text.isEmpty ? null : onClear,
              semanticLabel: 'Clear search',
              child: AnimatedOpacity(
                opacity: value.text.isEmpty ? 0 : 1,
                duration: context.motion(Motion.small),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: sp.background,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SpIcon(
                    SpIcons.close,
                    size: 18,
                    color: context.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const new({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final recipes = state.recipes.value?.value.length;
    final people = state.people.value?.length;
    String count(int? n, {required bool more}) =>
        n == null ? '' : ' · $n${more ? '+' : ''}';
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.sp.onHeader.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        spacing: 4,
        children: [
          _TabButton(
            label: 'Recipes${count(recipes, more: state.hasMore)}',
            selected: state.tab == SearchTab.recipes,
            onTap: () => context.read<SearchCubit>().setTab(SearchTab.recipes),
          ).expand(),
          _TabButton(
            label: 'People${count(people, more: false)}',
            selected: state.tab == SearchTab.people,
            onTap: () => context.read<SearchCubit>().setTab(SearchTab.people),
          ).expand(),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const new({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: context.motion(Motion.medium),
          curve: Motion.arrive,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? sp.onHeader : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: AppText(
            text: label,
            config: FontConfigs.body3,
            weight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? sp.primaryDeep : sp.onHeader,
          ),
        ),
      ),
    );
  }
}

class _RecipeResults extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    final recipes = state.recipes;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final error = recipes.error;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        Spacing.gutter,
        Spacing.m,
        Spacing.gutter,
        bottom + Spacing.l,
      ),
      children: [
        _FilterRow(filters: state.filters),
        if (recipes.isStale) StatusNote.offline().paddingOnly(top: Spacing.m),
        if (recipes.isInProgress || recipes.isIdle)
          for (var i = 0; i < 5; i++)
            const RecipeRowSkeleton().paddingOnly(top: 10)
        else if (error != null)
          EmptyState(
            mood: PaprikaMood.oops,
            title: BrowseMessages.titleFor(error),
            body: error,
            actions: [
              CompactButton(
                label: 'Try again',
                onTap: context.read<SearchCubit>().retry,
              ),
            ],
          )
        else if (state.noResults)
          _NoResults(state: state)
        else ...[
          _CountLine(state: state),
          for (final (i, card) in state.recipeList.indexed)
            Entrance.staggered(
              index: i,
              child: RecipeRowCard(
                card: card,
                onTap: () => context.openRecipe(card),
              ),
            ).paddingOnly(bottom: 10),
          if (state.loadingMore) const RecipeRowSkeleton(),
        ],
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const new({required this.filters});

  final SearchFilters filters;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    Future<void> openSheet() async {
      final next = await context.showFilters(filters);
      if (next != null) await cubit.applyFilters(next);
    }

    final active = filters.activeCount;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        spacing: Spacing.xs,
        children: [
          SpChip(
            label: active == 0 ? 'Filters' : 'Filters · $active',
            icon: SpIcons.filter,
            selected: false,
            onTap: openSheet,
          ),
          if (filters.cost != CostLimit.any)
            _RemovableChip(
              label: filters.cost.label,
              onRemove: () => cubit.applyFilters(
                filters.copyWith(cost: CostLimit.any, clearTitle: true),
              ),
            ),
          if (filters.time != TimeLimit.any)
            _RemovableChip(
              label: filters.time.label,
              onRemove: () => cubit.applyFilters(
                filters.copyWith(time: TimeLimit.any, clearTitle: true),
              ),
            ),
          for (final slug in filters.tagSlugs)
            _RemovableChip(
              label: SearchFilters.dietSlugs[slug] ?? slug.replaceAll('-', ' '),
              onRemove: () => cubit.applyFilters(
                filters.copyWith(
                  tagSlugs: {...filters.tagSlugs}..remove(slug),
                  clearTitle: true,
                ),
              ),
            ),
          if (filters.scope != SearchScope.everyone)
            _RemovableChip(
              label: filters.scope.label,
              onRemove: () => cubit.applyFilters(
                filters.copyWith(scope: SearchScope.everyone, clearTitle: true),
              ),
            ),
          if (filters.time == TimeLimit.any)
            SpChip(
              label: '30 min or less',
              selected: false,
              onTap: () => cubit.applyFilters(
                filters.copyWith(time: TimeLimit.m30, clearTitle: true),
              ),
            ),
          if (filters.scope == SearchScope.everyone)
            SpChip(
              label: 'From friends',
              selected: false,
              onTap: () => cubit.applyFilters(
                filters.copyWith(scope: SearchScope.friends, clearTitle: true),
              ),
            ),
        ],
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  const new({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      hint: 'Double tap to remove',
      child: SpChip(
        label: label,
        icon: SpIcons.close,
        selected: true,
        onTap: onRemove,
      ),
    );
  }
}

class _CountLine extends StatelessWidget {
  const new({required this.state});

  static const _notes = [
    'winner winner!',
    'good pickings',
    'ooh, options',
    'dig in',
  ];

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final n = state.recipeList.length;
    final noun = n == 1 ? 'recipe' : 'recipes';
    final note = _notes[state.filters.cacheKey.hashCode.abs() % _notes.length];
    return Row(
      children: [
        AppText.secondary(
          text: '$n${state.hasMore ? '+' : ''} $noun · ',
          config: FontConfigs.sublabel1,
          color: context.textMuted,
        ),
        HandwrittenNote(note).expand(),
        TextLinkButton(
          label: state.filters.sort.label,
          color: context.textPrimary,
          onTap: () async {
            final cubit = context.read<SearchCubit>();
            final next = await context.showFilters(state.filters);
            if (next != null) await cubit.applyFilters(next);
          },
        ),
      ],
    ).paddingOnly(top: Spacing.xs, bottom: Spacing.xs);
  }
}

class _NoResults extends StatelessWidget {
  const new({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final q = state.filters.trimmedQuery;
    final filtered = state.filters.activeCount > 0;
    return Column(
      children: [
        EmptyState(
          mood: PaprikaMood.oops,
          note: 'well, this is awkward',
          title: q.isEmpty ? 'Nothing matches yet' : 'No $q recipes yet',
          body: filtered
              ? 'Try loosening a filter or two.'
              : 'Nobody has shared one, so yours would be the first. '
                    'Or try something close:',
          actions: [
            if (filtered)
              SpChip(
                label: 'Clear filters',
                selected: false,
                onTap: () => cubit.applyFilters(state.filters.cleared()),
              )
            else
              for (final tag in state.suggestions.take(3))
                SpChip(
                  label: tag.label,
                  selected: false,
                  onTap: () => cubit.applyFilters(
                    SearchFilters(tagSlugs: {tag.slug}, title: tag.label),
                  ),
                ),
          ],
        ),
        if (q.isNotEmpty)
          PrimaryButton(
            label: 'Share your $q',
            onTap: () => context.push(Routes.create),
          ),
      ],
    );
  }
}

class _PeopleResults extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    final people = state.people;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final list = people.value ?? const [];
    final error = people.error;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        Spacing.gutter,
        Spacing.m,
        Spacing.gutter,
        bottom + Spacing.l,
      ),
      children: [
        if (people.isInProgress || people.isIdle)
          for (var i = 0; i < 4; i++)
            const Skeleton(height: 68, radius: 18).paddingOnly(bottom: 8)
        else if (error != null)
          EmptyState(
            mood: PaprikaMood.oops,
            title: BrowseMessages.titleFor(error),
            body: error,
          )
        else if (list.isEmpty)
          EmptyState(
            mood: PaprikaMood.thinking,
            title: state.filters.trimmedQuery.length < 2
                ? 'Who are you looking for?'
                : 'No one by that name',
            body: 'Search by name or @username.',
          )
        else
          for (final (i, person) in list.indexed)
            Entrance.staggered(
              index: i,
              child: PersonRow(
                cook: person,
                index: i,
                requested: state.requested.contains(person.id),
                onAdd: () =>
                    context.read<SearchCubit>().requestFriend(person.id),
              ),
            ).paddingOnly(bottom: 8),
      ],
    );
  }
}
