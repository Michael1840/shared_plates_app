import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/profile/domain/popular_cook.dart';
import 'package:shared_plates_app/features/search/presentation/bloc/filter_cubit.dart';
import 'package:shared_plates_app/features/search/presentation/bloc/search_cubit.dart';

import '../../helpers/mocks.dart';

RecipeCard _card(String id) =>
    RecipeCard(id: id, authorId: 'a', title: id, updatedAt: DateTime.utc(2026));

Result<Feed<List<RecipeCard>>> _page(int count, {int start = 0}) => Result.ok(
  Feed([
    for (var i = start; i < start + count; i++) _card('r$i'),
  ], fetchedAt: DateTime.utc(2026, 11, 14)),
);

void main() {
  late MockBrowseRepository browse;
  late MockProfileRepository profiles;

  setUpAll(() => registerFallbackValue(const SearchFilters()));

  setUp(() {
    browse = MockBrowseRepository();
    profiles = MockProfileRepository();
    when(() => profiles.watchTags()).thenAnswer((_) => Stream.value(const []));
  });

  SearchCubit build({SearchFilters initial = const SearchFilters()}) =>
      SearchCubit(
        browse,
        profiles,
        initial: initial,
        debounce: const Duration(milliseconds: 10),
      );

  group('SearchCubit', () {
    blocTest<SearchCubit, SearchState>(
      'debounces typing into one search',
      setUp: () =>
          when(() => browse.search(any(), limit: any(named: 'limit')))
              .thenAnswer((_) async => _page(3)),
      build: build,
      act: (c) async {
        c
          ..queryChanged('c')
          ..queryChanged('cu')
          ..queryChanged('curry');
        await Future<void>.delayed(const Duration(milliseconds: 40));
      },
      verify: (c) {
        final captured = verify(
          () => browse.search(captureAny(), limit: any(named: 'limit')),
        ).captured;
        expect(captured, hasLength(1));
        expect((captured.single as SearchFilters).query, 'curry');
        expect(c.state.recipeList, hasLength(3));
        expect(c.state.hasMore, isFalse);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'loads the next page when there are more results',
      setUp: () {
        when(() => browse.search(any(), limit: any(named: 'limit')))
            .thenAnswer((_) async => _page(20));
        when(() => browse.search(any(), limit: any(named: 'limit'), offset: 20))
            .thenAnswer((_) async => _page(5, start: 20));
      },
      build: build,
      act: (c) async {
        await c.submit();
        await c.loadMore();
      },
      verify: (c) {
        expect(c.state.recipeList, hasLength(25));
        expect(c.state.hasMore, isFalse);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'reports no results',
      setUp: () =>
          when(() => browse.search(any(), limit: any(named: 'limit')))
              .thenAnswer((_) async => _page(0)),
      build: build,
      act: (c) => c.submit(),
      verify: (c) => expect(c.state.noResults, isTrue),
    );

    blocTest<SearchCubit, SearchState>(
      'searches people when that tab opens',
      setUp: () {
        when(() => browse.search(any(), limit: any(named: 'limit')))
            .thenAnswer((_) async => _page(1));
        when(() => browse.people('aisha')).thenAnswer(
          (_) async => const Result.ok([
            PopularCook(id: 'p1', username: 'aisha', displayName: 'Aisha'),
          ]),
        );
      },
      build: () => build(initial: const SearchFilters(query: 'aisha')),
      act: (c) async {
        await c.submit();
        c.setTab(SearchTab.people);
        await Future<void>.delayed(Duration.zero);
      },
      verify: (c) => expect(c.state.people.value, hasLength(1)),
    );
  });

  group('FilterCubit', () {
    test('labels the apply button from the preview count', () {
      const base = FilterState(filters: SearchFilters());
      expect(base.applyLabel, 'Show recipes');
      expect(
        const FilterState(
          filters: SearchFilters(),
          preview: DelayedResult.fromValue(1),
        ).applyLabel,
        'Show 1 recipe',
      );
    });

    blocTest<FilterCubit, FilterState>(
      'previews the count after a change',
      setUp: () =>
          when(() => browse.search(any(), limit: FilterState.previewLimit))
              .thenAnswer((_) async => _page(50)),
      build: () => FilterCubit(
        browse,
        initial: const SearchFilters(),
        debounce: Duration.zero,
      ),
      act: (c) async {
        c.setCost(CostLimit.r100);
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      verify: (c) {
        expect(c.state.filters.cost, CostLimit.r100);
        expect(c.state.applyLabel, 'Show 50+ recipes');
      },
    );

    blocTest<FilterCubit, FilterState>(
      'clearing keeps the query',
      build: () => FilterCubit(
        browse,
        initial: const SearchFilters(
          query: 'bobotie',
          cost: CostLimit.r50,
          tagSlugs: {'halal'},
        ),
        debounce: const Duration(days: 1),
      ),
      act: (c) => c.clear(),
      verify: (c) {
        expect(c.state.filters.query, 'bobotie');
        expect(c.state.filters.activeCount, 0);
      },
    );
  });

  group('SearchFilters', () {
    test('maps a collection filter', () {
      final f = SearchFilters.fromCollection(const {
        'max_total_cost': 10000,
        'max_minutes': 20,
        'tags': ['braai'],
        'sort': 'quickest',
      }, title: 'Braai night');

      expect(f.cost, CostLimit.r100);
      expect(f.time, TimeLimit.m20);
      expect(f.tagSlugs, {'braai'});
      expect(f.sort, SearchSort.quickest);
      expect(f.title, 'Braai night');
      expect(f.activeCount, 3);
    });

    test('ranks by relevance when there is a query', () {
      const f = SearchFilters(query: ' curry ');
      final rpc = f.toRpc(limit: 20, offset: 0);
      expect(rpc['q'], 'curry');
      expect(rpc['sort'], 'relevance');
      expect(rpc['tag_slugs'], isNull);
    });
  });
}
