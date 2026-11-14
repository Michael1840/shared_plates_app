import 'package:equatable/equatable.dart';

enum SearchScope {
  everyone('Everyone'),
  friends('Friends'),
  mine('Just mine'),
  saved('Saved');

  new(this.label);

  final String label;
}

enum SearchSort {
  mostSaved('Most saved', 'most_saved'),
  newest('Newest', 'newest'),
  cheapest('Cheapest', 'cheapest'),
  quickest('Quickest', 'quickest'),
  relevance('Best match', 'relevance');

  new(this.label, this.api);

  final String label;
  final String api;

  static SearchSort fromApi(String? value) => values.firstWhere(
    (s) => s.api == value,
    orElse: () => SearchSort.mostSaved,
  );
}

enum CostLimit {
  any('Any', null),
  r50('Under R50', 5000),
  r100('Under R100', 10000),
  r200('Under R200', 20000);

  new(this.label, this.cents);

  final String label;
  final int? cents;

  static CostLimit fromCents(int? cents) =>
      values.firstWhere((c) => c.cents == cents, orElse: () => CostLimit.any);
}

enum TimeLimit {
  any('Any', null),
  m15('15 min', 15),
  m20('20 min or less', 20),
  m30('30 min', 30),
  h1('1 hour', 60);

  new(this.label, this.minutes);

  final String label;
  final int? minutes;

  static TimeLimit fromMinutes(int? minutes) => values.firstWhere(
    (t) => t.minutes == minutes,
    orElse: () => TimeLimit.any,
  );
}

class SearchFilters extends Equatable {
  const new({
    this.query = '',
    this.cost = CostLimit.any,
    this.time = TimeLimit.any,
    this.tagSlugs = const {},
    this.scope = SearchScope.everyone,
    this.sort = SearchSort.mostSaved,
    this.title,
  });

  factory fromCollection(Map<String, dynamic> filter, {String? title}) =>
      SearchFilters(
        cost: CostLimit.fromCents((filter['max_total_cost'] as num?)?.toInt()),
        time: TimeLimit.fromMinutes((filter['max_minutes'] as num?)?.toInt()),
        tagSlugs: {
          for (final t in (filter['tags'] as List<dynamic>?) ?? const []) '$t',
        },
        sort: SearchSort.fromApi(filter['sort'] as String?),
        title: title,
      );

  static const dietSlugs = {
    'veggie': 'Vegetarian',
    'vegan': 'Vegan',
    'halal': 'Halal',
    'gluten-free': 'Gluten-free',
    'dairy-free': 'Dairy-free',
  };

  final String query;
  final CostLimit cost;
  final TimeLimit time;
  final Set<String> tagSlugs;
  final SearchScope scope;
  final SearchSort sort;
  final String? title;

  String get trimmedQuery => query.trim();

  int get activeCount =>
      (cost == CostLimit.any ? 0 : 1) +
      (time == TimeLimit.any ? 0 : 1) +
      tagSlugs.length +
      (scope == SearchScope.everyone ? 0 : 1);

  bool get isEmpty => trimmedQuery.isEmpty && activeCount == 0;

  SearchFilters copyWith({
    String? query,
    CostLimit? cost,
    TimeLimit? time,
    Set<String>? tagSlugs,
    SearchScope? scope,
    SearchSort? sort,
    String? title,
    bool clearTitle = false,
  }) => SearchFilters(
    query: query ?? this.query,
    cost: cost ?? this.cost,
    time: time ?? this.time,
    tagSlugs: tagSlugs ?? this.tagSlugs,
    scope: scope ?? this.scope,
    sort: sort ?? this.sort,
    title: clearTitle ? null : title ?? this.title,
  );

  SearchFilters cleared() => SearchFilters(
    query: query,
    sort: sort == SearchSort.relevance ? sort : SearchSort.mostSaved,
  );

  Map<String, dynamic> toRpc({required int limit, required int offset}) => {
    'q': trimmedQuery.isEmpty ? null : trimmedQuery,
    'max_total_cost': cost.cents,
    'max_minutes': time.minutes,
    'tag_slugs': tagSlugs.isEmpty ? null : tagSlugs.toList(),
    'scope': scope.name,
    'sort': trimmedQuery.isNotEmpty && sort == SearchSort.mostSaved
        ? SearchSort.relevance.api
        : sort.api,
    'lim': limit,
    'off': offset,
  };

  String get cacheKey {
    final tags = tagSlugs.toList()..sort();
    return [
      trimmedQuery.toLowerCase(),
      cost.name,
      time.name,
      tags.join('+'),
      scope.name,
      sort.name,
    ].join('|');
  }

  @override
  List<Object?> get props => [query, cost, time, tagSlugs, scope, sort, title];
}
