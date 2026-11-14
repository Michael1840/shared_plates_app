import 'dart:typed_data';

import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/supabase_guard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRemoteStore implements RemoteStore {
  new(this._client);

  final SupabaseClient _client;

  @override
  String? get userId => _client.auth.currentUser?.id;

  @override
  Future<void> upsert(
    String table,
    JsonRow row, {
    String? onConflict,
    bool ignoreDuplicates = false,
  }) => supabaseGuard(
    () => _client
        .from(table)
        .upsert(
          row,
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        ),
  );

  @override
  Future<void> upsertMany(
    String table,
    List<JsonRow> rows, {
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    if (rows.isEmpty) return;
    await supabaseGuard(
      () => _client
          .from(table)
          .upsert(
            rows,
            onConflict: onConflict,
            ignoreDuplicates: ignoreDuplicates,
          ),
    );
  }

  @override
  Future<void> upload(
    String bucket,
    String path,
    Uint8List bytes, {
    required String contentType,
  }) => supabaseGuard(
    () => _client.storage
        .from(bucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        ),
  );

  @override
  Future<void> update(
    String table,
    JsonRow values, {
    required Map<String, Object> match,
  }) => supabaseGuard(() => _client.from(table).update(values).match(match));

  @override
  Future<void> delete(String table, Map<String, Object> match) =>
      supabaseGuard(() => _client.from(table).delete().match(match));

  @override
  Future<Object?> rpc(String function, JsonRow params) =>
      supabaseGuard(() => _client.rpc<Object?>(function, params: params));

  @override
  Future<List<JsonRow>> fetchChanged(
    String table, {
    required List<String> orderKeys,
    required int from,
    required int to,
    DateTime? since,
    Map<String, Object> match = const {},
  }) => supabaseGuard(() {
    var query = _client.from(table).select().match(match);
    final after = since;
    if (after != null) {
      query = query.gt('updated_at', after.toUtc().toIso8601String());
    }
    var ordered = query.order('updated_at', ascending: true);
    for (final key in orderKeys) {
      ordered = ordered.order(key, ascending: true);
    }
    return ordered.range(from, to);
  });

  @override
  Future<List<JsonRow>> fetchIn(
    String table, {
    required String column,
    required List<Object> values,
  }) async {
    if (values.isEmpty) return const [];
    return await supabaseGuard(
      () => _client.from(table).select().inFilter(column, values),
    );
  }
}
