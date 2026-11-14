import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/supabase_guard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BrowseApi {
  Future<List<JsonRow>> collections();

  Future<List<JsonRow>> collectionRecipes(
    String slug, {
    required int limit,
    required int offset,
  });

  Future<List<JsonRow>> trending({required int limit});

  Future<List<JsonRow>> search(
    SearchFilters filters, {
    required int limit,
    required int offset,
  });

  Future<List<JsonRow>> people(String query, {required int limit});

  Future<Map<String, String>> signCovers(List<String> paths);
}

class SupabaseBrowseApi implements BrowseApi {
  new(this._client);

  static const coverBucket = 'recipe-photos';
  static const int _signedFor = 60 * 60 * 24 * 7;

  final SupabaseClient _client;

  @override
  Future<List<JsonRow>> collections() => supabaseGuard(
    () => _client.from('collections').select().order('position'),
  );

  @override
  Future<List<JsonRow>> collectionRecipes(
    String slug, {
    required int limit,
    required int offset,
  }) => _rows('collection_recipes', {
    'collection_slug': slug,
    'lim': limit,
    'off': offset,
  });

  @override
  Future<List<JsonRow>> trending({required int limit}) =>
      _rows('trending_recipes', {'lim': limit});

  @override
  Future<List<JsonRow>> search(
    SearchFilters filters, {
    required int limit,
    required int offset,
  }) => _rows('search_recipes', filters.toRpc(limit: limit, offset: offset));

  @override
  Future<List<JsonRow>> people(String query, {required int limit}) {
    final safe = query.toLowerCase().replaceAll(RegExp('[^a-z0-9._ ]'), '');
    if (safe.trim().length < 2) return Future.value(const []);
    final me = _client.auth.currentUser?.id;
    return supabaseGuard(() {
      var q = _client
          .from('profiles')
          .select('id, username, display_name, avatar_path')
          .or('username.ilike.%${safe.trim()}%,display_name.ilike.%$safe%');
      if (me != null) q = q.neq('id', me);
      return q.limit(limit);
    });
  }

  @override
  Future<Map<String, String>> signCovers(List<String> paths) async {
    if (paths.isEmpty) return const {};
    final signed = await supabaseGuard(
      () => _client.storage
          .from(coverBucket)
          .createSignedUrlsResult(paths, _signedFor),
    );
    return {
      for (final s in signed)
        if (s case SignedUrlSuccess(:final path, :final signedUrl))
          path: signedUrl,
    };
  }

  Future<List<JsonRow>> _rows(String fn, JsonRow params) =>
      supabaseGuard(() async {
        final result = await _client.rpc<List<dynamic>>(fn, params: params);
        return result.cast<JsonRow>();
      });
}

class OfflineBrowseApi implements BrowseApi {
  const new();

  static const _failure = RemoteFailure(
    'This build has no backend configured',
    isTransient: true,
    code: RemoteFailure.noBackend,
  );

  @override
  Future<List<JsonRow>> collections() => Future.error(_failure);

  @override
  Future<List<JsonRow>> collectionRecipes(
    String slug, {
    required int limit,
    required int offset,
  }) => Future.error(_failure);

  @override
  Future<List<JsonRow>> trending({required int limit}) =>
      Future.error(_failure);

  @override
  Future<List<JsonRow>> search(
    SearchFilters filters, {
    required int limit,
    required int offset,
  }) => Future.error(_failure);

  @override
  Future<List<JsonRow>> people(String query, {required int limit}) =>
      Future.error(_failure);

  @override
  Future<Map<String, String>> signCovers(List<String> paths) =>
      Future.value(const {});
}
