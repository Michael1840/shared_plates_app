import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';

JsonRow cardRow(
  String id, {
  String title = 'Curry',
  bool saved = false,
  bool liked = false,
  String? cover,
}) => {
  'id': id,
  'author_id': 'author',
  'author_name': 'Lerato Mokoena',
  'title': title,
  'cover_style': 'stew',
  'cover_path': cover,
  'updated_at': '2026-11-13T21:00:00Z',
  'is_saved': saved,
  'is_liked': liked,
};

class FakeBrowseApi implements BrowseApi {
  List<JsonRow> collectionRows = [];
  List<JsonRow> trendingRows = [];
  List<JsonRow> searchRows = [];
  List<JsonRow> peopleRows = [];
  RemoteFailure? failure;
  final List<SearchFilters> searches = [];
  final List<int> offsets = [];

  Future<T> _answer<T>(T value) =>
      failure == null ? Future.value(value) : Future.error(failure!);

  @override
  Future<List<JsonRow>> collections() => _answer(collectionRows);

  @override
  Future<List<JsonRow>> collectionRecipes(
    String slug, {
    required int limit,
    required int offset,
  }) => _answer(trendingRows);

  @override
  Future<List<JsonRow>> trending({required int limit}) => _answer(trendingRows);

  @override
  Future<List<JsonRow>> search(
    SearchFilters filters, {
    required int limit,
    required int offset,
  }) {
    searches.add(filters);
    offsets.add(offset);
    final page = searchRows.skip(offset).take(limit).toList();
    return _answer(page);
  }

  @override
  Future<List<JsonRow>> people(String query, {required int limit}) =>
      _answer(peopleRows);

  @override
  Future<Map<String, String>> signCovers(List<String> paths) =>
      _answer({for (final p in paths) p: 'https://img/$p'});
}
