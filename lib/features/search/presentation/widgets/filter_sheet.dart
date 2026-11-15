import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/search/presentation/bloc/filter_cubit.dart';

extension FilterSheetContext on BuildContext {
  Future<SearchFilters?> showFilters(SearchFilters initial) =>
      bottomSheet<SearchFilters>(
        BlocProvider(
          create: (_) =>
              FilterCubit(sl<BrowseRepository>(), initial: initial)..start(),
          child: const FilterSheet(),
        ),
      );
}

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  static const List<SearchSort> _sorts = [
    SearchSort.mostSaved,
    SearchSort.newest,
    SearchSort.cheapest,
    SearchSort.quickest,
  ];
  static const List<TimeLimit> _times = [
    TimeLimit.any,
    TimeLimit.m15,
    TimeLimit.m30,
    TimeLimit.h1,
  ];
  static const List<SearchScope> _scopes = [
    SearchScope.everyone,
    SearchScope.friends,
    SearchScope.mine,
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterCubit>();
    final state = context.watch<FilterCubit>().state;
    final f = state.filters;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Entrance(
              delay: const Duration(milliseconds: 60),
              child: Semantics(
                header: true,
                child: const AppText(text: 'Filters', config: FontConfigs.h1),
              ),
            ),
            const SizedBox(width: Spacing.s),
            const HandwrittenNote('narrow it down').expand(),
            const Paprika(
              mood: PaprikaMood.thinking,
              size: 64,
              tilt: 8,
              decorative: true,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextLinkButton(
            label: 'Clear all',
            color: context.primaryDeep,
            onTap: f.activeCount == 0 ? null : cubit.clear,
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 14,
              children: [
                _Group(
                  title: 'Total cost',
                  children: [
                    for (final c in CostLimit.values)
                      SpChip(
                        label: c.label,
                        selected: f.cost == c,
                        onTap: () => cubit.setCost(c),
                      ),
                  ],
                ),
                _Group(
                  title: 'Time',
                  children: [
                    for (final t in _times)
                      SpChip(
                        label: t.label,
                        selected: f.time == t,
                        onTap: () => cubit.setTime(t),
                      ),
                  ],
                ),
                _Group(
                  title: 'Diet',
                  hint: '· pick any',
                  children: [
                    for (final e in SearchFilters.dietSlugs.entries)
                      SpChip(
                        label: e.value,
                        selected: f.tagSlugs.contains(e.key),
                        onTap: () => cubit.toggleDiet(e.key),
                      ),
                  ],
                ),
                _Group(
                  title: 'From',
                  children: [
                    for (final s in _scopes)
                      SpChip(
                        label: s.label,
                        selected: f.scope == s,
                        onTap: () => cubit.setScope(s),
                      ),
                  ],
                ),
                _Group(
                  title: 'Sort by',
                  children: [
                    for (final s in _sorts)
                      SpChip(
                        label: s.label,
                        selected: f.sort == s,
                        onTap: () => cubit.setSort(s),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.l),
        PrimaryButton(
          label: state.applyLabel,
          onTap: () => Navigator.of(context).pop(f),
        ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children, this.hint});

  final String title;
  final String? hint;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final extra = hint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xs,
      children: [
        Semantics(
          header: true,
          child: Row(
            spacing: Spacing.xxs,
            children: [
              AppText(text: title, config: FontConfigs.h5),
              if (extra != null)
                AppText.secondary(
                  text: extra,
                  config: FontConfigs.body3,
                  color: context.textMuted,
                ),
            ],
          ),
        ),
        Wrap(spacing: Spacing.xs, runSpacing: Spacing.xs, children: children),
      ],
    );
  }
}
