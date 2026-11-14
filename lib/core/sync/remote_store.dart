import 'dart:typed_data';

typedef JsonRow = Map<String, dynamic>;

class RemoteFailure implements Exception {
  const new(this.message, {required this.isTransient, this.code});

  static const noBackend = 'no-backend';

  final String message;
  final bool isTransient;
  final String? code;

  @override
  String toString() => 'RemoteFailure($code): $message';
}

abstract interface class RemoteStore {
  String? get userId;

  Future<void> upsert(
    String table,
    JsonRow row, {
    String? onConflict,
    bool ignoreDuplicates = false,
  });

  Future<void> upsertMany(
    String table,
    List<JsonRow> rows, {
    String? onConflict,
    bool ignoreDuplicates = false,
  });

  Future<void> upload(
    String bucket,
    String path,
    Uint8List bytes, {
    required String contentType,
  });

  Future<void> update(
    String table,
    JsonRow values, {
    required Map<String, Object> match,
  });

  Future<void> delete(String table, Map<String, Object> match);

  Future<Object?> rpc(String function, JsonRow params);

  Future<List<JsonRow>> fetchChanged(
    String table, {
    required List<String> orderKeys,
    required int from,
    required int to,
    DateTime? since,
    Map<String, Object> match = const {},
  });

  Future<List<JsonRow>> fetchIn(
    String table, {
    required String column,
    required List<Object> values,
  });
}
