import 'package:shared_plates_app/core/sync/remote_store.dart';

class OfflineRemoteStore implements RemoteStore {
  const new();

  static const _failure = RemoteFailure(
    'This build has no backend configured',
    isTransient: true,
  );

  @override
  String? get userId => null;

  @override
  Future<void> upsert(
    String table,
    JsonRow row, {
    String? onConflict,
    bool ignoreDuplicates = false,
  }) => Future.error(_failure);

  @override
  Future<void> update(
    String table,
    JsonRow values, {
    required Map<String, Object> match,
  }) => Future.error(_failure);

  @override
  Future<void> delete(String table, Map<String, Object> match) =>
      Future.error(_failure);

  @override
  Future<Object?> rpc(String function, JsonRow params) =>
      Future.error(_failure);

  @override
  Future<List<JsonRow>> fetchChanged(
    String table, {
    required List<String> orderKeys,
    required int from,
    required int to,
    DateTime? since,
    Map<String, Object> match = const {},
  }) => Future.error(_failure);

  @override
  Future<List<JsonRow>> fetchIn(
    String table, {
    required String column,
    required List<Object> values,
  }) => Future.error(_failure);
}
