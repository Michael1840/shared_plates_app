import 'dart:async';
import 'dart:io';

import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRemoteStore implements RemoteStore {
  new(this._client);

  static const _timeout = Duration(seconds: 20);
  static const _permanentPrefixes = ['22', '23', '42', 'P0'];

  final SupabaseClient _client;

  @override
  String? get userId => _client.auth.currentUser?.id;

  @override
  Future<void> upsert(
    String table,
    JsonRow row, {
    String? onConflict,
    bool ignoreDuplicates = false,
  }) => _guard(
    () => _client
        .from(table)
        .upsert(
          row,
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        ),
  );

  @override
  Future<void> delete(String table, Map<String, Object> match) =>
      _guard(() => _client.from(table).delete().match(match));

  @override
  Future<Object?> rpc(String function, JsonRow params) =>
      _guard(() => _client.rpc<Object?>(function, params: params));

  @override
  Future<List<JsonRow>> fetchChanged(
    String table, {
    required List<String> orderKeys,
    required int from,
    required int to,
    DateTime? since,
    Map<String, Object> match = const {},
  }) => _guard(() {
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
    return await _guard(
      () => _client.from(table).select().inFilter(column, values),
    );
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on PostgrestException catch (e) {
      final code = e.code ?? '';
      final permanent = _permanentPrefixes.any(code.startsWith);
      throw RemoteFailure(e.message, isTransient: !permanent, code: code);
    } on AuthException catch (e) {
      throw RemoteFailure(e.message, isTransient: true, code: e.code);
    } on SocketException catch (e) {
      throw RemoteFailure(e.message, isTransient: true);
    } on TimeoutException {
      throw const RemoteFailure('Timed out', isTransient: true);
    } on HttpException catch (e) {
      throw RemoteFailure(e.message, isTransient: true);
    } on Exception catch (e) {
      throw RemoteFailure(e.toString(), isTransient: true);
    }
  }
}
